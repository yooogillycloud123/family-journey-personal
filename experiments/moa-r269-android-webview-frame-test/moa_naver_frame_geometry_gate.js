/* Pure geometry gate: actual live iframe/place Save bounds -> owning WebView px.
 * Never performs a click/auth/save. Do NOT cache across viewport/DOM changes.
 */
(function(root,factory){
 const api=factory();
 if(typeof module==="object"&&module.exports)module.exports=api;
 else root.MoaNaverFrameGeometry=api;
})(typeof globalThis!=="undefined"?globalThis:this,function(){
 "use strict";
 const SID=/^[0-9]{5,20}$/;
 function sid(url){
   const m=String(url||"").match(/\/(?:entry\/)?place\/([0-9]{5,20})(?:[/?#]|$)/);
   return m&&SID.test(m[1])?m[1]:null;
 }
 function number(n){const v=Number(n);return Number.isFinite(v)?v:NaN;}
 function project(input){
   const q=input||{},expected=String(q.expectedSid||"");
   if(!SID.test(expected))return {gate:"INVALID_EXPECTED_SID",ok:false};
   if(sid(q.childUrl)!==expected)return {gate:"CHILD_PLACE_SID_MISMATCH",ok:false};
   if(String(q.childHost)!=="pcmap.place.naver.com")
     return {gate:"CHILD_ORIGIN_NOT_FIRST_PARTY",ok:false};
   if(Number(q.matchingFrames)!==1)return {gate:"AMBIGUOUS_OR_MISSING_PLACE_IFRAME",ok:false};
   const c=q.childControl||{},fr=q.frameRect||{},cv=q.childViewport||{},
     pv=q.parentViewport||{},wv=q.webViewPixels||{};
   const vals=[c.x,c.y,c.w,c.h,fr.x,fr.y,fr.w,fr.h,cv.w,cv.h,pv.w,pv.h,wv.w,wv.h].map(number);
   if(vals.some(v=>!Number.isFinite(v)))return {gate:"UNRELIABLE_GEOMETRY",ok:false};
   if([c.w,c.h,fr.w,fr.h,cv.w,cv.h,pv.w,pv.h,wv.w,wv.h].some(v=>number(v)<=2))
     return {gate:"EMPTY_OR_TINY_GEOMETRY",ok:false};
   const childX=number(c.x)+number(c.w)/2,childY=number(c.y)+number(c.h)/2;
   if(childX<0||childY<0||childX>number(cv.w)||childY>number(cv.h))
     return {gate:"CHILD_TARGET_OUTSIDE_VIEWPORT",ok:false};
   // Parent iframe viewport may be scaled by responsive CSS; map with measured ratio.
   const cssX=number(fr.x)+childX*number(fr.w)/number(cv.w);
   const cssY=number(fr.y)+childY*number(fr.h)/number(cv.h);
   if(cssX<0||cssY<0||cssX>number(pv.w)||cssY>number(pv.h))
     return {gate:"PARENT_TARGET_OFFSCREEN",ok:false};
   const x=cssX*number(wv.w)/number(pv.w);
   const y=cssY*number(wv.h)/number(pv.h);
   if(!Number.isFinite(x)||!Number.isFinite(y))
     return {gate:"INVALID_NATIVE_COORDINATE",ok:false};
   return {gate:"EXACT_FRAME_TARGET_IN_WEBVIEW_READY_USER_APPROVAL_REQUIRED",ok:true,
     x:Math.round(x*100)/100,y:Math.round(y*100)/100,
     sid:expected};
 }
 return Object.freeze({sid,project});
});
