#!/usr/bin/env python3
"""Read-only parity evidence for the user's locally supplied split APK.
Do NOT upload proprietary original APK, assets, purchases, private photos or GPS to public GitHub.
"""
import argparse,hashlib,io,json,re,zipfile
from pathlib import Path

CHECKS = {
 "home_canvas":("assets/web/index.html",r'id="home-canvas"'),
 "original_styles":("assets/web/style.css",r"\.home-map"),
 "home_render":("assets/web/app.js",r"function\s+renderHome\s*\("),
 "visited_regions":("assets/web/app.js",r"function\s+homeDraw\s*\("),
 "places_thumbnails":("assets/web/app.js",r"function\s+openPlace\s*\("),
 "trip_selection":("assets/web/index.html",r'data-page="2"'),
 "wording_screen":("assets/web/index.html",r'data-page="3"'),
 "style_screen":("assets/web/index.html",r'data-page="4"'),
 "video_screen":("assets/web/index.html",r'data-page="5"'),
 "autogallery_fingerprint":("assets/web/native.js",r"__nativeFingerprint"),
 "autogallery_photos":("assets/web/native.js",r"__nativePhotos\s*="),
 "autogallery_chunking":("assets/web/native.js",r"__nativePhotosBegin"),
 "autogallery_cache":("assets/web/native.js",r"cacheGet\('data'\)"),
 "travel_builder":("assets/web/tripbuilder.js",r"PhotoTripBuilder"),
 "map_engine":("assets/web/engine.js",r"PhotoMapEngine"),
 "esri_map_style":("assets/web/engine.js",r"TILE_STYLES\s*="),
 "native_premium_entitlement_handling":("assets/web/app.js",r"PREMIUM_TOGGLES"),
 "video_pipeline":("assets/web/app.js",r"function\s+makeVideo\s*\("),
 "video_render_worker":("assets/web/render-worker.js",r"VideoEncoder|OffscreenCanvas|MP4"),
 "optional_family_photo_sources":("assets/web/cloud.js",r"Google Drive|OneDrive|Immich"),
}
def run(archive):
    raw=Path(archive).read_bytes()
    with zipfile.ZipFile(io.BytesIO(raw)) as outer:
        matches=[name for name in outer.namelist() if name.endswith("base.apk")]
        if len(matches)!=1: raise RuntimeError("Expected base.apk inside split ZIP")
        base=outer.read(matches[0])
    with zipfile.ZipFile(io.BytesIO(base)) as z:
        source={n:z.read(n).decode("utf-8") for n in {p for p,_ in CHECKS.values()}}
        checks={}
        for label,(path,pattern) in CHECKS.items():
            m=re.search(pattern,source[path],re.I)
            checks[label]={"found":bool(m),"file":path,"line":source[path][:m.start()].count("\n")+1 if m else None}
    return {"archive_sha256":hashlib.sha256(raw).hexdigest(),"base_sha256":hashlib.sha256(base).hexdigest(),
            "checks":checks,"passed":sum(x["found"] for x in checks.values()),"total":len(checks),
            "scope":"read-only static; no photo data and no billing circumvention"}
if __name__=="__main__":
    p=argparse.ArgumentParser();p.add_argument("split_apk_zip");p.add_argument("--out")
    args=p.parse_args();j=json.dumps(run(args.split_apk_zip),ensure_ascii=False,indent=2)
    if args.out:Path(args.out).write_text(j+"\n",encoding="utf-8")
    print(j)
