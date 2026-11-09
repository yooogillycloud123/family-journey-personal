"""Local-first authenticated HTTP job inbox; browser UI worker runs off the phone screen.

Default binding: 127.0.0.1 ONLY. For Android LAN, use TLS plus a one-time
pairing token. No public cloud, NAVER password or cookie read/transfer.
"""
from __future__ import annotations
import asyncio, hmac, os, secrets, json
from contextlib import asynccontextmanager
from pathlib import Path
from fastapi import FastAPI, HTTPException, Request, Header
from pydantic import BaseModel
from .models import Favorite,Status
from .store import QueueStore
from .browser import NaverPlaywrightWorker

class Submit(BaseModel):
    job_id:str;place_name:str;list_name:str;address:str='';memo:str='';alias:str='';naver_place_id:str='';latitude:float|None=None;longitude:float|None=None

class WorkerState:
    def __init__(self,store:QueueStore,browser,token:str):
        self.store=store;self.browser=browser;self.token=token
        self.trigger=asyncio.Event();self.shutdown=False
        self.task:asyncio.Task|None=None
    async def run(self):
        while not self.shutdown:
            try:
                await asyncio.wait_for(self.trigger.wait(),timeout=2)
                self.trigger.clear()
            except asyncio.TimeoutError: pass
            item=self.store.next_job()
            if not item:continue
            try:
                status,reason=await self.browser.process(item)
                self.store.transition(item.job_id,status,reason)
            except Exception as e:
                self.store.transition(item.job_id,Status.FAILED,type(e).__name__)
    async def stop(self):
        self.shutdown=True;self.trigger.set()
        if self.task:
            try:await asyncio.wait_for(self.task,3)
            except asyncio.TimeoutError:self.task.cancel()
        await self.browser.stop();self.store.close()

def create_app(store:QueueStore,worker,token:str)->FastAPI:
    if not token or len(token)<24:raise ValueError('BRIDGE_TOKEN_MUST_BE_24+_CHARS')
    state=WorkerState(store,worker,token)
    @asynccontextmanager
    async def lifespan(app:FastAPI):
        state.task=asyncio.create_task(state.run())
        state.trigger.set()
        try:yield
        finally:await state.stop()
    app=FastAPI(title='MOA Naver Favorites Local Worker',version='0.1',docs_url=None,redoc_url=None,lifespan=lifespan)
    def authenticate(auth:str|None):
        if not auth or not hmac.compare_digest(auth,'Bearer '+token):
            raise HTTPException(status_code=401,detail='AUTH_REQUIRED')
    @app.get('/health')
    async def health():return {'status':'alive','naver_account_saved':False}
    @app.post('/v1/favorites',status_code=202)
    async def enqueue(item:Submit,authorization:str|None=Header(None)):
        authenticate(authorization)
        try:task=Favorite.parse(item.model_dump())
        except ValueError as e:raise HTTPException(status_code=422,detail=str(e))
        try:created=store.add(task)
        except ValueError as e:raise HTTPException(status_code=409,detail=str(e))
        if created:state.trigger.set()
        return {'job_id':task.job_id,'created':created,'status':store.get(task.job_id)['status']}
    @app.get('/v1/favorites/{job_id}')
    async def status(job_id:str,authorization:str|None=Header(None)):
        authenticate(authorization)
        row=store.get(job_id)
        if not row:raise HTTPException(status_code=404,detail='NOT_FOUND')
        return row
    @app.post('/v1/favorites/{job_id}/retry')
    async def retry(job_id:str,authorization:str|None=Header(None)):
        authenticate(authorization)
        row=store.get(job_id)
        if not row:raise HTTPException(status_code=404,detail='NOT_FOUND')
        if not store.requeue(job_id):raise HTTPException(status_code=409,detail='ALREADY_VERIFIED')
        state.trigger.set();return {'job_id':job_id,'status':Status.QUEUED}
    @app.get('/v1/summary')
    async def summary(authorization:str|None=Header(None)):
        authenticate(authorization)
        return {'counts':store.counts(),'note':'Only NAVER_READBACK_VERIFIED means confirmed NAVER save.'}
    return app