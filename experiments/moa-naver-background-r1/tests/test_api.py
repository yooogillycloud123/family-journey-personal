import asyncio,uuid,pytest
from httpx import ASGITransport,AsyncClient
from moa_naver_bridge.models import Status
from moa_naver_bridge.server import create_app
from moa_naver_bridge.store import QueueStore

class StubBrowser:
    def __init__(self):self.calls=0
    async def process(self,item):
        self.calls+=1
        await asyncio.sleep(0.01)
        return (Status.SUBMITTED_UNVERIFIED,'NO_NAVER_READBACK')
    async def stop(self):pass

@pytest.mark.asyncio
async def test_api_job_does_not_claim_saved(tmp_path):
    store=QueueStore(tmp_path/'jobs.db');w=StubBrowser();app=create_app(store,w,'user-private-token-long-enough-123456')
    data={'job_id':str(uuid.uuid4()),'place_name':'Example','list_name':'Family','address':'Example address 1'}
    async with app.router.lifespan_context(app):
      async with AsyncClient(transport=ASGITransport(app=app),base_url='http://localhost') as c:
        assert (await c.post('/v1/favorites',json=data)).status_code==401
        h={'authorization':'Bearer user-private-token-long-enough-123456'}
        r=await c.post('/v1/favorites',json=data,headers=h)
        assert r.status_code==202
        assert (await c.post('/v1/favorites',json=data,headers=h)).json()['created']==False
        for _ in range(100):
          s=(await c.get('/v1/favorites/'+data['job_id'],headers=h)).json()
          if s['status']==Status.SUBMITTED_UNVERIFIED:break
          await asyncio.sleep(0.03)
        assert s['status']==Status.SUBMITTED_UNVERIFIED
        assert s['detail']=='NO_NAVER_READBACK'
        assert w.calls==1
        bad={**data,'memo':'different'}
        assert (await c.post('/v1/favorites',json=bad,headers=h)).status_code==409