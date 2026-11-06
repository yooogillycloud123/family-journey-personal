#!/usr/bin/env python3
"""MOA release member-diff guard (no keys).

IMPORTANT: This compares immutable Golden bytes and APK contents. A PASS is NOT
Android PackageManager parse, signing-cert proof, app installation, or device QA.
Run apksigner/aapt2 separately and report those independent gates honestly.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import pathlib
import subprocess
import sys
import zipfile


def sha256_bytes(buf: bytes) -> str:
    return hashlib.sha256(buf).hexdigest()


def inspect_apk(path: pathlib.Path) -> dict:
    data = path.read_bytes()
    with zipfile.ZipFile(path) as zf:
        duplicate_names = len(zf.namelist()) != len(set(zf.namelist()))
        bad = zf.testzip()
        names = zf.namelist()
        hashed = {name: sha256_bytes(zf.read(name)) for name in names}
    return {"file": str(path), "size_bytes": len(data), "sha256": sha256_bytes(data),
            "zip_members": len(names), "duplicate_names": duplicate_names,
            "zip_crc": "PASS" if bad is None else f"FAIL: {bad}", "member_sha256": hashed}


def android_sign_gate(path: pathlib.Path, apksigner: str | None) -> dict:
    if not apksigner:
        return {"status": "NOT_TESTED", "why": "No apksigner path supplied; never infer APK v2/cert from ZIP CRC."}
    cmd = [apksigner, "verify", "--verbose", "--print-certs", str(path)]
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=45)
    except (OSError, subprocess.TimeoutExpired) as exc:
        return {"status": "FAIL", "reason": str(exc)}
    lines = (p.stdout + "\n" + p.stderr).splitlines()
    return {"status": "PASS" if p.returncode == 0 else "FAIL", "returncode": p.returncode,
            "diagnostic": [line for line in lines if ("verified" in line.lower() or "certificate sha-256" in line.lower() or "does not verify" in line.lower())][:12]}


def main() -> int:
    parser = argparse.ArgumentParser(description="Compare a candidate APK to immutable MOA R115 Golden member manifest")
    parser.add_argument("golden_manifest", type=pathlib.Path)
    parser.add_argument("candidate_apk", type=pathlib.Path)
    parser.add_argument("--golden-apk", type=pathlib.Path, help="Exact frozen R115 APK; verify bytes against Golden SHA")
    parser.add_argument("--allow", action="append", default=[], help="Explicit exact archive member allowed to change; repeat for each")
    parser.add_argument("--apksigner", help="Path to official Android SDK apksigner; verifies signature but not device installation")
    parser.add_argument("--require-apksigner", action="store_true", help="Fail closed if signer check not PASS")
    parser.add_argument("--report", type=pathlib.Path, help="JSON output path")
    args = parser.parse_args()
    baseline = json.loads(args.golden_manifest.read_text(encoding="utf-8"))
    expected_sha = baseline["sha256"]
    expected_members = baseline["member_sha256"]
    report = {"golden_sha_expected": expected_sha,
              "candidate": {}, "golden": {}, "changed": [], "added": [], "removed": [],
              "not_allowed_changes": [], "signature_gate": {}, "android_device_gate": "NOT_TESTED"}
    errors = []
    if args.golden_apk:
        current = inspect_apk(args.golden_apk)
        report["golden"] = {k: v for k, v in current.items() if k != "member_sha256"}
        if current["sha256"] != expected_sha or current["member_sha256"] != expected_members:
            errors.append("GOLDEN_APK_MISMATCH: frozen bytes/member inventory changed")
        if current["zip_crc"] != "PASS" or current["duplicate_names"]:
            errors.append("GOLDEN_APK_ZIP_FAILURE")
    candidate = inspect_apk(args.candidate_apk)
    report["candidate"] = {k: v for k, v in candidate.items() if k != "member_sha256"}
    if candidate["zip_crc"] != "PASS" or candidate["duplicate_names"]:
        errors.append("CANDIDATE_ZIP_FAILURE")
    cur = candidate["member_sha256"]
    report["changed"] = sorted(name for name in expected_members.keys() & cur.keys() if cur[name] != expected_members[name])
    report["added"] = sorted(cur.keys() - expected_members.keys())
    report["removed"] = sorted(expected_members.keys() - cur.keys())
    permitted = set(args.allow)
    affected = set(report["changed"] + report["added"] + report["removed"])
    report["not_allowed_changes"] = sorted(affected - permitted)
    if report["not_allowed_changes"]:
        errors.append("UNAPPROVED_MEMBER_CHANGE")
    if args.candidate_apk.resolve() != (args.golden_apk.resolve() if args.golden_apk else pathlib.Path("/nonexistent")) and candidate["sha256"] == expected_sha and affected:
        errors.append("HASH_COLLISION_OR_BAD_INVENTORY")
    report["signature_gate"] = android_sign_gate(args.candidate_apk, args.apksigner)
    if args.require_apksigner and report["signature_gate"]["status"] != "PASS":
        errors.append("SIGNATURE_NOT_VERIFIED")
    report["warnings"] = ["ZIP/member checks do not validate AndroidManifest typed resource IDs or resources.arsc density.",
                          "APK v2/certificate, Android install, actual launcher and all app features require separate checks.",
                          "New release MUST be versionCode >=117; verify manifest version with Android aapt/aapt2/PackageManager.",
                          "Never uninstall/clear MOA app data, never upload private signing keys."]
    report["gate"] = "FAIL" if errors else "PASS_MEMBER_DIFF_ONLY"
    report["errors"] = errors
    if args.report:
        args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({k: v for k, v in report.items() if k not in ["warnings"]}, ensure_ascii=False, indent=2))
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())