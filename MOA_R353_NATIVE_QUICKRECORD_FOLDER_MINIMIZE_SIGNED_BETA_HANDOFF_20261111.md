# MOA R353 actual native QuickRecord checkbox + folder / minimize icon — signed BETA (2026-11-11)

## User correction (must respect)
User screenshots clearly showed the previous R349 placed a large '☆ 바로기록 · 네이버 즐겨찾기 연동' card **inside Diary photo cards**, which is wrong. The intended target is the real **Android native '모아 · 순간 기록' popup**, **beside its heading** one compact `장소 저장` checkbox; expanding only when checked to show **one target list-name input**, **NO alias input**, **NO extra Diary photo-card panel**. Save with the original Diary button. Use photo/video EXIF GPS and text from voice dictation or source M4A auto-transcription if present; memo empty otherwise; existing R345 real first-party offscreen NAVER favorites engine retains existing/new private folder behavior. User wants home float icon to look like **minimize**, not house.

## Immutable anchor
- User device Golden **R345** APK SHA256 `fe2aaaac15d39a610268ee3d10361652a95537e0ce8ec9cde86e98edf3f8ceb1`; original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` unchanged.
- Current prepatch **R349** APK `MOA_R349_R345_GOLDEN_HOME_QUICKFAVORITES_BETA.apk`; web-added overlay was wrong and must not survive.
- No modification to original Golden APK or its frozen branch.
- Original R345 `assets/web/moa-r231-naver-frame-probe.js` remains byte identical in R353. `assets/web/fj-naver-favorites.js` is byte-identical to R349, with underlying proven R345 saving behavior retained.

## Actual source and artifacts created in this continuation
- **New same-signer installable R353** `MOA_R353_NATIVE_QUICK_RECORD_FAVORITES_MINIMIZE_BETA.apk`, package unchanged `com.juhyeon.familyjournea`, versionCode353, size **8,892,711B**, SHA256 **`2cfc40742c19e6ae7c2ae7bfe7dd52dc8a2a3c70fac2d90cc4c4a1afd747ac6e`**. APK v2 RSA + full content digest, ZIP CRC, all DEX checksums, stored alignment PASS.
- **R355 emergency forward restore EXACT R345 Golden** `MOA_R355_FORWARD_RECOVER_EXACT_R345_GOLDEN.apk`, code355, size 8,880,150B, SHA256 **`e499ed03b59b1efc9ff85aa8bbaf442d214ddea3f6812d871c93bf584802be6a`**, every original R345 uncompressed archive member byte-equal except Manifest version. Not routine install and not Galaxy tested.
- Whole set `MOA_R353_APK_R355_EXACT_GOLDEN_RECOVERY_SOURCE_QA_20261111.zip`, SHA256 `249796505f20ba99883a1282884fb1b924182ebdf36d7d7ca78ae318b66ef2d8` includes exact signed APKs, QA, JS sources/test, compiled DEX proof.
- R349→R353 only 5 archive members modified: Manifest, **classes7.dex**, `family-diary.js`, `moa-r349-home-favorites.js`, `moa-r349-quick-favorites.js`. **135/140 R349 original payloads identical**. 15/16 DEX binary unchanged; regenerated classes7 contains **all 34 original class definitions** plus one new R353 lambda, preserving MoaR165AudioExport classes (full original Java compiled rather than stub packaging). Native isolated compiled source DEX SHA256 `f55721e55eced9fa8f6cd80a569c66ed7194b1dfc186eafd4a50874e3a82f373`, classes.dex size 55,428B. All DEX Adler/SHA pass.
- GitHub feature branch `feature/moa-r353-native-quickrecord-folder-20261111` contains modified exact native `experiments/moa-r353-native/MoaMomentMemoRecorderActivity.java`, original `MoaR165AudioExport.java`, and CI workflow `moa-r353-native-quickrecord-dex.yml`. GitHub workflow run **43025608434 SUCCESS**, actual DEX artifact original. **Signing remains local/private only**, not CI.
- Browser JS source: original R349 diary companion is replaced with a **headless native event consumer**, no photo-card UI injection, no alternate NAVER writer. The family-diary native commit event now forwards `naverQuickFavorite`, `naverQuickList`, `naverQuickRequestedAt`, note/voiceAutoTranscript after IDB commit. Only explicitly selected native records trigger one idempotent job and unique GPS photo association. Default folder uses explicit native input > configured pinned folder > '내 장소'. Existing R349 settings remain, not redesigned.
- Inward-arrow SVG replaces house icon, retains float gestures and persisted coordinates.
- Node actual contract tests PASS: native OFF no favorite call, native ON exactly one favorite call, pinned folder fallback, note→memo, duplicate event no repeat, no Diary-card injected UI. Syntax checks pass.

## Important limits — do not misreport
- R353 native UI is compiled from source and packaged, **not yet user-device/Galaxy UI verified**. Login/session/server write not tested in this turn.
- R353 still uses the established R345 WebView engine and its fallback requirements. No assertion that the Android OS keeps hidden WebView alive through process kill.
- The footer audio/M4A/SpeechRecognizer source is based on previously working R217 recorder; recompiled rather than binary-patched, so runtime regression still needs validation despite full class definition preservation.
- Blank memo with native checkbox ON is permitted to save Diary and queue NAVER, but still **requires reliable GPS/photo ID**. Do not guess missing GPS.
- Per-user native checkbox defaults to unchecked for a new draft; configured web Settings default checkbox does not currently sync into native SharedPreferences; do not claim it does. User can check manually.
- R353 includes HTML floater only on MOA's WebView tabs, not unrelated native Android system Activities.

## Physical test
Install R353 as same-package update **without uninstall/data clear**. First check actual '모아 · 순간 기록' heading and `장소 저장` checkbox. Check native recording/playback and Diary once; with checkbox ON and one photo having known EXIF GPS test one NAVER list; inspect account list and any new list creation. Check checkbox OFF no NAVER operation. Check float minimize icon and one-tap Calendar. No repeated saves on uncertain status. Use R355 only if regression; it restores exact R345 functions but remains a separate higher-code recovery test candidate.

## Next work if failing
Use screenshot/status and fix **one gate only**. Avoid creating a new photo-card editor again or changing R345 Naver frame agent. New updates need versionCode >=357 to advance past R355.
