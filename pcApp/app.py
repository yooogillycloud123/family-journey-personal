# FamilyJourney PC v0.1 — independent offline Windows diary application.
# This source is original; it contains no proprietary mobile app assets and no personal photos.
import os,sys,json,sqlite3,hashlib,zipfile,threading,webbrowser,datetime,time,io,uuid,html
from pathlib import Path
from urllib.parse import urlparse,parse_qs
from http.server import ThreadingHTTPServer,BaseHTTPRequestHandler
from tkinter import Tk,filedialog
from PIL import Image,ImageOps
import tempfile,shutil,atexit

ROOT=Path.home()/"Documents"/"FamilyJourney"
ROOT.mkdir(parents=True,exist_ok=True)
DB=ROOT/"familyjourney.sqlite3"
ASSETS=ROOT/"Imported Photos"
ASSETS.mkdir(exist_ok=True)
TOKEN=uuid.uuid4().hex
class SafeConnection(sqlite3.Connection):
    # sqlite3.Connection context manager alone does not close on Windows.
    # Release file handles to allow moving/rotating backups and clean tests.
    def __exit__(self,*exc):
        try:return super().__exit__(*exc)
        finally:self.close()

def connect():
    c=sqlite3.connect(DB,timeout=30,factory=SafeConnection)
    c.row_factory=sqlite3.Row
    c.execute("PRAGMA journal_mode=WAL")
    c.executescript("""CREATE TABLE IF NOT EXISTS photos(
id INTEGER PRIMARY KEY,path TEXT NOT NULL UNIQUE,ts INTEGER NOT NULL,
approx INTEGER DEFAULT 0,size INTEGER,mtime INTEGER,sha TEXT);
CREATE TABLE IF NOT EXISTS diary(
day TEXT NOT NULL,mode TEXT NOT NULL,title TEXT DEFAULT '',
body TEXT DEFAULT '',tags TEXT DEFAULT '',feeling TEXT DEFAULT '',
activities TEXT DEFAULT '{}',photo_ids TEXT DEFAULT '[]',
updated INTEGER NOT NULL,PRIMARY KEY(day,mode));
CREATE TABLE IF NOT EXISTS settings(key TEXT PRIMARY KEY,value TEXT);""")
    c.commit()
    return c
def day_of(ts):
    return datetime.datetime.fromtimestamp(ts).strftime("%Y-%m-%d")
def shot_time(path,stat):
    try:
        with Image.open(path) as im:
            exif=im.getexif()
            raw=exif.get(36867) or exif.get(306)
            if not raw and hasattr(exif,"get_ifd"):
                raw=exif.get_ifd(34665).get(36867)
            if isinstance(raw,str):
                return int(datetime.datetime.strptime(raw[:19],"%Y:%m:%d %H:%M:%S").timestamp()),0
    except Exception:pass
    return max(946684800,int(stat.st_mtime)),1
VALID={".jpg",".jpeg",".png",".webp",".heic",".heif",".tif",".tiff"}
STATE={"scanning":False,"message":"준비됨","scanned":0}
def scan_folder(folder):
    STATE.update(scanning=True,message="사진을 검색하고 있습니다…",scanned=0)
    try:
        with connect() as c:
            batch=[]
            for root,dirs,files in os.walk(folder):
                dirs[:]=[d for d in dirs if not d.startswith(".")]
                for name in files:
                    p=Path(root)/name
                    if p.suffix.lower() not in VALID:continue
                    try:
                        st=p.stat()
                        ts,approx=shot_time(p,st)
                        batch.append((str(p),ts,approx,st.st_size,int(st.st_mtime)))
                        STATE["scanned"]+=1
                    except (OSError,ValueError):continue
                    if len(batch)>=250:
                        c.executemany("""INSERT INTO photos(path,ts,approx,size,mtime)
                        VALUES(?,?,?,?,?) ON CONFLICT(path) DO UPDATE SET
                        ts=excluded.ts,approx=excluded.approx,size=excluded.size,
                        mtime=excluded.mtime""",batch);c.commit();batch=[]
            if batch:c.executemany("""INSERT INTO photos(path,ts,approx,size,mtime)
                VALUES(?,?,?,?,?) ON CONFLICT(path) DO UPDATE SET
                ts=excluded.ts,approx=excluded.approx,size=excluded.size,
                mtime=excluded.mtime""",batch);c.commit()
        STATE["message"]=f"사진 {STATE['scanned']:,}장 색인 완료"
    except Exception as e:STATE["message"]="검색 오류: "+str(e)
    finally:STATE["scanning"]=False
