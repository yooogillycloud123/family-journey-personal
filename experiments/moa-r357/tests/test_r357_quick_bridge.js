const fs=require('fs'),vm=require('vm');
const js=fs.readFileSync('/mnt/data/moa_r357_work/moa-r357-quick-bridge.js','utf8');
const wait=t=>new Promise(r=>setTimeout(r,t));
async function test(label,draft,ackIds,gps=true,expected=1){
 const mem={},saves=[];
 const context={console,setTimeout,clearTimeout,setInterval,clearInterval,
  localStorage:{getItem:k=>mem[k]||null,setItem:(k,v)=>{mem[k]=String(v)}},
  CustomEvent:class{constructor(name,opts){this.name=name;this.detail=opts.detail}},
  document:{dispatchEvent:()=>{}},
  window:{
   __moaNativeAckByToken:{},
   __moaNativeSync:()=> 'ACCEPTED',
   FamilyJourneyDiary:{state:{photos:[{id:'999',lat:gps?35.8:null,lon:gps?127.1:null}],videos:[]}},
   FamilyJourneyNaver:{saveFromDiaryGps:(p,alias,memo,list,cb,opt)=>{
    saves.push({p,alias,memo,list,mode:opt.mode});cb({state:'WEB_SAVE_QUEUED_UNVERIFIED'});return true;
   }}
  }};
 context.window.window=context.window;
 vm.runInNewContext(js,context);
 const packet={token:'moar60_test_'+label.replace(/[^a-z0-9]/gi,''),drafts:[draft]};
 const first=context.window.__moaNativeSync(packet);if(first!=='ACCEPTED')throw Error(label+' wrong ACK');
 context.window.__moaNativeAckByToken[packet.token]={acked:ackIds,failed:[]};
 await wait(120);
 if(saves.length!==expected)throw Error(label+' requests '+saves.length+' != '+expected);
 if(expected && (saves[0].list!==(draft.naverQuickList||'내 장소')||saves[0].mode!=='web'||saves[0].memo!==(draft.note||draft.voiceAutoTranscript||''))) throw Error(label+' wrong job '+JSON.stringify(saves[0]));
 return label+' PASS';
}
(async()=>{
 for(const [name,d,ack,gps,n] of [
 ['checked',{id:'999',naverQuickFavorite:true,naverQuickRequestedAt:1234,naverQuickList:'가족',note:'음성 글'},['999'],true,1],
 ['unchecked',{id:'999',naverQuickFavorite:false,naverQuickRequestedAt:1234,naverQuickList:'가족',note:'글'},['999'],true,0],
 ['notCommitted',{id:'999',naverQuickFavorite:true,naverQuickRequestedAt:1234,note:'글'},[],true,0],
 ['noGPS',{id:'999',naverQuickFavorite:true,naverQuickRequestedAt:1234,note:'글'},['999'],false,0],
 ['defaultList',{id:'999',naverQuickFavorite:true,naverQuickRequestedAt:1234,note:'음성 글'},['999'],true,1]
 ])console.log(await test(name,d,ack,gps,n));
})().catch(e=>{console.error(e);process.exit(1)});
