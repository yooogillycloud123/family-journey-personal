from __future__ import annotations
import asyncio,json,re,urllib.parse
from pathlib import Path
from .models import Favorite,Status,norm

PC_URL='https://map.naver.com/p/'
FOLDERS_READ='https://pages.map.naver.com/save-pages/api/maps-bookmark/v3/folders?start=0&limit=100&sort=lastUseTime&folderType=all'
SHARES_READ='https://pages.map.naver.com/save-pages/api/maps-bookmark/v3/shares/{share}/bookmarks?limit=5000'

class JobError(Exception):
    def __init__(self,status,detail):super().__init__(detail);self.status=status;self.detail=detail

def json_folder_match(raw, list_name):
    """Read-only Naver response adapter. The private website may change JSON shape."""
    rows=raw if isinstance(raw,list) else raw.get('folderList',raw.get('folders',raw.get('data',[])))
    if isinstance(rows,dict):rows=rows.get('folderList',rows.get('folders',rows.get('list',[])))
    if not isinstance(rows,list):return None
    matches=[x for x in rows if isinstance(x,dict) and norm(str(x.get('name',x.get('folderName',''))))==norm(list_name)]
    return matches[0] if len(matches)==1 else None

def json_bookmark_matches(raw,item:Favorite):
    rows=raw if isinstance(raw,list) else raw.get('bookmarkList',raw.get('bookmarks',raw.get('data',[])))
    if isinstance(rows,dict):rows=rows.get('bookmarkList',rows.get('bookmarks',rows.get('list',[])))
    if not isinstance(rows,list):return False
    # Stable Naver POI id preferred over ambiguous geocoded text; don't guess GPS.
    for r in rows:
        if not isinstance(r,dict):continue
        sid=str(r.get('sid',r.get('placeId',''))).strip()
        if item.naver_place_id:
            if sid and sid==item.naver_place_id:return True
            continue
        if norm(str(r.get('name','')))==norm(item.place_name) and norm(str(r.get('address','')))==norm(item.address):
            return True
    return False

