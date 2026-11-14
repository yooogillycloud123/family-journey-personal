'use strict';
const fs=require('fs'),vm=require('vm'),path=require('path'),assert=require('assert');
const src=fs.readFileSync([path.join(__dirname,'../assets/web/moa-r570-photo-favorites.js'),path.join(__dirname,'../../moa-r570/apk_assets/web/moa-r570-photo-favorites.js')].find(p=>fs.existsSync(p)),'utf8');
function boot(){
 let now=0,tn=0,selected='12345',active=true,removed=0;
 const timers=new Map(), calls=[], posts=[],labels=[];
 const clock={
  setTimeout(fn,ms){const id=++tn;timers.set(id,{fn,due:now+ms});return id;},
  clearTimeout(id){timers.delete(id);},
  advance(ms){let until=now+ms,steps=0;while(steps++<100){const ar=[...timers].filter(([id,t])=>t.due<=until).sort((a,b)=>a[1].due-b[1].due);if(!ar.length)break;let [id,t]=ar[0];now=t.due;timers.delete(id);t.fn();}now=until;}
 };
 const chrome={labels,querySelector(sel){return this.labels.find(x=>!x.removed)||null;},append(v){labels.push(v)}};
 const document={querySelector(q){return q.includes('moa-r539-day-chrome')?chrome:null;},createElement(tag){return {
  attributes:{},removed:false,textContent:'',
  classList:{values:new Set(),remove(v){this.values.delete(v)},add(v){this.values.add(v)},contains(v){return this.values.has(v)}},
  setAttribute(k,v){this.attributes[k]=v;},remove(){this.removed=true;removed++}
 }}};
 const win={window:null,NativeHost:{post:(name,payload)=>posts.push({name,value:JSON.parse(payload)})},
  MoaR469SimpleDiary:{readOnlyStatus:()=>({active,page:active?'day':'calendar'})},
  __moaR570CurrentMediaId:()=>selected,
  FamilyJourneyNaver:{saveFromDiaryGps:(...args)=>{calls.push(args);return true;}},
  setTimeout:clock.setTimeout
 };
 win.window=win;win.__fjDiaryMediaLocationResult=()=>{};
 vm.runInNewContext(src,{window:win,document,console,setTimeout:clock.setTimeout,clearTimeout:clock.clearTimeout});
 return {win,clock,calls,posts,labels,removed:()=>removed,setSelected(v){selected=v},setActive(v){active=v}};
}
const gps={hasGps:true,id:'12345',lat:35.8795,lon:127.1353};
{
 const x=boot();assert(x.win.MoaR570PhotoFavorites.save('12345','별명','메모','내 장소','web'));
 assert(x.posts.length===1);assert(x.labels[0].textContent.includes('GPS'));
 x.clock.advance(3800);assert(x.labels[0].classList.contains('moa-r572-toast-leave'),'notice must start fade after 3.8sec');
 x.clock.advance(230);assert(x.labels[0].removed,'notice must be removed; no persistent white pill');
 x.win.__fjDiaryMediaLocationResult(x.posts[0].value.request,gps);assert(x.calls.length===1);
 x.calls[0][4]({state:'READBACK_UNAVAILABLE',message:'검토 필요'});
 x.clock.advance(4100);assert(x.labels.at(-1).removed,'readback message must also clear automatically');
}
{
 const x=boot();assert(x.win.MoaR570PhotoFavorites.save('12345','','','','web'));
 x.clock.advance(2500);x.win.__fjDiaryMediaLocationResult(x.posts[0].value.request,gps);
 x.calls[0][4]({state:'WEB_SAVE_QUEUED_UNVERIFIED',message:'대기 중'});
 assert(!x.labels[0].removed);
 x.clock.advance(1400);assert(!x.labels[0].removed,'new message resets old timer');
 x.clock.advance(2700);assert(x.labels[0].removed,'latest notice clears');
}
{
 const x=boot();assert(x.win.MoaR570PhotoFavorites.save('12345','','','','web'));
 assert(!x.win.MoaR570PhotoFavorites.save('12345','','','','native'));
 x.setSelected('54321');x.win.__fjDiaryMediaLocationResult(x.posts[0].value.request,gps);
 assert(x.calls.length===0,'stale photo must not be saved');
}
{
 const x=boot();assert(x.win.MoaR570PhotoFavorites.save('12345','','','','native'));
 x.win.__fjDiaryMediaLocationResult(x.posts[0].value.request,gps);
 assert(x.calls[0][5].mode==='native');
}
console.log('R572 photo-only notice lifecycle, first-party modes, GPS, stale selection: PASS');