#!/usr/bin/env python3
"""Read-only MOA R227 native navigation preservation gate.

This does NOT prove runtime behavior, signer validity, UI correctness, or Naver
account writes. Never upload proprietary/personal APKs or signer material.

Usage:
  python moa_r227_nav_return_static_gate.py --golden /private/R227.apk
  python moa_r227_nav_return_static_gate.py --golden /private/R227.apk \
      --candidate /private/R229.apk --allowed-changes AndroidManifest.xml classes6.dex
"""
from __future__ import annotations
import argparse
import hashlib
import json
import struct
import sys
import zipfile
import zlib
from pathlib import Path

GOLDEN_SHA256 = '53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd'
GOLDEN_ZIP_MEMBER_COUNT = 130
REQUIRED_NATIVE_SYMBOLS = (
    b'r227RetainForExternalMap',
    b'r227ResumeFromExternalMap',
    b'r227ExternalMapPending',
    b'r225OpenNaver',
    b'nmap://place',
    b'com.nhn.android.nmap',
)


def hash_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open('rb') as f:
        while True:
            piece = f.read(1024 * 1024)
            if not piece: break
            h.update(piece)
    return h.hexdigest()


def dex_check(name: str, data: bytes) -> dict:
    out = {'name': name, 'size': len(data), 'valid_magic': data.startswith(b'dex\n')}
    if len(data) < 40 or not out['valid_magic']:
        out.update(header_sha1_pass=False, header_adler32_pass=False)
        return out
    stored_sha1 = data[12:32]
    out['header_sha1_pass'] = stored_sha1 == hashlib.sha1(data[32:]).digest()
    stored_checksum = struct.unpack_from('<I', data, 8)[0]
    out['header_adler32_pass'] = stored_checksum == (zlib.adler32(data[12:]) & 0xFFFFFFFF)
    return out


def inspect(path: Path) -> dict:
    out = {'path': str(path), 'file_exists': path.is_file()}
    if not out['file_exists']:
        out['error'] = 'APK not found'; return out
    out['apk_sha256'] = hash_file(path)
    out['bytes'] = path.stat().st_size
    try:
        with zipfile.ZipFile(path) as z:
            out['zip_crc_pass'] = z.testzip() is None
            members = z.namelist()
            out['zip_members'] = len(members)
            out['duplicate_zip_names'] = len(members) != len(set(members))
            dex_names = [n for n in members if n.endswith('.dex') and '/' not in n]
            out['dex'] = [dex_check(n, z.read(n)) for n in dex_names]
            if 'classes6.dex' in members:
                d = z.read('classes6.dex')
                out['native_return_symbols'] = {x.decode(): (x in d) for x in REQUIRED_NATIVE_SYMBOLS}
            else:
                out['native_return_symbols'] = {'classes6.dex': False}
            out['_member_sha256'] = {i.filename: hashlib.sha256(z.read(i)).hexdigest() for i in z.infolist()}
    except (OSError, zipfile.BadZipFile) as e:
        out['error'] = type(e).__name__
    return out


def check_golden(g: dict) -> list[str]:
    fail = []
    if g.get('apk_sha256') != GOLDEN_SHA256: fail.append('immutable R227 APK SHA256 mismatch')
    if g.get('zip_members') != GOLDEN_ZIP_MEMBER_COUNT: fail.append('R227 unexpected ZIP member count')
    if not g.get('zip_crc_pass') or g.get('duplicate_zip_names'): fail.append('ZIP CRC or name collision')
    for d in g.get('dex', []):
        if not d.get('header_sha1_pass') or not d.get('header_adler32_pass'):
            fail.append('DEX header checksum: ' + d['name'])
    if len(g.get('dex', [])) != 9: fail.append('Expected nine DEX entries')
    for k, ok in g.get('native_return_symbols', {}).items():
        if not ok: fail.append('Missing native return symbol ' + k)
    return fail


def main() -> int:
    pa = argparse.ArgumentParser()
    pa.add_argument('--golden', type=Path, required=True)
    pa.add_argument('--candidate', type=Path)
    pa.add_argument('--allowed-changes', nargs='*', default=['AndroidManifest.xml','classes6.dex'])
    pa.add_argument('--report', type=Path)
    a = pa.parse_args()
    gold = inspect(a.golden)
    fails = check_golden(gold)
    cand = None
    if a.candidate:
        cand = inspect(a.candidate)
        if not cand.get('zip_crc_pass') or cand.get('duplicate_zip_names'):
            fails.append('candidate ZIP invalid')
        for d in cand.get('dex', []):
            if not d.get('header_sha1_pass') or not d.get('header_adler32_pass'):
                fails.append('candidate DEX header checksum: '+d['name'])
        original = gold.get('_member_sha256', {})
        updated = cand.get('_member_sha256', {})
        changes = [n for n in sorted(set(original)|set(updated)) if original.get(n)!=updated.get(n)]
        cand['changed_members'] = changes
        cand['disallowed_changes'] = [n for n in changes if n not in a.allowed_changes]
        if cand['disallowed_changes']:
            fails.append('candidate unexpected changes: '+', '.join(cand['disallowed_changes']))
    gold.pop('_member_sha256', None)
    if cand: cand.pop('_member_sha256', None)
    report = {
        'test_type': 'READ_ONLY_STATIC_PRESERVATION_NOT_PHYSICAL_QA',
        'golden': gold, 'candidate': cand,
        'expected_allowed_candidate_changes': a.allowed_changes,
        'static_preservation_gate': 'PASS' if not fails else 'FAIL',
        'failures': fails,
        'not_covered': ['Android manifest binary semantics', 'APK-v2 signature verification',
            'Android package/versionCode install', 'Android Activity lifecycle actual behavior',
            'Naver internal back stack', 'correct photo index on return',
            'Naver account/list favorites persistence'],
    }
    result = json.dumps(report, ensure_ascii=False, indent=2)
    if a.report: a.report.write_text(result+'\n', encoding='utf-8')
    print(result)
    return 0 if not fails else 1


if __name__ == '__main__':
    sys.exit(main())