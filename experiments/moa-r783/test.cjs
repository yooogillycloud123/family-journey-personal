const fs=require('fs'),vm=require('vm'),assert=require('assert');
const src=fs.readFileSync(process.argv[2],'utf8');
const helper=src.slice(src.indexOf('let registered783='),src.indexOf('function complete779(x)'));
assert(helper.includes('async function pumpScoped783'));
const fn=name=>src.split('\n').find(l=>l.startsWith('function '+name+'('));
const run=async()=>{
 let now=Date.now(), calls=[],persistCount=0,dbReads=0,rows=[];
 const context={console,Date,Map,Set,Number,Array,Object,String,Math,JSON,Error,
 prefs:{auto:true,autoPlace:false},pending:{},state:{lessons:{},connected:true,job:null},
 MAX_AUTO779:5,storageReady771:true,studyDB771:{},sessionBlocked781:false,sessionRetries779:0,
 retryable779:m=>/timeout|누락|중단/.test(m),validLesson:x=>!!x?.valid,complete779:x=>!!x?.complete,
 seed777:()=>null,missing781:()=>[],autoModel781:()=> 'sol',
 persist771:()=>{persistCount++;return true},schedule771:()=>{},autoStatus771:()=>{},sync:()=>{},
 mountAutoSettings783:()=>{},drain779:()=>{},restore777:()=>false,
 request:(op,body)=>calls.push({op,body}),command:()=>Promise.resolve(),finishJob:()=>{},write777:()=>true,
 window:{MoaStudyCurated783:async day=>{dbReads++;return rows.filter(r=>!day||r.day===day)}},
 document:{hidden:false,querySelector:()=>null,getElementById:()=>null},
 localStorage:{getItem:()=>null},confirm:()=>true};
 vm.createContext(context);
 vm.runInContext(helper+'\n'+fn('finishAuto771')+'\n'+fn('queue771')+'\nthis.api={normalize783,delay783,classify783,reconcile783,pumpScoped783,scan783,finishAuto771,wake783,progress783,tally783,queue771,reset:()=>{registered783=null;scanDirty783=true;scopeError783=""},scope:()=>registered783};',context);
 const a=context.api;
 const day='2026-11-27', momentAt=new Date(day+'T12:00:00').getTime();
 rows=[{day,selectionMode:'manual',photoIds:['1','2','v3','4','r731-device-1','2'],removedMediaIds:['4'],body:'diary note',moments:[{at:momentAt,photoIds:['5'],note:'moment note'}]},
 {day:'2026-11-26',selectionMode:'automatic',photoIds:['999']},
 {day:'2026-11-25',photoIds:['6'],updatedAt:1}];
 const keys=[...a.normalize783(rows).keys()].sort();
 assert.deepStrictEqual(keys,[day+'|1',day+'|2',day+'|5',day+'|v3','2026-11-25|6'].sort());
 assert(a.normalize783(rows).get(day+'|5').note.includes('moment note'));
 context.state.lessons[day+'|1']={valid:true,complete:true};
 context.state.lessons[day+'|2']={valid:true};
 context.pending[day+'|999']={day,id:'999',state:'pending'};
 context.pending[day+'|v3']={day,id:'v3',state:'failed',attempt:5,error:'timeout'};
 await a.scan783();
 assert(!context.pending[day+'|1']&&!context.pending[day+'|999']);
 assert(context.pending[day+'|v3'].nextAt>now+1700000);
 assert(context.pending[day+'|2']&&context.pending[day+'|5']);
 assert.equal(a.tally783().total,5);assert.equal(a.tally783().done,1);assert.equal(a.tally783().partial,1);
 await a.pumpScoped783();
 assert.equal(calls.length,1);assert.equal(calls[0].op,'generate');
 assert(keys.includes(calls[0].body.day+'|'+calls[0].body.media));
 assert.notEqual(calls[0].body.media,'1');
 // A stale in-memory scope cannot upload a removed source.
 const k=calls[0].body.day+'|'+calls[0].body.media;
 context.pending[k].state='pending';rows[0].removedMediaIds.push(calls[0].body.media);
 calls=[];await a.pumpScoped783();assert.equal(calls.length,0);assert(!context.pending[k]);
 // Auto off must not send or scan. Auth and quota never spin per media.
 context.prefs.auto=false;const oldReads=dbReads;await a.pumpScoped783();assert.equal(dbReads,oldReads);
 context.prefs.auto=true;
 const q={attempt:5};a.delay783(q,'transient',now);assert.equal(q.attempt,0);assert.equal(q.nextAt,now+1800000);
 a.delay783(q,'quota',now);assert.equal(q.nextAt,now+3600000);assert.equal(context.prefs.quotaUntil783,now+3600000);
 await a.pumpScoped783();assert.equal(calls.length,0);
 a.delay783(q,'auth',now);assert.equal(q.state,'blocked');a.delay783(q,'paused',now);assert.equal(q.state,'paused');
 assert.equal(a.classify783('HTTP 429'),'quota');assert.equal(a.classify783('HTTP 401'),'auth');
 // Failed canonical read is fail-closed, no gallery fallback.
 context.prefs.quotaUntil783=0;context.window.MoaStudyCurated783=async()=>{throw Error('read failed')};a.reset();
 await a.pumpScoped783();assert.equal(calls.length,0);
 // Large registration set uses bounded active queue and one persistent batch write.
 context.pending={};context.state.lessons={};rows=[{day,photoIds:Array.from({length:1000},(_,i)=>String(i+100)),selectionMode:'manual'}];
 context.window.MoaStudyCurated783=async()=>rows;a.reset();const before=persistCount;await a.scan783();
 assert.equal(Object.keys(context.pending).length,24);assert.equal(persistCount-before,1);assert.equal(a.tally783().total,1000);
 console.log('PASS curated-only, remote/gallery/excluded rejection, moment notes, complete protection, missing and partial enqueue, delayed retry, preflight removal, OFF, quota/auth/cancel, read failure, bounded 1000-item batch');
};
run().catch(e=>{console.error(e);process.exit(1)});
