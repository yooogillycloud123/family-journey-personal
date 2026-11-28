#!/usr/bin/env python3
"""Use the original private key locally, stage only verified signed APKs."""
from pathlib import Path
import argparse,hashlib,os,shutil,subprocess,sys,tempfile,zipfile
ROOT=Path(__file__).resolve().parent
BACKUP='3fc12c31c2f91a350d9a77d2c104b815ebbdc73b11e50b2c1de01458de86ea27'
KEY='2b96894fa084a1a081bb00975e94f605d94fdf44f47f1e01e5f287699d9d42b5'
REPO='https://github.com/yooogillycloud123/family-journey-personal.git'
BRANCH='release/moa-r783-signing-stage-20261128'
NAMES=('MOA_R783_ORIGINAL_SIGNED.apk','MOA_R784_ORIGINAL_SIGNED.apk')
def sha(b):return hashlib.sha256(b).hexdigest()
def run(args):subprocess.run([str(a) for a in args],check=True)
def find_java(explicit):
    if explicit:return explicit
    for p in [shutil.which('java'),Path(os.environ.get('ProgramFiles','C:/Program Files'))/'Android/Android Studio/jbr/bin/java.exe',Path(os.environ.get('JAVA_HOME',''))/'bin/java.exe']:
        if p and Path(p).is_file():return str(p)
    raise RuntimeError('Java is required: install a trusted JDK or use Android Studio JBR (--java).')
def select_backup():
    for base in (ROOT,Path.home()/'Downloads'):
        f=base/'MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip'
        if f.is_file():return f
    try:
        import tkinter as tk
        from tkinter.filedialog import askopenfilename
        win=tk.Tk();win.withdraw()
        name=askopenfilename(title='Select original MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip',filetypes=[('ZIP backup','*.zip')])
        win.destroy()
        if name:return Path(name)
    except Exception:pass
    return Path(input('Path to original private backup ZIP: ').strip().strip('"'))
def stage():
    if not shutil.which('git'):raise RuntimeError('Git not installed; upload the two signed APKs through the browser instead.')
    with tempfile.TemporaryDirectory(prefix='moa-r783-stage-') as tmp:
        repo=Path(tmp)/'repo'
        run(['git','clone','--depth','1','--branch',BRANCH,REPO,repo])
        dest=repo/'signed';dest.mkdir(exist_ok=True)
        for name in NAMES:
            f=ROOT/'signed'/name
            if not f.is_file():raise RuntimeError('Missing signed input '+name)
            if (dest/name).exists():raise RuntimeError('Existing stage input; do not overwrite')
            shutil.copy2(f,dest/name)
        run(['git','-C',repo,'add',*[f'signed/{n}' for n in NAMES]])
        run(['git','-C',repo,'-c','user.name=MOA local release','-c','user.email=moa-local-release@users.noreply.github.com','commit','-m','Stage original-signed R783 and R784 APKs only'])
        run(['git','-C',repo,'push','origin',f'HEAD:{BRANCH}'])
    print('Signed APK pair staged. CI will verify independently before activating R783.')
def main():
    p=argparse.ArgumentParser()
    p.add_argument('--backup',type=Path)
    p.add_argument('--java')
    p.add_argument('--alias')
    p.add_argument('--stage',action='store_true')
    p.add_argument('--stage-only',action='store_true')
    p.add_argument('--check-only',action='store_true')
    a=p.parse_args()
    if a.stage_only:stage();return
    java=find_java(a.java)
    run([sys.executable,ROOT/'sign-offline.py','--check-only','--java',java])
    if a.check_only:return
    backup=a.backup or select_backup()
    if not backup.is_file() or sha(backup.read_bytes())!=BACKUP:raise RuntimeError('Original backup SHA256 mismatch; do not use a different key.')
    with zipfile.ZipFile(backup) as z,tempfile.TemporaryDirectory(prefix='moa-private-sign-') as tmp:
        matches=[z.read(i) for i in z.infolist() if not i.is_dir() and i.file_size<100000 and i.filename.lower().endswith(('.p12','.pfx'))]
        matches=[b for b in matches if sha(b)==KEY]
        if len(matches)!=1:raise RuntimeError('Original PKCS12 SHA256 mismatch or duplicate.')
        key=Path(tmp)/'original.p12';key.write_bytes(matches[0])
        cmd=[sys.executable,ROOT/'sign-offline.py','--java',java,'--keystore',key]
        if a.alias:cmd+=['--alias',a.alias]
        run(cmd)
    print('Local original-signed APKs saved under signed/. Private key was never staged or uploaded.')
    if a.stage:stage()
    else:print('To publish: rerun with --stage-only, or upload both APK files together to the exact signed/ staging folder.')
if __name__=='__main__':
    try:main()
    except Exception as e:
        print('STOP:',str(e) if not isinstance(e,subprocess.CalledProcessError) else 'Command failed; no unverified release.',file=sys.stderr)
        sys.exit(1)
