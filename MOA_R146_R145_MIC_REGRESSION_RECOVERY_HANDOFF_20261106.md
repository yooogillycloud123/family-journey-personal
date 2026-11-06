# MOA R146 — R145 real-device microphone and existing STT regression; immediate rollback-forward

Date 2026-11-06 KST. **Recovery candidate signed/static verified. R146 Galaxy install and old STT recovery are NOT YET TESTED.**

## User physical findings — R145 = FAIL
- User installed R145 and provided two Galaxy screenshots `19205.png`, `19207.png`.
- New original-audio recording `🎙 음성 녹음·목록` shows `마이크를 사용할 수 없습니다: Permission denied · Android 마이크 권한과 WebView 지원 여부를 확인해 주세요.` This proves new **WebView `getUserMedia` acquisition failed** on handset. Exact layer (site permission callback vs OS permission state) is **NOT established**.
- Existing native Diary `음성 입력` no longer reacts and its paired control shows `음성 준비 중...` instead of working. User separately says native `바로기록` voice memo still works. Do not infer entire Android microphone permission revoked. **Legacy STT regression reported**; exact root not yet proven.
- Prior R145 beta included `moa-r145-voice-diary.js` and `.css` and its index.html references; initial isolated mock never exercised real WebView permissions. This is a release gate failure, despite static APK v2 and mock PASS. Do not reintroduce this module without an actual Android WebChromeClient permission + native STT regression gate.

## R146 immediate recovery choice
- Existing, previously signed **R146** emergency forward-restore APK was already generated in the immediately preceding R145 work. We reused its exact bytes rather than changing any more existing features.
- User-facing direct-copy: `MOA_R146_RESTORE_EXISTING_VOICE_INPUT.apk`, original internal `MOA_R146_EMERGENCY_RESTORE_R143_NOT_ROUTINE.apk`. This is now delivered as **actual R145 recovery** on explicit regression evidence.
- Package `com.juhyeon.familyjournea`, versionCode **146** (> installed 145), APK SHA-256 **`3081b164feab32e090123136f4f31e98706a723a43c7ffac2516fcb3962258d5`**, exact **5,460,532 bytes**. Signing certificate remains historical R115 signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` per original R146 independent signing QA.
- R146 is **identical to original R143** SHA256 `709c2bc906159d2e93ce4f407def0016a04e45f8d492e31d948d65aa55bca5d1` in **123/124** APK ZIP members. Only the binary `AndroidManifest.xml` versionCode byte differs (143→146). 5 DEX, existing Diary `family-diary.js`, native STT, original storage/Family, maps, full-month 3-column mixed media/gallery/Back all byte-identical.
- No R145 `moa-r145-voice-diary.js/css` or their index.html includes. Old `moa-diary-voice-v1` data, if ever created, is not erased; the R146 UI no longer exposes it. No uninstall/clear data, no new permission or migration.

## Repeatable static verification
- Current-turn exact new `/mnt/data/MOA_R146_RESTORE_EXISTING_VOICE_INPUT.apk` and ZIP `/mnt/data/MOA_R146_RESTORE_EXISTING_VOICE_INPUT.zip` created from signed original bytes.
- SHA256 exactly matches existing R146 QA `3081b164...2258d5` and ZIP inner APK.
- APK v2 **content digest** independently recomputed using available APK verifier; prior R146 signing QA reports RSA PKCS#1 SHA256 verification/old cert PASS. ZIP CRC, 37 aligned STORED entries, original DEX internal SHA1/Adler32 and byte equality PASS. This is static only.

## Required physical release gate
1. Install R146 **over** R145, do not uninstall or clear storage.
2. Open original Diary day → existing `음성 입력` mic → record speech and verify actual recognized words/inserted text, not just button appearance.
3. Verify native quick `바로기록` voice still works; existing Diary save, selected photo/gallery, month report whole-media scroll, Family events unchanged.
4. If legacy STT still fails on R146, do not claim R145 module was sole cause. Read-only collect exact control state and relevant Android logs; then repair native STT without changing original media storage.

## Policy
- Freeze R145 new original-recording WebView module as `REAL_DEVICE_MIC_FAIL`; no new microphone attempts by blind JS-only patches, and do not report feature complete based on synthetic mocks.
- Music integration remains explicitly EXCLUDED from MOA roadmap.
- Keep exact R115 Golden, R133, R143, R145 forensic signed copies, AirPods golden unchanged. Chat-only APK; no email, no publication of private signer keys or user media.