const fs=require('fs'),vm=require('vm'),assert=require('assert'),path=require('path');
const candidates=[path.join(__dirname,'../02_R570_SOURCE/moa-r570-photo-favorites.js'),path.join(__dirname,'../assets/web/moa-r570-photo-favorites.js')];
const found=candidates.find(p=>fs.existsSync(p));assert(found,'R570 favorites source missing');
const src=fs.readFileSync(found,'utf8');
function boot(){
 const calls=[], requests=[]; let selected='12345',active=true, originalCount=0;
 const win={setTimeout:()=>0,
  __moaR570CurrentMediaId:()=>selected,
  MoaR469SimpleDiary:{readOnlyStatus:()=>({active,page:active?'day':'calendar'})},
  NativeHost:{post:(name,raw)=>requests.push({name,payload:JSON.parse(raw)})},
  FamilyJourneyNaver:{saveFromDiaryGps:(point,alias,memo,list,cb,opt)=>{calls.push({point,alias,memo,list,opt,cb});return true;}}
 };
 win.__fjDiaryMediaLocationResult=()=>{originalCount++};
 const doc={querySelector:()=>null};win.window=win;
 vm.runInNewContext(src,{window:win,document:doc,console});
 return {win,calls,requests,setSelected:x=>selected=x,setActive:x=>active=x,originalCount:()=>originalCount};
}
const good={id:'12345',lat:35.87950,lon:127.13530,hasGps:true};
{
 const e=boot();assert.equal(e.win.MoaR570PhotoFavorites.save('12345','별명','메모','테스트','web'),true);
 assert.equal(e.requests.length,1);assert.equal(e.requests[0].name,'diaryMediaLocation');
 e.win.__fjDiaryMediaLocationResult(e.requests[0].payload.request,good);
 assert.equal(e.calls.length,1);assert.equal(e.calls[0].opt.mode,'web');
 assert.equal(e.calls[0].point.id,'12345');assert.equal(e.calls[0].alias,'별명');
 assert.equal(e.calls[0].memo,'메모');assert.equal(e.calls[0].list,'테스트');
 e.calls[0].cb({state:'VERIFIED',message:'확인됨'});
 assert.equal(e.win.MoaR570PhotoFavorites.save('12345','','','','native'),true);
 e.win.__fjDiaryMediaLocationResult(e.requests[1].payload.request,good);
 assert.equal(e.calls[1].opt.mode,'native');
 e.win.__fjDiaryMediaLocationResult(12,{other:'original'});
 assert.equal(e.originalCount(),1);
}
{
 const e=boot();assert.equal(e.win.MoaR570PhotoFavorites.save('bad','x','','','web'),false);
 e.setActive(false);assert.equal(e.win.MoaR570PhotoFavorites.save('12345','','','','web'),false);
 assert.equal(e.requests.length,0);
}
{
 const e=boot();assert.equal(e.win.MoaR570PhotoFavorites.save('12345','','','','web'),true);
 assert.equal(e.win.MoaR570PhotoFavorites.save('12345','','','','web'),false,'duplicate suppressed');
 assert.equal(e.win.MoaR570PhotoFavorites.save('12345','','','','native'),false,'cross-mode duplicate suppressed');
 assert.equal(e.requests.length,1);
 e.setSelected('54321');e.win.__fjDiaryMediaLocationResult(e.requests[0].payload.request,good);
 assert.equal(e.calls.length,0,'stale selected media must not save');
}
{
 const e=boot();e.win.MoaR570PhotoFavorites.save('12345','','','','web');
 e.win.__fjDiaryMediaLocationResult(e.requests[0].payload.request,{id:'12345',lat:0,lon:0,hasGps:false});
 assert.equal(e.calls.length,0,'no GPS may never save');
}
{
 const e=boot();e.win.MoaR570PhotoFavorites.save('12345','','','','web');
 e.win.__fjDiaryMediaLocationResult(e.requests[0].payload.request,{...good,lon:200});
 assert.equal(e.calls.length,0,'invalid GPS may never save');
}
console.log('R570 first-party bridge: 6 contract scenarios PASS');