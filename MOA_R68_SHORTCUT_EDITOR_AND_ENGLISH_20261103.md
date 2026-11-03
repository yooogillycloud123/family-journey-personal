# MOA R68 user follow-up

R63 remains the immutable, user-verified photo-memo Golden. R66 OHO+ shortcut does not appear in Samsung chooser. R68 adds an exported ACTION_CREATE_SHORTCUT Activity and an always-visible diary editor action bar. R68 is built and signed but Samsung OHO+ runtime is not yet verified. Future photo English learning will derive separate bilingual lessons from curated photo IDs, capture timestamps and Korean notes without changing the original diary.
## Actual evidence and correction
- User Samsung OHO+ screenshots show OTHER apps' shortcuts but not 모아 / MOA. R66 only registered dynamic/pinned shortcut, never declared an AndroidManifest ACTION_CREATE_SHORTCUT Activity; therefore the missing chooser item was a real UX failure, not user confusion.
- R68 branch `fix/moa-r68-visible-shortcut-sticky-editor-20261103` adds `MoaMomentShortcutProvider.java` and AndroidManifest exported Activity with intent-filter action `android.intent.action.CREATE_SHORTCUT`, category DEFAULT, label `모아 기록 전환`. Activity returns pre-existing real monitor-toggle action through ShortcutManager result and legacy shortcut result extras. This follows official Android custom shortcut API. Samsung chooser enumeration remains unverified.
- Journal's long editor originally has title/body at top, media/time notes and save far below. R68 adds a fixed bottom toolbar `제목·본문 | 시간대 메모 | 일기 저장` that jumps to the existing fields or calls the original save function. Original title/body/tag/feeling/photo selection/time memo/cancel/delete all remain unchanged.
- R66 original 5-minute timeline grouping and R63 user's confirmed same-origin IndexedDB photo-note writer remain unchanged.

## Binary/build proof
- Source Java D8 compiled in GitHub Actions run `41655818666` SUCCESS.
- Signed APK `MOA_R68_OneHand_RealShortcut_StickyDiary_BETA.apk` SHA256 `4e74ab1ace5101466c3b4b647ea2c44e8d10076667add5e3385ab3e9f7fdf182`, size 3,428,422 bytes, same package `com.juhyeon.familyjournea`, versionCode 68, same signing certificate.
- Exactly 3 APK members differ versus R66: `AndroidManifest.xml`, `classes4.dex`, `assets/web/family-diary.js`. 51 other entries byte-identical, especially the actual Golden `assets/web/moa-direct-diary-commit.html`, Naver automation and base DEX.
- Binary-XML tree/attribute check, ZIP CRC, DEX header and APK v2 signature PASS. **Real Samsung One Hand Operation+ discovery/runtime remains NOT VERIFIED.** Do not claim R68 Golden; R63 remains physical Golden.

## Future photo-English learning — product extension, NOT R68 implementation
- User explicitly wants a **photo at 2026-11-03 11:30 and its own Korean note** to be displayed together as a complete English learning activity, not just a translated isolated phrase. Preserve attached images, exact capture hour/minute, whole memo, optional day title/body and related timed notes.
- Add a new `사진 영어 공부` screen **alongside**, not inside, the protected diary writer. Choose day/time/photo or five-minute displayed segment, read from existing IndexedDB `curated` (`photoIds`, `moments[{at,photoIds,note}]`, `activities`, `title`, `body`). The 5-minute groups are just display buckets; each image keeps its own media ID and exact original time.
- Derive a separate `photoEnglishV1` learning cache keyed by stable source mediaId + original capture timestamp + source revision hash + language. Include Korean source, full fluent English paragraphs, Korean/English sentence alignment, vocabulary, usage examples, optional TTS/listening/pronunciation practice, mini-quiz and review progress. Do not replace original memo or corrupt source dates.
- When user edits diary memo, detect source revision mismatch, mark translated lesson stale and offer refresh; retain any manually edited English unless user confirms overwrite.
- No private family photos are uploaded automatically. A full natural translation engine may need offline model installation or an optional authorized internet provider; do NOT promise offline complete translation before implementation. English learning is **planned and documented**, not shipped in R68 APK.
- Sample: 2026-11-03 11:30 photo + note “오늘 공원에서 함께 놀았다” → “We played together in the park today.” Then speaking/audio/vocabulary practice anchored to that **same original photo and 11:30**, regardless of time of study.
