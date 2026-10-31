# Self-contained Windows build smoke tests; synthetic photos only.
import sys,tempfile,json,time,zipfile,threading,urllib.request,urllib.error
from pathlib import Path
sys.path.insert(0,str(Path(__file__).parent))
from PIL import Image
import app
def main():
  with tempfile.TemporaryDirectory() as td:
    base=Path(td);app.ROOT=base;app.DB=base/"diary.sqlite3"
    app.ASSETS=base/"Imported Photos";app.ASSETS.mkdir()
    photos=base/"pictures";photos.mkdir()
    ex=Image.Exif();ex[36867]="2026:10:31 15:38:00"
    Image.new("RGB",(180,120),(66,130,230)).save(photos/"family.jpg",exif=ex)
    app.scan_folder(str(photos))
    with app.connect() as c:
      p=c.execute("SELECT * FROM photos").fetchone()
      assert p is not None
      assert app.day_of(p["ts"])=="2026-10-31"
      assert p["approx"]==0
      c.execute("""INSERT INTO diary(day,mode,title,body,tags,feeling,activities,photo_ids,updated)
        VALUES(?,?,?,?,?,?,?,?,?)""",("2026-10-31","curated","우리 가족 일기","다녀온 곳과 기억", "가족","행복","{}",json.dumps([p["id"]]),1730000000000))
      c.commit()
    zip_path=base/"test.familyjourney.zip"
    assert app.bundle_export(str(zip_path))==(1,1)
    assert zipfile.ZipFile(zip_path).testzip() is None
    app.DB=base/"restored.sqlite3"
    n=app.bundle_import(str(zip_path))
    assert n==1
    with app.connect() as c:
      saved=app.as_json(c.execute("SELECT * FROM diary WHERE day='2026-10-31' AND mode='curated'").fetchone())
      assert saved["title"]=="우리 가족 일기"
      assert len(saved["photo_ids"])==1
      assert c.execute("SELECT count(*) FROM diary WHERE mode='automatic'").fetchone()[0]==0
    server=app.ThreadingHTTPServer(("127.0.0.1",0),app.Handler)
    thread=threading.Thread(target=server.serve_forever,daemon=True);thread.start()
    try:
      url=f"http://127.0.0.1:{server.server_port}/api/month?month=2026-10&mode=curated&token={app.TOKEN}"
      data=json.load(urllib.request.urlopen(url,timeout=3))
      assert data["days"][0]["count"]==1
      bad=f"http://127.0.0.1:{server.server_port}/api/status"
      try:urllib.request.urlopen(bad,timeout=3);raise AssertionError("missing token")
      except urllib.error.HTTPError as e:assert e.code==403
    finally:server.shutdown();server.server_close()
  print("PASS: EXIF day, independent diary storage, ZIP media restore, HTTP calendar and token checks")
if __name__=="__main__":main()
