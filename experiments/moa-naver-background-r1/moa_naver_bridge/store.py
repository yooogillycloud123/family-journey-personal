from __future__ import annotations
import json, sqlite3, time, os
from pathlib import Path
from .models import Favorite,Status

class QueueStore:
    """Durable outbox: atomic idempotency, no unverified success; user-private SQLite."""
    def __init__(self,path:Path):
        self.path=Path(path).expanduser();self.path.parent.mkdir(parents=True,exist_ok=True)
        if os.name!='nt': os.chmod(self.path.parent,0o700)
        self.db=sqlite3.connect(self.path,check_same_thread=False)
        self.db.row_factory=sqlite3.Row
        self.db.execute("PRAGMA journal_mode=WAL")
        self.db.execute("""CREATE TABLE IF NOT EXISTS jobs (
           job_id TEXT PRIMARY KEY, payload TEXT NOT NULL,
           status TEXT NOT NULL, detail TEXT NOT NULL DEFAULT '',
           attempts INTEGER NOT NULL DEFAULT 0,
           created REAL NOT NULL, updated REAL NOT NULL)""")
        # A killed worker must not strand pending tasks forever. Replays are safe
        # because browser.process() checks NAVER readback BEFORE any new submit.
        self.db.execute("UPDATE jobs SET status=?,detail=? WHERE status=?",
            (Status.QUEUED,'RECOVERED_AFTER_WORKER_RESTART',Status.WORKING))
        self.db.commit()
        if os.name!='nt':os.chmod(self.path,0o600)

    def add(self,item:Favorite):
        payload=json.dumps(item.__dict__,ensure_ascii=False,sort_keys=True)
        with self.db:
            row=self.db.execute("SELECT payload FROM jobs WHERE job_id=?",(item.job_id,)).fetchone()
            if row:
                if row['payload']!=payload:raise ValueError('IDEMPOTENCY_CONFLICT')
                return False
            now=time.time()
            self.db.execute("INSERT INTO jobs(job_id,payload,status,created,updated) VALUES (?,?,?,?,?)",
               (item.job_id,payload,Status.QUEUED,now,now))
        return True

    def get(self,job_id):
        row=self.db.execute("SELECT job_id,status,detail,attempts,created,updated FROM jobs WHERE job_id=?",(job_id,)).fetchone()
        if not row:return None
        return dict(row)

    def next_job(self):
        row=self.db.execute("SELECT * FROM jobs WHERE status=? ORDER BY created LIMIT 1",(Status.QUEUED,)).fetchone()
        if not row:return None
        item=Favorite.parse(json.loads(row['payload']))
        self.transition(item.job_id,Status.WORKING,'',bump=True)
        return item

    def transition(self,job_id,status:Status,detail:str='',bump=False):
        # Explicit statuses prevent pretending a DOM click was a successful server write.
        if status==Status.VERIFIED and detail!='READBACK_MATCH':
            raise ValueError('VERIFIED_REQUIRES_READBACK_MATCH')
        with self.db:
            self.db.execute("UPDATE jobs SET status=?, detail=?, attempts=attempts+?,updated=? WHERE job_id=?",
                (str(status),detail[:160],int(bump),time.time(),job_id))

    def requeue(self,job_id):
        row=self.get(job_id)
        if not row:return False
        if row['status']==Status.VERIFIED:return False
        with self.db:self.db.execute("UPDATE jobs SET status=?,updated=? WHERE job_id=?",(Status.QUEUED,time.time(),job_id))
        return True

    def counts(self):
        return {r[0]:r[1] for r in self.db.execute('SELECT status,count(*) FROM jobs GROUP BY status')}

    def close(self):self.db.close()