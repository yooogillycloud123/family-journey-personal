from __future__ import annotations
from dataclasses import dataclass, asdict
from enum import StrEnum
from uuid import UUID
import re

class Status(StrEnum):
    QUEUED = "QUEUED"
    WORKING = "WORKING"
    LOGIN_REQUIRED = "LOGIN_REQUIRED"
    AMBIGUOUS = "AMBIGUOUS_PLACE"
    LIST_CREATE_FAILED = "LIST_CREATE_FAILED"
    CAPTCHA_REQUIRED = "CAPTCHA_REQUIRED"
    SUBMITTED_UNVERIFIED = "SUBMITTED_UNVERIFIED"
    VERIFIED = "NAVER_READBACK_VERIFIED"
    FAILED = "FAILED"

@dataclass(frozen=True)
class Favorite:
    job_id: str
    place_name: str
    list_name: str
    address: str = ""
    memo: str = ""
    alias: str = ""
    naver_place_id: str = ""
    latitude: float | None = None
    longitude: float | None = None

    @staticmethod
    def parse(raw: dict) -> "Favorite":
        if not isinstance(raw, dict): raise ValueError("INVALID_REQUEST")
        keys = set(Favorite.__dataclass_fields__)
        if set(raw) - keys: raise ValueError("UNKNOWN_FIELDS")
        try:
            item = Favorite(**raw)
            UUID(item.job_id)
        except Exception as exc: raise ValueError("INVALID_JOB_ID_OR_FIELDS") from exc
        for name, limit in (("place_name",150),("list_name",80),("address",220),("memo",50),("alias",25),("naver_place_id",40)):
            s=getattr(item,name)
            if not isinstance(s,str) or len(s)>limit or (name in {"place_name","list_name"} and not s.strip()):
                raise ValueError("INVALID_"+name.upper())
            if '\x00' in s or any(ord(c)<32 and c not in '\n\t' for c in s): raise ValueError("CONTROL_CHAR")
        if item.naver_place_id and not re.fullmatch(r"[0-9]{1,40}",item.naver_place_id):
            raise ValueError("INVALID_PLACE_ID")
        if (item.latitude is None)!=(item.longitude is None):raise ValueError("INCOMPLETE_GPS")
        if item.latitude is not None:
            if not isinstance(item.latitude,(float,int)) or not isinstance(item.longitude,(float,int)):
                raise ValueError("GPS_NOT_NUMERIC")
            if not (-90<=item.latitude<=90 and -180<=item.longitude<=180):raise ValueError("INVALID_GPS")
            if item.latitude==0 and item.longitude==0:raise ValueError("INVALID_GPS")
        if not (item.address or item.naver_place_id):
            raise ValueError("NEED_ADDRESS_OR_EXACT_PLACE_ID")
        return item

    def safe_summary(self)->dict:
        # No precise GPS/address/photo content in API status or logs.
        return {"job_id":self.job_id,"list_name":self.list_name,"place_name":self.place_name}

def norm(x:str)->str:
    return re.sub(r"\s+","",(x or "").strip().casefold())