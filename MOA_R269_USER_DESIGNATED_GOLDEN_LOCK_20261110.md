# MOA R269 — 사용자 지정 불변 골든 기준본 (2026-11-10)

**사용자 요청에 따른 Golden 보존이며, R269 모든 기능의 실기기 PASS를 의미하지 않는다.** 기존 R227 사용자 골든도 별도로 변경 없이 유지한다.

- APK filename: `MOA_R269_USER_GOLDEN_DO_NOT_MODIFY.apk`
- Package `com.juhyeon.familyjournea` · versionCode **269**
- Exact APK size **8,932,642 bytes**
- SHA-256 **`c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920`**
- Original signer certificate SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- Exact original R269 binary copied into immutable-named backup in current conversation, all **142 APK ZIP members** sha256 + CRC32 recorded in `MOA_R269_USER_GOLDEN_MANIFEST.json` contained in local archive `MOA_R269_USER_GOLDEN_FREEZE_20261110.zip` SHA256 **`d00d069243b1dbe33712517289268aff77c5734685ff0265c5c18cb8aa3f8016`**; ZIP CRC PASS and inner original APK SHA exactly equals signed R269.
- Source branch frozen here from `feature/moa-r269-universal-naver-return-onpause-20261110`. **Never push further modifications onto this branch**; create higher version branch for any updates. No signing keys in GitHub.
- Library upload previously failed with `library_storage_limit_exceeded`, so **do not claim permanent Library APK upload**. The current chat has verified local golden ZIP and user-provided R269 signed APK in conversation.

## Historical functional truth (never fabricate)
- R255 actual Galaxy boot PASS and R261 user reported first-party NAVER native foreground favorites+memo save possible.
- R269 code retains R261 favorite automation unchanged (static file diff) and repairs Diary navigation return overlay hidden by gallery `onPause` cleanup.
- **R269 physical independent retest of all entrypoints NOT yet supplied**; snapshot is *user designated golden* not comprehensive acceptance PASS.
- **True screen-uninterrupted/offscreen NAVER account save**, new folder auto-creation, independent NAVER account favorite/list/alias/memo readback all **remain unimplemented or unverified**.
- User future goal: from Diary/photo GPS/Quick Record, one tap and MOA continues foreground while favorite+alias+memo+specified folder writes, even if NAVER app is not shown; no PC, root, Shizuku, helper app; existing foreground proven path must remain available and untouched.

## New user supplied NAVER Maps 6.7.2.1 split APKs
Private supplied `네이버지도-6.7.2.1-split-apks.zip` (base + arm64 + xxhdpi) must be examined for officially exposed intents/services/providers, URL scheme, and first-party UI save vs private API. Never publish third-party binary, extracted proprietary classes, login credentials, or private secrets. Analysis conclusions must distinguish proof vs speculation; inspecting source alone cannot grant background cross-app control. Root/Shizuku/hidden activity hacks must not be sold as user-compliant.

## Minimum release gates
- Preserve all exact Golden APK members except narrowly justified modified entries; note hash changes.
- User-visible new feature gated behind explicit proof of authenticated save & independent account readback; don't replace existing working native save with an unverified engine.
- Signed same-package+same-cert APK with increased versionCode, 1-app install with existing data retained and rollback; no false PASS based on apktool compile or UI toast.
- Preserve '↶ MOA' across all NAVER entrypoints and captured diary/recording metadata.
