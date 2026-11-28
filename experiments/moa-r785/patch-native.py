#!/usr/bin/env python3
from pathlib import Path
import sys
p=Path(sys.argv[1])/'MoaInline755.java';s=p.read_text()
def rep(a,b,n=1):
 global s
 assert s.count(a)==n,(s.count(a),a[:120]);s=s.replace(a,b)
rep('private static final String JOB777="moa.study.job.v777";','''private static final String JOB777="moa.study.job.v777";
    private static final java.util.concurrent.atomic.AtomicBoolean AI785=new java.util.concurrent.atomic.AtomicBoolean();
    private static final android.os.Handler MAIN785=new android.os.Handler(android.os.Looper.getMainLooper());
    private boolean background785=false;
    private volatile String backgroundDay785="";
    private volatile boolean stopping785=false;
    static boolean aiBusy785(){return AI785.get();}
    static String backgroundDay785(WebView w){MoaInline755 c=INSTANCES.get(w);return c==null?"":c.backgroundDay785;}
    static void dispatchBackground785(WebView w,String encoded){
        String id="";
        MoaInline755 c=INSTANCES.get(w);
        if(c==null){c=new MoaInline755(w);c.background785=true;INSTANCES.put(w,c);}
        try{
            if(!trusted(w)||encoded.length()>65000||c.closed||!MoaStudyJob785.enabled(c.ctx))throw new SecurityException();
            JSONObject j=new JSONObject(new String(Base64.decode(encoded,Base64.URL_SAFE|Base64.NO_WRAP),StandardCharsets.UTF_8));
            id=j.optString("id");String op=j.optString("op");
            if("galleryStudyRefresh".equals(op))return;
            if(!Arrays.asList("session","generate","cancel","studyRecover777","studyAck777").contains(op))throw new SecurityException();
            if("generate".equals(op)&&(!j.optBoolean("auto")||j.optBoolean("remote")))throw new SecurityException();
            c.command(j);
        }catch(Exception e){c.emit(obj("type","error","id",id,"message","백그라운드 요청 실패 · "+e.getClass().getSimpleName()));}
    }
    static void closeBackground785(WebView w){
        MoaInline755 c=INSTANCES.remove(w);
        if(c==null)return;
        c.closed=true;c.stopping785=true;c.cancelled=true;
        HttpsURLConnection conn=c.activeConnection;if(conn!=null)conn.disconnect();
        c.worker.shutdown();
    }
    private String journalName785(){return background785?JOB777+".bg785":JOB777;}
''')
rep('ctx.getSharedPreferences(JOB777,0)','ctx.getSharedPreferences(journalName785(),0)',3)
rep('w.post(()->{if(trusted(w))w.evaluateJavascript("window.MoaInline755&&window.MoaInline755.event(JSON.parse("+data+"))",null);});','''Runnable deliver=()->{if(!closed&&trusted(w))w.evaluateJavascript("window.MoaInline755&&window.MoaInline755.event(JSON.parse("+data+"))",null);};
        if(background785)MAIN785.post(deliver);else w.post(deliver);''')
rep('if("studyRecover777".equals(op)){recover777(id);return;}','''if("bgConfig785".equals(op)&&!background785){MoaStudyJob785.configure(ctx,j);JSONObject st=MoaStudyJob785.status(ctx);st.put("type","bgStatus785");st.put("id",id);emit(st);return;}
        if("bgInvalidate785".equals(op)&&!background785){MoaStudyJob785.invalidate(ctx,j.optString("day"));return;}
        if("studyRecover777".equals(op)){recover777(id);return;}''')
rep('busy=true;job=id;cancelled=false;final boolean generation="generate".equals(op);','''if(!background785&&MoaStudyJob785.ownsWorker()){emit(obj("id",id,"type","error","message","백그라운드 자동 학습 진행 중 · 현재 작업 종료 후 다시 시도"));return;}
        if(closed||!AI785.compareAndSet(false,true)){emit(obj("id",id,"type","error","message","다른 AI 작업 진행 중"));return;}
        busy=true;job=id;cancelled=false;final boolean generation="generate".equals(op);
        if(background785&&generation)backgroundDay785=j.optString("day");''')
rep('String msg=cancelled?"요청 취소":e instanceof UserError?e.getMessage():"AI 처리 실패 · "+e.getClass().getSimpleName();','String msg=stopping785?"백그라운드 작업 중단 · 자동 재시도":cancelled?"요청 취소":e instanceof UserError?e.getMessage():"AI 처리 실패 · "+e.getClass().getSimpleName();')
rep('if(generation)ACTIVE777.remove(id);busy=false;','if(generation)ACTIVE777.remove(id);backgroundDay785="";busy=false;AI785.set(false);')
rep('journal777(id,"running",null,"시작");','try{journal777(id,"running",null,"시작");}catch(RuntimeException e){ACTIVE777.remove(id);busy=false;AI785.set(false);emit(obj("id",id,"type","error","message","학습 작업 저장 실패"));return;}')
# Persisted core/final results must not be acknowledged if native disk commit failed.
rep('ctx.getSharedPreferences(journalName785(),0).edit().putString("record",r.toString()).commit();}catch(Exception ignored){}}','''boolean saved=ctx.getSharedPreferences(journalName785(),0).edit().putString("record",r.toString()).commit();if(background785&&!saved)throw new IllegalStateException("study journal write failed");}catch(Exception e){if(background785)throw new IllegalStateException("study journal write failed",e);}}''')
# Existing authenticated native AI call and media extraction are reused. Cancel/disable gates
# immediately before each actual generation request; no auth/model/usage bypass.
rep('JSONObject body=obj("model",model,"instructions",instruction,"input",clean,"store",false,"stream",true);','if(background785&&(!MoaStudyJob785.enabled(ctx)||cancelled))throw new IOException("background disabled");JSONObject body=obj("model",model,"instructions",instruction,"input",clean,"store",false,"stream",true);')
rep('JSONObject body2=obj("model",model,"instructions",explore,"input",input2,"store",false,"stream",true);','if(background785&&(!MoaStudyJob785.enabled(ctx)||cancelled))throw new IOException("background disabled");JSONObject body2=obj("model",model,"instructions",explore,"input",input2,"store",false,"stream",true);')
# If a job is interrupted after durable core but before final save, existing recovery emits core.
p.write_text(s)
print('R785 native background ownership patch applied')