def choose_path(folder=False,save=False,ext="json"):
    r=Tk();r.withdraw();r.wm_attributes("-topmost",1)
    try:
        if folder:return filedialog.askdirectory(parent=r,title="사진이 들어 있는 PC 폴더를 선택")
        if save:return filedialog.asksaveasfilename(parent=r,defaultextension="."+ext,filetypes=[("FamilyJourney "+ext, "*."+ext)],initialfile="FamilyJourney_Backup."+ext)
        return filedialog.askopenfilename(parent=r,filetypes=[("가족 일기 파일","*.json *.zip")])
    finally:r.destroy()
def as_json(row):
    if not row:return None
    o=dict(row)
    for k in ("activities","photo_ids"):
        try:o[k]=json.loads(o[k])
        except Exception:o[k]={} if k=="activities" else []
    return o
def date_ok(day):
    try:return datetime.datetime.strptime(day,"%Y-%m-%d").strftime("%Y-%m-%d")==day
    except Exception:return False
def json_reply(handler,payload,status=200):
    blob=json.dumps(payload,ensure_ascii=False).encode("utf-8")
    handler.send_response(status)
    handler.send_header("Content-Type","application/json; charset=utf-8")
    handler.send_header("Cache-Control","no-store")
    handler.send_header("Content-Length",str(len(blob)))
    handler.end_headers();handler.wfile.write(blob)
def rows_for_photos(c,ids):
    out=[]
    for i in ids[:4000]:
        try:
            q=c.execute("SELECT id,ts,approx,path FROM photos WHERE id=?",(int(i),)).fetchone()
            if q and Path(q["path"]).is_file():out.append(dict(q))
        except Exception:pass
    return out
def photo_hash(p):
    h=hashlib.sha256()
    with open(p,"rb") as f:
        while True:
            chunk=f.read(1048576)
            if not chunk:break
            h.update(chunk)
    return h.hexdigest()
def bundle_export(dest):
    with connect() as c:
        records=[as_json(x) for x in c.execute("SELECT * FROM diary")]
        ids=set()
        for row in records:ids.update(str(x) for x in row["photo_ids"])
        photos=rows_for_photos(c,list(ids))
        by_id={str(x["id"]):x for x in photos}
        assets={}
        for item in photos:
            p=Path(item["path"]);ident=photo_hash(p)
            item["sha256"]=ident
            item["ext"]=p.suffix.lower()
            assets[ident]=item
        for row in records:
            row["photos"]=[by_id[str(i)]["sha256"] for i in row["photo_ids"] if str(i) in by_id]
        manifest={"schema":"familyjourney-sync-v1","created":int(time.time()*1000),
                  "device":"windows-pc","records":records,
                  "assets":[{"sha256":k,"file":"media/"+k+v["ext"],"taken":v["ts"],
                             "approx":bool(v["approx"])} for k,v in assets.items()]}
        with zipfile.ZipFile(dest,"w",zipfile.ZIP_DEFLATED,compresslevel=1,allowZip64=True) as z:
            z.writestr("manifest.json",json.dumps(manifest,ensure_ascii=False,indent=2))
            for k,v in assets.items():z.write(v["path"],"media/"+k+v["ext"])
    return len(records),len(assets)
