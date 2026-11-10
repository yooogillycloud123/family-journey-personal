/*
 * MOA R269/R283 successor — safe first-party NAVER Place save preflight.
 * SOURCE-ONLY research. It never clicks, logs in, reads tokens/cookies, saves,
 * or claims success. Integrators must confirm account readback independently.
 * Coordinates are calculated from current live DOM bounds; never hardcode px.
 */
(function(root,factory){
  const api=factory();
  if(typeof module==="object"&&module.exports)module.exports=api;
  else root.MoaNaverSaveGate=api;
})(typeof globalThis!=="undefined"?globalThis:this,function(){
  "use strict";
  const ID=/^[0-9]{5,20}$/;
  function normalizeSid(value){
    const v=String(value===undefined||value===null?"":value).trim();
    return ID.test(v)?v:null;
  }
  function sidFromUrl(value){
    const match=String(value||"").match(/\/(?:entry\/)?place\/([0-9]{5,20})(?:[/?#]|$)/);
    return match?normalizeSid(match[1]):null;
  }
  function classify(input){
    const expected=normalizeSid(input&&input.expectedSid);
    if(!expected)return {gate:"INVALID_EXPECTED_SID",clickable:false};
    const pageSid=sidFromUrl(input&&input.url);
    const candidates=Array.isArray(input&&input.candidates)?input.candidates:[];
    const placeIds=(Array.isArray(input&&input.listingSids)?input.listingSids:[])
      .map(normalizeSid).filter(Boolean);
    const distinct=[...new Set(placeIds)];
    const isPlaceHost=String(input&&input.host||"")==="pcmap.place.naver.com";
    if(!pageSid){
      return {gate:distinct.includes(expected)?"PLACE_DETAILS_NOT_OPEN":"EXACT_PLACE_NOT_RESOLVED",
        clickable:false,resultCount:distinct.length};
    }
    if(pageSid!==expected)return {gate:"SID_MISMATCH",clickable:false,pageSid};
    if(!isPlaceHost)return {gate:"WRONG_FRAME_ORIGIN",clickable:false,pageSid};
    const valid=candidates.filter(c=>
      c&&c.kind==="place_save"&&normalizeSid(c.sid)===expected&&c.connected===true&&
      c.enabled===true&&c.renderable===true&&Number(c.width)>=3&&Number(c.height)>=3&&
      c.hitTarget===true);
    if(valid.length!==1)return {
      gate:valid.length>1?"AMBIGUOUS_SAVE_CONTROLS":"EXACT_SAVE_CONTROL_NOT_READY",
      clickable:false,matchCount:valid.length,pageSid
    };
    const b=valid[0];
    if(b.pressed==="true")return {gate:"UI_ALREADY_SAVED_SERVER_READBACK_REQUIRED",
      clickable:false,pageSid};
    if(b.pressed!=="false")return {gate:"UNRELIABLE_SAVE_STATE",clickable:false,pageSid};
    if(input.authenticated!==true)return {gate:"AUTH_NOT_VERIFIED",
      clickable:false,pageSid};
    return {gate:"EXACT_SAVE_CONTROL_READY_USER_APPROVAL_REQUIRED",
      clickable:true,pageSid,controlId:b.controlId||null};
  }
  function inspectDom(win,expectedSid){
    const doc=win&&win.document;
    const location=win&&win.location;
    if(!doc||!location)return {gate:"DOCUMENT_NOT_READY",clickable:false};
    const host=String(location.hostname||"");
    const href=String(location.href||"");
    // Select only the Place-detail Save control, NEVER NAVER top 'saved lists' nav.
    const target=normalizeSid(expectedSid);
    const els=Array.from(doc.querySelectorAll('a[data-nlog-area="map_btp.save"],button[data-nlog-area="map_btp.save"]'));
    const candidates=els.map((a,i)=>{
      const r=a.getBoundingClientRect();
      const x=r.left+r.width/2, y=r.top+r.height/2;
      const hit=doc.elementFromPoint(x,y);
      return {
        controlId:"place-save-"+i,kind:"place_save",sid:sidFromUrl(href),
        connected:a.isConnected===true,enabled:!a.disabled&&!a.hasAttribute("disabled"),
        renderable:r.width>=3&&r.height>=3,
        width:Math.round(r.width),height:Math.round(r.height),
        pressed:a.getAttribute("aria-pressed"),
        hitTarget:!!hit&&(hit===a||a.contains(hit))
      };
    });
    const listingSids=Array.from(doc.querySelectorAll('a[href*="/place/"],a[href*="/entry/place/"]'))
      .map(a=>sidFromUrl(a.getAttribute("href"))).filter(Boolean).slice(0,100);
    // Browser's logged-in appearance is NOT sufficient to attest authenticated writes.
    return classify({expectedSid:target,url:href,host,candidates,listingSids,authenticated:false});
  }
  return Object.freeze({normalizeSid,sidFromUrl,classify,inspectDom});
});