class NaverPlaywrightWorker:
    """Browser UI worker; no CAPTCHA bypass, browser profile stays on user's PC."""
    def __init__(self,profile:Path,chromium_path=None,headed_worker=False):
        self.profile=Path(profile).expanduser();self.chromium_path=chromium_path;self.headed_worker=headed_worker
        self._pw=None;self.context=None

    async def start(self,headed=False):
        from playwright.async_api import async_playwright
        if self.context:return
        self.profile.mkdir(parents=True,exist_ok=True)
        self._pw=await async_playwright().start()
        try:
            opts={'user_data_dir':str(self.profile),'headless':not headed,'viewport':{'width':1420,'height':900},
                  'accept_downloads':False,'locale':'ko-KR','timezone_id':'Asia/Seoul'}
            if self.chromium_path:opts['executable_path']=self.chromium_path
            self.context=await self._pw.chromium.launch_persistent_context(**opts)
        except Exception:
            await self._pw.stop();self._pw=None;raise

    async def stop(self):
        if self.context:await self.context.close();self.context=None
        if self._pw:await self._pw.stop();self._pw=None

    async def login_visible_once(self):
        await self.start(headed=True)
        page=await self.context.new_page()
        await page.goto(PC_URL,wait_until='domcontentloaded',timeout=30000)
        print('브라우저에서 네이버 계정에 직접 로그인하세요. 완료 후 Enter를 누릅니다.')
        await asyncio.to_thread(input)
        await page.close()
        await self.stop()

    async def _get_json(self,page,url):
        await page.goto(url,wait_until='domcontentloaded',timeout=20000)
        if 'nidlogin' in page.url:raise JobError(Status.LOGIN_REQUIRED,'LOGIN_REQUIRED')
        txt=(await page.locator('body').inner_text(timeout=10000)).strip()
        try:return json.loads(txt)
        except Exception:raise JobError(Status.SUBMITTED_UNVERIFIED,'READBACK_JSON_UNAVAILABLE')

    async def _read_list(self,item:Favorite):
        page=await self.context.new_page()
        try:
            folders=await self._get_json(page,FOLDERS_READ)
            folder=json_folder_match(folders,item.list_name)
            if not folder:return (False,'LIST_NOT_FOUND')
            share=str(folder.get('shareId',folder.get('shareID','')))
            if not re.fullmatch(r'[A-Za-z0-9_-]{1,120}',share):return(False,'SHARE_ID_UNAVAILABLE')
            bookmarks=await self._get_json(page,SHARES_READ.format(share=urllib.parse.quote(share,safe='')))
            return (json_bookmark_matches(bookmarks,item),'READBACK_COMPLETE')
        finally:await page.close()

    async def process(self,item:Favorite):
        """Return (Status,detail), only exact list read-back gets VERIFIED."""
        await self.start(headed=self.headed_worker)
        page=await self.context.new_page()
        try:
            exists,_=await self._read_list(item)
            if exists:return Status.VERIFIED,'READBACK_MATCH'
            await self.ensure_list(page,item.list_name)
            sid=await self.search_and_select(page,item)
            await self.save_via_ui(page,item)
            # For text matches require a new independent list read-back, never click-only success.
            if sid and not item.naver_place_id:
                item=Favorite(**{**item.__dict__,'naver_place_id':sid})
            ok,why=await self._read_list(item)
            return (Status.VERIFIED,'READBACK_MATCH') if ok else (Status.SUBMITTED_UNVERIFIED,why)
        except JobError as ex:return ex.status,ex.detail
        except Exception as ex:
            # Avoid exposing photos, GPS, page HTML, session cookies or raw credentials in logs.
            return Status.FAILED,type(ex).__name__
        finally:await page.close()

    async def ensure_list(self,page,list_name):
        await page.goto(PC_URL,wait_until='domcontentloaded',timeout=30000)
        if 'nidlogin' in page.url:raise JobError(Status.LOGIN_REQUIRED,'LOGIN_REQUIRED')
        await page.locator("button.btn_navbar:has-text('저장')").click(timeout=10000)
        frame=page.frame(name='myPlaceBookmarkFolderListIframe')
        if not frame:
            try:await page.frame_locator('iframe[name="myPlaceBookmarkFolderListIframe"]').locator('body').wait_for(timeout=10000)
            except Exception:raise JobError(Status.LIST_CREATE_FAILED,'LIST_FRAME_MISSING')
            frame=page.frame(name='myPlaceBookmarkFolderListIframe')
        rows=await frame.locator("button[class*='_list_item_']").all_text_contents()
        # A label like '내 장소 174' is not equal to '내 장소' when creating other lists.
        if any(norm(re.sub(r'\s+\d+\s*$','',x))==norm(list_name) for x in rows):return
        try:
            await frame.get_by_role('button',name='새 리스트 만들기').click(timeout=6000)
            await frame.locator('input.swt-input-text').first.fill(list_name)
            labels=frame.locator('label.swt-save-folder-share-option-btn')
            if await labels.count():await labels.first.click()
            await frame.locator('button.swt-complete-btn').click(timeout=7000)
            # A click is only a UI submission. Validate list actually became visible.
            await frame.get_by_text(list_name,exact=False).first.wait_for(timeout=8000)
        except Exception:raise JobError(Status.LIST_CREATE_FAILED,'LIST_CREATION_NOT_CONFIRMED')

    async def search_and_select(self,page,item:Favorite):
        if item.naver_place_id:
            await page.goto(f'https://map.naver.com/p/entry/place/{item.naver_place_id}',wait_until='domcontentloaded',timeout=30000)
            return item.naver_place_id
        query=' '.join(x for x in [item.place_name,item.address] if x)
        await page.goto('https://map.naver.com/p/search/'+urllib.parse.quote(query,safe=''),wait_until='domcontentloaded',timeout=30000)
        frame=page.frame(name='searchIframe')
        if not frame:
            try:await page.frame_locator('iframe[name="searchIframe"]').locator('body').wait_for(timeout=10000)
            except Exception:raise JobError(Status.AMBIGUOUS,'RESULT_FRAME_MISSING')
            frame=page.frame(name='searchIframe')
        candidates=frame.locator('li.UEzoS,li.VLTHu')
        count=await candidates.count()
        matches=[]
        for idx in range(min(count,30)):
            row=candidates.nth(idx)
            name=await row.locator('span.TYaxT,span.YwYLL').first.inner_text() if await row.locator('span.TYaxT,span.YwYLL').count() else ''
            address=await row.locator('span.suKMR').first.inner_text() if await row.locator('span.suKMR').count() else ''
            if norm(name)==norm(item.place_name) and (not item.address or norm(item.address) in norm(address) or norm(address) in norm(item.address)):
                matches.append(row)
        if len(matches)!=1:raise JobError(Status.AMBIGUOUS,'CANDIDATES_'+str(len(matches)))
        await matches[0].click()
        entry=page.frame(name='entryIframe')
        if not entry:
            try:await page.frame_locator('iframe[name="entryIframe"]').locator('body').wait_for(timeout=10000)
            except Exception:raise JobError(Status.SUBMITTED_UNVERIFIED,'ENTRY_FRAME_MISSING')
            entry=page.frame(name='entryIframe')
        # sid not always present in the iframe URL; text+address matching stays strict.
        found=re.search(r'/place/(\d+)',entry.url)
        return found.group(1) if found else ''

    async def save_via_ui(self,page,item:Favorite):
        entry=page.frame(name='entryIframe')
        if not entry:
            try:await page.frame_locator('iframe[name="entryIframe"]').locator('body').wait_for(timeout=10000)
            except Exception:raise JobError(Status.SUBMITTED_UNVERIFIED,'NO_ENTRY_IFRAME')
            entry=page.frame(name='entryIframe')
        try:
            await entry.locator('a.D_Xqt[aria-pressed]').first.click(timeout=8000)
            selections=entry.locator('button.swt-save-group-info')
            target=[]
            for i in range(min(await selections.count(),100)):
                txt=await selections.nth(i).inner_text()
                if norm(re.sub(r'\s+\d+\s*$','',txt))==norm(item.list_name):target.append(selections.nth(i))
            if len(target)!=1:raise JobError(Status.SUBMITTED_UNVERIFIED,'TARGET_LIST_NOT_UNIQUE')
            await target[0].click()
            if item.alias or item.memo:
                await entry.locator('button.swt-save-add-info-btn').click(timeout=6000)
                if item.alias:
                    await entry.locator("input[placeholder='지도 위에 표시될 별명을 남겨주세요.']").first.fill(item.alias)
                if item.memo:
                    fields=entry.locator('textarea[placeholder*="메모"],input[placeholder*="메모"]')
                    if await fields.count()!=1:raise JobError(Status.SUBMITTED_UNVERIFIED,'MEMO_INPUT_AMBIGUOUS')
                    await fields.first.fill(item.memo)
            await entry.locator('button.swt-save-btn').click(timeout=8000)
        except JobError:raise
        except Exception:raise JobError(Status.SUBMITTED_UNVERIFIED,'NAVER_UI_CHANGED_OR_CAPTCHA')