def bundle_import(path):
    with zipfile.ZipFile(path) as z:
        names=set(z.namelist())
        if "manifest.json" not in names:raise ValueError("FamilyJourney manifest.json 없음")
        manifest=json.loads(z.read("manifest.json"))
        if manifest.get("schema")!="familyjourney-sync-v1":raise ValueError("지원하지 않는 백업 포맷")
        assets={};count=0
        with connect() as c:
            for asset in manifest.get("assets",[])[:20000]:
                digest=str(asset.get("sha256",""))
                if not len(digest)==64 or any(x not in "0123456789abcdef" for x in digest):continue
                loc=str(asset.get("file",""))
                if loc not in names or not loc.startswith("media/"+digest):continue
                ext=Path(loc).suffix.lower()
                if ext not in VALID:continue
                target=ASSETS/(digest+ext)
                if not target.exists():
                    tmp=ASSETS/(digest+".part")
                    sha=hashlib.sha256()
                    with z.open(loc) as src,open(tmp,"wb") as dst:
                        size=0
                        while True:
                            part=src.read(1048576)
                            if not part:break
                            size+=len(part)
                            if size>150*1024*1024:raise ValueError("150MB 초과 사진")
                            dst.write(part);sha.update(part)
                    if sha.hexdigest()!=digest:
                        tmp.unlink(missing_ok=True);raise ValueError("사진 무결성 검증 실패")
                    tmp.rename(target)
                st=target.stat();ts=int(asset.get("taken") or st.st_mtime)
                c.execute("""INSERT OR IGNORE INTO photos(path,ts,approx,size,mtime,sha)
                    VALUES(?,?,?,?,?,?)""",(str(target),ts,int(bool(asset.get("approx"))),
                                st.st_size,int(st.st_mtime),digest))
                row=c.execute("SELECT id FROM photos WHERE path=?",(str(target),)).fetchone()
                assets[digest]=row[0];count+=1
            for rec in manifest.get("records",[])[:30000]:
                day=rec.get("day","");mode=rec.get("mode","curated")
                if not date_ok(day) or mode not in ("curated","automatic"):continue
                updated=int(rec.get("updated",0))
                local=c.execute("SELECT updated FROM diary WHERE day=? AND mode=?",(day,mode)).fetchone()
                if local and int(local[0])>=updated:continue
                refs=[assets[x] for x in rec.get("photos",[]) if x in assets]
                # Records without portable photos are restored as text only.
                c.execute("""INSERT INTO diary(day,mode,title,body,tags,feeling,activities,photo_ids,updated)
                VALUES(?,?,?,?,?,?,?,?,?) ON CONFLICT(day,mode) DO UPDATE SET
                title=excluded.title,body=excluded.body,tags=excluded.tags,
                feeling=excluded.feeling,activities=excluded.activities,
                photo_ids=excluded.photo_ids,updated=excluded.updated""",
                (day,mode,str(rec.get("title","")),str(rec.get("body","")),
                 rec.get("tags","") if isinstance(rec.get("tags"),str) else json.dumps(rec.get("tags",[]),ensure_ascii=False),
                 rec.get("feeling",""),json.dumps(rec.get("activities",{}),ensure_ascii=False),
                 json.dumps(refs),updated))
            c.commit()
        return count
def import_android_json(path):
    src=json.loads(Path(path).read_text(encoding="utf-8-sig"))
    if src.get("schema")!="familyjourney-diary-v3":raise ValueError("R25 일기 JSON이 아닙니다.")
    num=0
    with connect() as c:
        for key,mode in (("notes","automatic"),("curatedNotes","curated")):
            for row in src.get(key,[]):
                day=row.get("day","")
                if not date_ok(day):continue
                local=c.execute("SELECT updated FROM diary WHERE day=? AND mode=?",(day,mode)).fetchone()
                updated=int(row.get("updatedAt",0))
                if local and local[0]>=updated:continue
                # Android numeric MediaStore IDs are device-local; never map them to PC photos.
                c.execute("""INSERT INTO diary(day,mode,title,body,tags,feeling,activities,photo_ids,updated)
                    VALUES(?,?,?,?,?,?,?,?,?) ON CONFLICT(day,mode) DO UPDATE SET
                    title=excluded.title,body=excluded.body,tags=excluded.tags,feeling=excluded.feeling,
                    activities=excluded.activities,updated=excluded.updated""",
                    (day,mode,row.get("title",""),row.get("body",""),
                     json.dumps(row.get("tags",[]),ensure_ascii=False),row.get("feeling",""),
                     json.dumps(row.get("activities",{}),ensure_ascii=False),"[]",updated))
                num+=1
        c.commit()
    return num
