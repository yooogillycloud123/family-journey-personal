const assert=require('node:assert/strict');
const gate=require('./moa_naver_dynamic_save_gate.js');
const SID='1628573942';
const origin='https://pcmap.place.naver.com/place/'+SID+'/home';
function btn(sid=SID,more={}){return {sid,kind:'place_save',connected:true,enabled:true,
renderable:true,width:40,height:40,pressed:'false',hitTarget:true,...more};}
function check(name,inp,want,clickable=false){
 const got=gate.classify({host:'pcmap.place.naver.com',url:origin,expectedSid:SID,
 authenticated:true,candidates:[btn()],...inp});
 assert.equal(got.gate,want,name);assert.equal(got.clickable,clickable,name);
 console.log('PASS '+name+' -> '+want);
}
assert.equal(gate.sidFromUrl('/p/entry/place/1628573942'),'1628573942');
assert.equal(gate.sidFromUrl('/place/1628573942/home'),'1628573942');
assert.equal(gate.sidFromUrl('/search/서울역'),null);
check('exact authenticated single Place',{listingSids:[SID]},'EXACT_SAVE_CONTROL_READY_USER_APPROVAL_REQUIRED',true);
check('multiple results but exact place selected',{listingSids:['1010101',SID,'3030303']},
  'EXACT_SAVE_CONTROL_READY_USER_APPROVAL_REQUIRED',true);
check('multiple listings no selected detail',{url:'https://map.naver.com/p/search/test',
  listingSids:['1010101',SID]},'PLACE_DETAILS_NOT_OPEN');
check('wrong SID selected',{url:'https://pcmap.place.naver.com/place/3030303/home'},
  'SID_MISMATCH');
check('top nav false-positive',{candidates:[{...btn(),kind:'saved_lists_navigation'}]},
  'EXACT_SAVE_CONTROL_NOT_READY');
check('duplicate target save controls',{candidates:[btn(),btn()]},'AMBIGUOUS_SAVE_CONTROLS');
check('control shifted, stale hit',{candidates:[btn(SID,{hitTarget:false})]},'EXACT_SAVE_CONTROL_NOT_READY');
check('control outside viewport',{candidates:[btn(SID,{width:0,height:0,renderable:false})]},'EXACT_SAVE_CONTROL_NOT_READY');
check('not authenticated',{authenticated:false},'AUTH_NOT_VERIFIED');
check('already pressed',{candidates:[btn(SID,{pressed:'true'})]},'UI_ALREADY_SAVED_SERVER_READBACK_REQUIRED');
check('missing aria state',{candidates:[btn(SID,{pressed:null})]},'UNRELIABLE_SAVE_STATE');
check('wrong origin',{host:'map.naver.com'},'WRONG_FRAME_ORIGIN');
check('invalid expected SID',{expectedSid:'NAVER'},'INVALID_EXPECTED_SID');
console.log('PASS: no clicks, secrets, raw page text, or server-write claims in preflight');
