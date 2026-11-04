from pathlib import Path
import sys
old=Path(sys.argv[1]).read_text(encoding='utf-8')
needle="showTab();await init();await refreshCuratedFromDatabase();render();mmR60RefreshMedia('diary-open')"
replacement="showTab();render();await init();if(!S.open)return;await refreshCuratedFromDatabase();if(!S.open)return;render();mmR60RefreshMedia('diary-open')"
assert old.count(needle)==1
new=old.replace(needle,replacement)
banner="S.load?'사진 날짜 정보 읽는 중…':metaStatus()"
assert new.count(banner)==1
new=new.replace(banner,"S.load?'사진 날짜 정보 읽는 중…':!S.ready?'일기 자료를 불러오는 중 · 달력은 먼저 표시됩니다':metaStatus()")
assert "button('일기 삭제',remove,'danger')" in new
assert "const FIVE_MIN_MS=5*60*1000" in new
Path(sys.argv[2]).write_text(new,encoding='utf-8')
