// MOA R55 commit-ACK bridge: replace ONLY R54 appended compatibility wrapper.
// Preserve R54 Galaxy-proven camera overlay, native STT and R42 on-return fallback.
// SUCCESS only after actual IndexedDB transaction ack: ACCEPTED != COMMITTED.
// Never native.ack() while R54 native MediaStore observer lacks a seen tombstone.
(function(){
  let lastCommittedPayload='',inFlight=false,retryAfter=0;
  const RETRY_DELAY_MS=2000, ACK_TIMEOUT_MS=12000;
  function report(state,detail){
    window.__moaNativeSyncStatus={state,detail:String(detail||''),at:Date.now()};
  }
  function waitForCommit(token){
    return new Promise((resolve,reject)=>{
      const deadline=Date.now()+ACK_TIMEOUT_MS;
      function poll(){
        const item=window.__moaNativeAckByToken&&window.__moaNativeAckByToken[token];
        if(item){resolve(item);return}
        if(Date.now()>=deadline){reject(new Error('NO_COMMIT_ACK'));return}
        setTimeout(poll,200);
      }
      poll();
    });
  }
  async function readNative(){
    if(inFlight||Date.now()<retryAfter)return;
    try{
      const native=window.MoaMomentNative;
      if(!native||typeof native.drafts!=='function'||typeof window.__moaNativeSync!=='function'){
        report('WAIT_NATIVE_BRIDGE','native.drafts or IDB consumer not ready');return;
      }
      const drafts=JSON.parse(native.drafts()||'[]');
      if(!Array.isArray(drafts)){report('INVALID_NATIVE_DRAFTS','not an array');return}
      const ready=drafts.filter(x=>x&&(x.memoSaved===true||String(x.note||'').trim().length>0)).slice(0,80);
      if(!ready.length){report('NO_SAVED_MEMO','native drafts may still be awaiting user input');return}
      const key=JSON.stringify(ready.map(x=>[x.id,x.at,String(x.note||''),x.memoSaved===true]));
      if(key===lastCommittedPayload)return;
      inFlight=true;
      const token='moar55_'+Date.now().toString(36)+'_'+Math.random().toString(36).slice(2,11);
      report('PENDING_COMMIT',ready.length+' drafts');
      const received=window.__moaNativeSync({token,drafts:ready});
      if(received!=='ACCEPTED')throw new Error('IDB_CONSUMER_REJECTED '+received);
      const ack=await waitForCommit(token);
      const acknowledged=new Set(Array.isArray(ack.acked)?ack.acked.map(String):[]);
      const failed=Array.isArray(ack.failed)?ack.failed:[];
      if(failed.length===0&&ready.every(x=>acknowledged.has(String(x.id)))){
        lastCommittedPayload=key; // ONLY after the IndexedDB transaction completes.
        report('COMMITTED',acknowledged.size+' records in diary');
      }else{
        retryAfter=Date.now()+RETRY_DELAY_MS;
        report('RETRY_PENDING',JSON.stringify(failed).slice(0,400));
      }
    }catch(e){
      retryAfter=Date.now()+RETRY_DELAY_MS;
      report('RETRY_PENDING',String(e).slice(0,300));
    }finally{inFlight=false}
  }
  window.__moaR54RefreshNative=readNative;
  document.addEventListener('visibilitychange',()=>{if(!document.hidden)setTimeout(readNative,350)});
  window.addEventListener('focus',()=>setTimeout(readNative,350));
  window.addEventListener('pageshow',()=>setTimeout(readNative,400));
  setInterval(readNative,5000);
  setTimeout(readNative,600);
})();
