"""PC loopback smoke request; no family data used. Actual Naver writes opt-in only."""
import uuid,json,urllib.request,sys
URL='http://127.0.0.1:8765/v1/favorites'
if len(sys.argv)<2:
 print('Usage: python scripts/submit_example.py YOUR_PRIVATE_PAIRING_TOKEN');raise SystemExit(2)
# This request is opt-in; replace with harmless test place after checking target account.
job={'job_id':str(uuid.uuid4()),'place_name':'예시 장소','list_name':'MOA 테스트','address':'서울특별시 중구 예시주소 1'}
req=urllib.request.Request(URL,data=json.dumps(job).encode(),headers={'Content-Type':'application/json','Authorization':'Bearer '+sys.argv[1]},method='POST')
try:
 with urllib.request.urlopen(req,timeout=8) as r:print(r.read().decode())
except Exception as e:print('BRIDGE_REJECTED_OR_UNAVAILABLE:',type(e).__name__)