class Handler(BaseHTTPRequestHandler):
    def log_message(self,*args):return
    def authorized(self):
        return parse_qs(urlparse(self.path).query).get("token",[""])[0]==TOKEN
    def do_GET(self):
        if not self.authorized():return json_reply(self,{"error":"not allowed"},403)
        u=urlparse(self.path);q=parse_qs(u.query)
        if u.path in ("/","/app.js","/style.css"):
            base=Path(getattr(sys,"_MEIPASS",Path(__file__).parent))
            filename={" /":"index.html","/":"index.html","/app.js":"app.js","/style.css":"style.css"}[u.path]
            content=(base/filename).read_bytes()
            if filename=="index.html":
                content=content.replace(b"TOKEN_REPLACED",TOKEN.encode("ascii"))
            self.send_response(200)
            self.send_header("Content-Type",{"index.html":"text/html; charset=utf-8","app.js":"text/javascript; charset=utf-8","style.css":"text/css; charset=utf-8"}[filename])
            self.send_header("Content-Length",str(len(content)));self.end_headers();self.wfile.write(content);return
        if u.path.startswith("/thumb/"):
            try:
                id=int(u.path.split("/")[-1])
                with connect() as c:r=c.execute("SELECT path FROM photos WHERE id=?",(id,)).fetchone()
                if not r or not Path(r[0]).is_file():raise ValueError("missing photo")
                with Image.open(r[0]) as im:
                    im=ImageOps.exif_transpose(im);im.thumbnail((380,380))
                    if im.mode not in ("RGB","L"):im=im.convert("RGB")
                    out=io.BytesIO();im.save(out,format="JPEG",quality=76)
                content=out.getvalue()
                self.send_response(200);self.send_header("Content-Type","image/jpeg")
                self.send_header("Cache-Control","private, max-age=180")
                self.send_header("Content-Length",str(len(content)));self.end_headers();self.wfile.write(content)
            except Exception:self.send_error(404)
            return
        with connect() as c:
            if u.path=="/api/status":
                n=c.execute("SELECT count(*) FROM photos").fetchone()[0]
                diary=c.execute("SELECT count(*) FROM diary").fetchone()[0]
                return json_reply(self,{"photos":n,"diaries":diary,**STATE})
            if u.path=="/api/month":
                month=q.get("month",[""])[0];mode=q.get("mode",["curated"])[0]
                if not len(month)==7 or not month[:4].isdigit():return json_reply(self,{"error":"month"},400)
                if mode=="curated":
                    days=[dict(x) for x in c.execute("SELECT day,photo_ids,title FROM diary WHERE mode='curated' AND day LIKE ?",(month+"%",))]
                    return json_reply(self,{"days":[{"day":x["day"],"count":len(json.loads(x["photo_ids"])),
                                 "cover":next(iter(json.loads(x["photo_ids"])),None),"saved":True}
                                 for x in days]})
                start=datetime.datetime.strptime(month+"-01","%Y-%m-%d")
                end=(start.replace(day=28)+datetime.timedelta(days=4)).replace(day=1)
                rows=[dict(x) for x in c.execute("SELECT id,ts FROM photos WHERE ts>=? AND ts<? ORDER BY ts",(start.timestamp(),end.timestamp()))]
                days={}
                for x in rows:
                    d=day_of(x["ts"]);val=days.setdefault(d,{"day":d,"count":0,"cover":x["id"],"saved":False});val["count"]+=1
                for x in c.execute("SELECT day FROM diary WHERE mode='automatic' AND day LIKE ?",(month+"%",)):
                    days.setdefault(x["day"],{"day":x["day"],"count":0,"cover":None})["saved"]=True
                return json_reply(self,{"days":list(days.values())})
            if u.path=="/api/day":
                day=q.get("day",[""])[0];mode=q.get("mode",["curated"])[0]
                if not date_ok(day):return json_reply(self,{"error":"day"},400)
                row=c.execute("SELECT * FROM diary WHERE day=? AND mode=?",(day,mode)).fetchone()
                d=as_json(row)
                if mode=="curated":photos=rows_for_photos(c, d["photo_ids"] if d else [])
                else:
                    start=datetime.datetime.strptime(day,"%Y-%m-%d").timestamp()
                    photos=[dict(x) for x in c.execute("SELECT id,path,ts,approx FROM photos WHERE ts>=? AND ts<? ORDER BY ts",(start,start+86400)) if Path(x["path"]).is_file()]
                return json_reply(self,{"record":d,"photos":photos})
            if u.path=="/api/photos":
                month=q.get("month",[""])[0];page=min(400,int(q.get("page",["0"])[0]))
                if not len(month)==7:return json_reply(self,{"error":"month"},400)
                start=datetime.datetime.strptime(month+"-01","%Y-%m-%d")
                end=(start.replace(day=28)+datetime.timedelta(days=4)).replace(day=1)
                rows=[dict(x) for x in c.execute("SELECT id,ts,approx,path FROM photos WHERE ts>=? AND ts<? ORDER BY ts DESC LIMIT 120 OFFSET ?",(start.timestamp(),end.timestamp(),page*120))]
                return json_reply(self,{"photos":[{"id":r["id"],"day":day_of(r["ts"]),"time":datetime.datetime.fromtimestamp(r["ts"]).strftime("%H:%M")} for r in rows if Path(r["path"]).is_file()]})
        return json_reply(self,{"error":"unknown route"},404)
    def do_POST(self):
        if not self.authorized():return json_reply(self,{"error":"not allowed"},403)
        if self.headers.get("Content-Length") is None or int(self.headers["Content-Length"])>4_000_000:
            return json_reply(self,{"error":"too large"},413)
        try:data=json.loads(self.rfile.read(int(self.headers["Content-Length"])))
        except Exception:return json_reply(self,{"error":"bad JSON"},400)
        u=urlparse(self.path).path
        try:
            if u=="/api/quit":
                threading.Thread(target=self.server.shutdown,daemon=True).start()
                return json_reply(self,{"ok":True})
            if u=="/api/scan":
                if STATE["scanning"]:return json_reply(self,{"message":"사진 분석 중"})
                folder=choose_path(folder=True)
                if folder:threading.Thread(target=scan_folder,args=(folder,),daemon=True).start()
                return json_reply(self,{"selected":bool(folder),"folder":folder})
            if u=="/api/save":
                day=data.get("day","");mode=data.get("mode","curated")
                if not date_ok(day) or mode not in ("curated","automatic"):raise ValueError("Invalid diary day")
                with connect() as c:
                    ids=[int(i) for i in data.get("photoIds",[]) if str(i).isdigit()][:4000]
                    c.execute("""INSERT INTO diary(day,mode,title,body,tags,feeling,activities,photo_ids,updated)
                        VALUES(?,?,?,?,?,?,?,?,?) ON CONFLICT(day,mode) DO UPDATE SET
                        title=excluded.title,body=excluded.body,tags=excluded.tags,feeling=excluded.feeling,
                        activities=excluded.activities,photo_ids=excluded.photo_ids,updated=excluded.updated""",
                        (day,mode,str(data.get("title",""))[:150],str(data.get("body",""))[:20000],
                         str(data.get("tags",""))[:500],str(data.get("feeling",""))[:50],
                         json.dumps(data.get("activities",{}),ensure_ascii=False),json.dumps(ids),int(time.time()*1000)))
                    c.commit()
                return json_reply(self,{"ok":True})
            if u=="/api/delete":
                with connect() as c:c.execute("DELETE FROM diary WHERE day=? AND mode=?",(data.get("day"),data.get("mode")));c.commit()
                return json_reply(self,{"ok":True})
            if u=="/api/export":
                path=choose_path(save=True,ext="zip")
                if not path:return json_reply(self,{"cancelled":True})
                records,media=bundle_export(path)
                return json_reply(self,{"ok":True,"path":path,"records":records,"photos":media})
            if u=="/api/import":
                path=choose_path()
                if not path:return json_reply(self,{"cancelled":True})
                if path.lower().endswith(".zip"):n=bundle_import(path);msg=f"가족 사진 {n}장 병합 완료"
                else:n=import_android_json(path);msg=f"Android 일기 {n}건 글/메모 가져옴 · 사진은 원본 백업 필요"
                return json_reply(self,{"ok":True,"message":msg})
        except Exception as e:return json_reply(self,{"error":str(e)},400)
        return json_reply(self,{"error":"unknown command"},404)

def main():
    with connect():pass
    server=ThreadingHTTPServer(("127.0.0.1",0),Handler)
    url=f"http://127.0.0.1:{server.server_port}/?token={TOKEN}"
    print("FamilyJourney PC local:",url)
    threading.Timer(0.8,lambda:webbrowser.open(url)).start()
    try:server.serve_forever()
    except KeyboardInterrupt:pass
    finally:server.server_close()
if __name__=="__main__":main()
