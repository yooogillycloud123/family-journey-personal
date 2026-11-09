// Node mock verifies *non-mutating, origin-limited* probe behavior only.
// It does NOT simulate NAVER login, UI layout, save or a real Galaxy WebView.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const path = require('node:path');
const script = fs.readFileSync(path.join(__dirname,'naver-origin-frame-probe.js'),'utf8');
for (const banned of [/\.click\s*\(/, /\.submit\s*\(/, /document\.cookie/, /localStorage\s*\./,
                      /\.value\s*=/, /fetch\s*\(/, /XMLHttpRequest/, /navigator\.sendBeacon/]) {
  assert.equal(banned.test(script),false,'unexpected mutating or secret-reading API: '+banned);
}
function run(origin) {
 const posted=[];let queried=0;
 const doc={readyState:'complete',documentElement:{},
   querySelectorAll:(q)=>{queried++;return q.includes('btn_favorite')?[{},{}]:[];},
   addEventListener:()=>{}};
 const window={MoaNaverProbeBridge:{postMessage:s=>posted.push(JSON.parse(s))},addEventListener:()=>{}};
 window.top=window;
 const context={window,document:doc,location:{origin},performance:{now:()=>57.2},
    MutationObserver: class {observe(){} disconnect(){}},Promise};
 vm.runInNewContext(script,context);
 return {posted,queried};
}
const allowed=run('https://pcmap.place.naver.com');
assert.equal(allowed.posted.length,1);
assert.equal(allowed.posted[0].schema,'moa.naver.web.probe.v1');
assert.equal(allowed.posted[0].counts.saveButton,2);
assert.equal(Object.keys(allowed.posted[0]).some(x=>/cookie|token|password|url|address|text/i.test(x)),false);
const blocked=run('https://example.com');
assert.equal(blocked.posted.length,0);assert.equal(blocked.queried,0);
const root=run('https://map.naver.com');assert.equal(root.posted.length,1);
console.log('MOA_NAVER_WEB_FRAME_PROBE_STATIC_TEST=PASS read_only origin_guard no_secret_no_click');