# MOA R667 real Galaxy installation FAIL; R669 corrected AndroidManifest; R670 R665-functional recovery — 2026-11-17

## User verified problem
Samsung Galaxy package installer rejected the submitted R667 APK (user private screenshots 23385.png, 23387.png): “앱을 설치할 수 없음 / 앱 파일에 문제가 있습니다.” This is an INSTALLATION failure, NOT a runtime gallery problem. NEVER claim the invalid R667 is installable again. Preserve currently installed R665 and all user data. Raw screenshots are private.

## Definitive root cause independently reproduced using official Android SDK 35
Original R667 signed file SHA256 99d778d998c497f0a534bd9dd17769d0c6ac8ce64c0684b0698f0782faf0d2be. R667 handwritten AndroidManifest binary XML appender incorrectly set new ResXMLTree_node start headerSize to 36 and end headerSize to 24. For both node types the true headerSize MUST BE 16 (chunk sizes of start/end differ). Offsets of four malformed new nodes: 17936, 18032, 18056, 18132. The old custom XML reader did NOT validate headerSize and wrongly gave PASS.

OFFICIAL Android SDK 35 apksigner verify on R667 FAILED:
  malformed binary resource: AndroidManifest.xml
  Attributes start offset out of bounds: 115, max: 60
OFFICIAL aapt dump badging WARNED:
  Bad XML block: node attributes use 0x73 bytes, only have 0x3c bytes.
The previously user-physically successful R665 passed both official tools. SDK tools were retrieved from connected GitHub Actions run 41256299195 artifact 13063416824 (public aapt, aapt2, apksigner, zipalign); original private signing key was NEVER published.

## Corrected same-original-signer releases
R669 install file MOA_R669_INSTALL.apk: versionCode 669, 9,364,488 bytes, SHA256 5c4563b62dcb5e4093b2c9684a8d258895a6715c9709eac26e02043b4d033832. Based on exact R667 all 152 ZIP entries, fixes ONLY AndroidManifest.xml: four headerSize bytes and versionCode667→669. All 19 DEX, complete Web UI, new independent native picker and original PHOTO native Gallery/QuickRecord bytes remain identical.

R670 forward rescue file MOA_R670_RECOVERY.apk: versionCode 670, 9,271,330 bytes, SHA256 bced9253025a7afa3985b12f1a5d76eb2a8f8e4fc7a1767e4e4e15548dacb187. Based on original user-physical working R665, all 149 ZIP entries identical except AndroidManifest.xml versionCode665→670, all original 18 DEX exact. If R670 installed future code must be >=671.

Both remain package com.juhyeon.familyjournea and original signer cert SHA256 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15. Official SDK on R669 and R670 all PASS: apksigner.jar verify --min-sdk-version 29 --max-sdk-version 37, aapt dump badging no malformed XML, aapt2 dump xmltree --file AndroidManifest.xml (R669 provider, activity, exported and authorities valid), zipalign -c 4. Independently checked v2 cryptographic content digest, APK ZIP CRC, exact old/new member diff (Manifest only) and exact matching DEX. This is official package static PASS, NOT user Galaxy installation or feature PASS.

Bundle: MOA_R669_R670_INSTALL_REPAIR_SET.zip, 18,638,708 bytes, SHA256 f25c252c8bd557670a09f8ac06f64ff0dda63306f2734baa7a0a9cc10d1e216e, both APKs and readme and official SDK QA JSON; no credentials or personal photos.

## Future non-negotiable gates
Never release a manually modified AndroidManifest with only a handwritten XML parser + ZIP + signature self-check. Every APK MUST pass official Android SDK apksigner verify, aapt dump badging, aapt2 dump xmltree, zipalign, package/code/cert, DEX and source diff; then actual Galaxy installation and PHOTO/QuickRecord/OneHand/independent picker hardware QA. A correctly signed APK CAN still contain malformed AndroidManifest. No uninstall, clear data, IndexedDB wipe or Naver account reset. If R669 still fails to install, get actual ADB INSTALL_* error without guessing; user has not yet supplied that diagnostic. Protect original R665 user-PHOTO Golden, and do not touch unrelated AirPods/Android Auto audio runtime.
