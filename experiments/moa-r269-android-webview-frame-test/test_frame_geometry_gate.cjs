const assert=require('node:assert/strict');
const g=require('./moa_naver_frame_geometry_gate.js'), SID='1628573942';
function base(){return {expectedSid:SID,childHost:'pcmap.place.naver.com',
 childUrl:'https://pcmap.place.naver.com/place/'+SID+'/home',
 matchingFrames:1,childControl:{x:120,y:200,w:40,h:36},
 frameRect:{x:300,y:80,w:640,h:720},childViewport:{w:640,h:720},
 parentViewport:{w:1280,h:800},webViewPixels:{w:1280,h:800}}}
let a=g.project(base());assert.equal(a.ok,true);assert.equal(a.x,440);assert.equal(a.y,298);
console.log('PASS original parent iframe position x='+a.x+', y='+a.y);
let shifted=base();shifted.frameRect={x:35,y:110,w:640,h:680};
a=g.project(shifted);assert.equal(a.ok,true);assert.equal(a.x,175);
assert.ok(a.y>280);console.log('PASS moved iframe actual px changed; no hardcoded tap');
let scaled=base();scaled.webViewPixels={w:640,h:400};
a=g.project(scaled);assert.equal(a.x,220);assert.equal(a.y,149);
console.log('PASS Android WebView pixel ratio conversion');
let ambiguous=base();ambiguous.matchingFrames=2;
assert.equal(g.project(ambiguous).gate,'AMBIGUOUS_OR_MISSING_PLACE_IFRAME');
let wrong=base();wrong.childUrl='https://pcmap.place.naver.com/place/3030303/home';
assert.equal(g.project(wrong).gate,'CHILD_PLACE_SID_MISMATCH');
let clipped=base();clipped.frameRect.x=1200;
assert.equal(g.project(clipped).gate,'PARENT_TARGET_OFFSCREEN');
let broken=base();broken.childControl.w=0;
assert.equal(g.project(broken).gate,'EMPTY_OR_TINY_GEOMETRY');
let dead=base();dead.parentViewport.w=0;
assert.equal(g.project(dead).gate,'EMPTY_OR_TINY_GEOMETRY');
let childOutside=base();childOutside.childControl.x=900;
assert.equal(g.project(childOutside).gate,'CHILD_TARGET_OUTSIDE_VIEWPORT');
console.log('PASS all ambiguity, SID, clipping and geometry deny rules');
