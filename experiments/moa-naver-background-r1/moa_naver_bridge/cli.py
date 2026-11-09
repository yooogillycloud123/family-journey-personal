from __future__ import annotations
import argparse,asyncio,os,secrets,sys
from pathlib import Path
from .browser import NaverPlaywrightWorker
from .server import create_app
from .store import QueueStore

HOME=Path.home()/'.moa-naver-background'

def main(argv=None):
    parser=argparse.ArgumentParser(description='MOA Naver real-favorites background browser worker (beta)')
    sub=parser.add_subparsers(dest='cmd',required=True)
    p=sub.add_parser('login',help='Open a dedicated visible browser ONCE on PC for manual NAVER login')
    p.add_argument('--chromium',default=None)
    s=sub.add_parser('serve',help='Run PC job receiver; default loopback only')
    s.add_argument('--host',default='127.0.0.1');s.add_argument('--port',type=int,default=8765)
    s.add_argument('--token',default=None,help='Pairing secret. Omit to read protected local token file.')
    s.add_argument('--certfile');s.add_argument('--keyfile');s.add_argument('--chromium');s.add_argument('--headed-worker',action='store_true',help='Use visible PC browser window only if website rejects headless; phone MOA stays foreground')
    g=sub.add_parser('token',help='Create/reprint private pairing token on this PC only')
    args=parser.parse_args(argv)
    HOME.mkdir(parents=True,exist_ok=True)
    if os.name!='nt':os.chmod(HOME,0o700)
    token_path=HOME/'bridge-token.txt'
    if args.cmd=='token':
        if token_path.exists():secret=token_path.read_text().strip()
        else:
            secret=secrets.token_urlsafe(40);token_path.write_text(secret)
            if os.name!='nt':os.chmod(token_path,0o600)
        print('PRIVATE PAIRING TOKEN (never share publicly):',secret)
        return
    worker=NaverPlaywrightWorker(HOME/'browser-profile',getattr(args,'chromium',None),getattr(args,'headed_worker',False))
    if args.cmd=='login':
        asyncio.run(worker.login_visible_once());return
    if args.cmd=='serve':
        if args.host not in ('127.0.0.1','localhost','::1') and not(args.certfile and args.keyfile):
            parser.error('LAN_BIND_REQUIRES_HTTPS_CERT_AND_KEY')
        if bool(args.certfile)!=bool(args.keyfile):parser.error('TLS_CERT_AND_KEY_BOTH_REQUIRED')
        token=args.token or (token_path.read_text().strip() if token_path.exists() else '')
        if not token:
            print('Please run: python -m moa_naver_bridge.cli token',file=sys.stderr);raise SystemExit(2)
        import uvicorn
        app=create_app(QueueStore(HOME/'jobs.sqlite3'),worker,token)
        print('MOA local worker starting. Login via own browser profile; no NAVER session data leaves PC.')
        uvicorn.run(app,host=args.host,port=args.port,ssl_certfile=args.certfile,ssl_keyfile=args.keyfile,log_level='warning',access_log=False)

if __name__=='__main__':main()
