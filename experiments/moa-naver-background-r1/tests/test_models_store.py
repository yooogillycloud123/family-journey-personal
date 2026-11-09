import pytest,uuid
from moa_naver_bridge.models import Favorite,Status
from moa_naver_bridge.store import QueueStore
from moa_naver_bridge.browser import json_bookmark_matches,json_folder_match

def good(**extra):
    d={'job_id':str(uuid.uuid4()),'place_name':'경주 예시 장소','list_name':'가족 여행','address':'경상북도 경주시 예시로 1'}
    d.update(extra);return Favorite.parse(d)

def test_validation_bad_gps():
    with pytest.raises(ValueError,match='INCOMPLETE_GPS'):good(latitude=35.1)
    with pytest.raises(ValueError,match='INVALID_GPS'):good(latitude=0,longitude=0)
    with pytest.raises(ValueError,match='INVALID_PLACE_ID'):good(naver_place_id='nmap://foo')
    with pytest.raises(ValueError,match='UNKNOWN_FIELDS'):good(password='private')

def test_idempotent_queue_and_readback(tmp_path):
    q=QueueStore(tmp_path/'private'/'jobs.db');f=good()
    assert q.add(f) is True
    assert q.add(f) is False
    with pytest.raises(ValueError,match='IDEMPOTENCY_CONFLICT'):
        q.add(Favorite(**{**f.__dict__,'memo':'different'}))
    assert q.next_job()==f
    assert q.get(f.job_id)['status']==Status.WORKING
    with pytest.raises(ValueError,match='VERIFIED_REQUIRES'):
        q.transition(f.job_id,Status.VERIFIED,'button_clicked')
    q.transition(f.job_id,Status.SUBMITTED_UNVERIFIED,'READBACK_MISSING')
    assert q.requeue(f.job_id)
    assert q.next_job()==f
    q.transition(f.job_id,Status.VERIFIED,'READBACK_MATCH')
    assert q.get(f.job_id)['status']==Status.VERIFIED
    assert not q.requeue(f.job_id)
    q.close()

def test_readback_matching_strict():
    f=good(naver_place_id='12345')
    assert json_folder_match({'folderList':[{'name':'가족 여행','shareId':'share42'}]},'가족 여행')['shareId']=='share42'
    assert json_bookmark_matches({'bookmarkList':[{'sid':'12345','name':'other'}]},f)
    assert not json_bookmark_matches({'bookmarkList':[{'sid':'45678','name':f.place_name,'address':f.address}]},f)
    f2=good()
    assert json_bookmark_matches({'bookmarkList':[{'sid':'45678','name':f2.place_name,'address':f2.address}]},f2)
    assert not json_bookmark_matches({'bookmarkList':[{'sid':'45678','name':f2.place_name,'address':'different'}]},f2)

def test_working_job_requeued_after_pc_crash(tmp_path):
    path=tmp_path/'jobs.sqlite3'
    q=QueueStore(path);f=good();q.add(f);q.next_job();q.close()
    q2=QueueStore(path)
    assert q2.get(f.job_id)['status']==Status.QUEUED
    assert q2.next_job()==f
    q2.close()
