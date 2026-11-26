package com.juhyeon.familyjournea;

import android.app.Activity;
import android.content.ContentProvider;
import android.content.ContentUris;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.database.MatrixCursor;
import android.media.MediaDataSource;
import android.net.Uri;
import android.os.Binder;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.ParcelFileDescriptor;
import android.os.Process;
import android.os.ProxyFileDescriptorCallback;
import android.os.storage.StorageManager;
import android.provider.MediaStore;
import android.system.ErrnoException;
import android.system.OsConstants;
import android.util.Base64;
import android.webkit.WebView;
import java.io.*;
import java.lang.reflect.*;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.*;
import java.util.concurrent.*;
import org.json.*;

/** Read-only remote timeline adapter. Existing R729 pinned TLS client and range source are reused.
 * Virtual IDs are transient UI handles, never written into local diary or MediaStore. */
public final class MoaRemoteTimeline731 {
    private static final String AUTH="com.juhyeon.familyjournea.moa_r717_peer";
    private static final String PREFIX="timeline731:";
    private static final String ROOT="com.juhyeon.familyjournea.MoaRemote721";
    private static final long ID_BASE=880000000000000000L, ID_LIMIT=890000000000000000L;
    private static final int MAX_LIST=2*1024*1024, MAX_THUMB=1024*1024;
    private static final ExecutorService WORK=Executors.newSingleThreadExecutor();
    private static volatile Object owner;
    private static volatile String activePin="";
    private static volatile Map<String,Row> active=Collections.emptyMap();
    private static final Map<String,Row> staged=new LinkedHashMap<>();
    private static volatile long generation=0;
    private static final Handler[] IO=new Handler[4];
    private static int nextLane=0;
    private static synchronized Handler ioHandler(){int i=nextLane++ & 3;if(IO[i]==null){HandlerThread t=new HandlerThread("MoaRemote735-read-"+i);t.start();IO[i]=new Handler(t.getLooper());}return IO[i];}
    private static final ExecutorService THUMBS=new ThreadPoolExecutor(2,2,20,TimeUnit.SECONDS,new ArrayBlockingQueue<Runnable>(24));
    private static final LinkedHashMap<String,Thumb> THUMB_CACHE=new LinkedHashMap<>(20,.75f,true);
    private static final class Thumb{final byte[] bytes;final long expires;Thumb(byte[] b){bytes=b;expires=android.os.SystemClock.elapsedRealtime()+15000;}}
    private static byte[] thumbBytes(Row r,JSONObject cfg)throws Exception{
        Object p=owner;String token=cfg.getString("token");String key=r.pin+":"+token+":"+r.original+":"+r.size+":"+r.t+":"+generation;
        if(!current(p,r,token))throw new IOException("Remote revoked");
        synchronized(THUMB_CACHE){Thumb t=THUMB_CACHE.get(key);if(t!=null&&t.expires>android.os.SystemClock.elapsedRealtime())return t.bytes;}
        byte[] b=bytes(client(cfg),"/v3/view/thumb/"+r.original,MAX_THUMB);
        if(!current(p,r,token))throw new IOException("Remote revoked");
        synchronized(THUMB_CACHE){THUMB_CACHE.put(key,new Thumb(b));while(THUMB_CACHE.size()>16){Iterator<String> it=THUMB_CACHE.keySet().iterator();it.next();it.remove();}}return b;
    }
    private static boolean current(Object p,Row r,String token){try{Field enabled=Class.forName(ROOT).getDeclaredField("clientAllowed");enabled.setAccessible(true);return timelineVisible&&enabled.getBoolean(null)&&owner==p&&allowed(p,r.pin)&&token.equals(config(p).optString("token"))&&stillSame(r);}catch(Exception e){return false;}}

    // Original-byte cache, isolated from MediaStore and from the local gallery.
    private static volatile boolean fullSelected=false,timelineVisible=true;
    private static MoaDiskCache737 disk;
    private static String diskPeer="";
    private static final ScheduledThreadPoolExecutor WARM=new ScheduledThreadPoolExecutor(1,r->{Thread t=new Thread(r,"MOA-warm737");t.setDaemon(true);return t;});
    private static final ScheduledExecutorService SWEEP=Executors.newSingleThreadScheduledExecutor(r->{Thread t=new Thread(r,"MOA-sweep737");t.setDaemon(true);return t;});
    static {WARM.setRemoveOnCancelPolicy(true);SWEEP.scheduleWithFixedDelay(()->{
        try{Object p=owner;JSONObject c=config(p);String k=c.optString("pin")+":"+c.optString("token");Field f=Class.forName(ROOT).getDeclaredField("clientAllowed");f.setAccessible(true);
            synchronized(MoaRemoteTimeline731.class){if(disk!=null){if(!timelineVisible||!f.getBoolean(null)||!allowed(p,c.optString("pin"))||!k.equals(diskPeer)){disk.reset();MoaTransport741.clear();diskPeer="";cancelWarm();}else disk.prune();}}
        }catch(Exception ex){synchronized(MoaRemoteTimeline731.class){if(disk!=null)disk.reset();MoaTransport741.clear();diskPeer="";cancelWarm();}}
    },15,15,TimeUnit.SECONDS);}
    private static final MoaAdaptive739 ADAPT=new MoaAdaptive739();
    
    private static volatile long warmEpoch;private static Future<?> warmJob;private static Object warmGallery;
    private static synchronized void cancelWarm(){warmEpoch++;if(warmJob!=null){warmJob.cancel(false);warmJob=null;}}
    private static synchronized MoaDiskCache737 disk(Context c,JSONObject cfg){
        try{String key=cfg.getString("pin")+":"+cfg.getString("token");if(disk==null)disk=new MoaDiskCache737(new File(c.getCacheDir(),"moa737-original-ranges"),MoaDiskCache737.LIMIT,MoaDiskCache737.TTL);if(!diskPeer.equals(key)){disk.reset();MoaTransport741.clear();ADAPT.reset();FEEDBACK.reset();diskPeer=key;}disk.resize(fullSelected?MoaAdaptive739.FULL:MoaAdaptive739.NORMAL);return disk;}catch(Exception ex){return null;}
    }
    private static String diskKey(Row r,long gen){return r.pin+":"+r.original+":"+r.size+":"+r.t+":"+r.day+":"+r.mime+":"+(r.revision>0?"rev"+r.revision:"gen"+gen);}
    private static final MoaFeedback741 FEEDBACK=new MoaFeedback741();
    private static android.media.MediaPlayer sampledPlayer;
    private static long lastSample;
    private static boolean pressure(){return FEEDBACK.pressure(android.os.SystemClock.elapsedRealtime());}
    // Native gallery calls this at its existing position update. No playback state or UI changes.
    public static void galleryMetrics(Object gallery){
        try{if(!timelineVisible||warmGallery!=gallery)return;long now=android.os.SystemClock.elapsedRealtime();if(now-lastSample<2000)return;lastSample=now;
            List<?> ids=(List<?>)field(gallery,"ids");int index=((Number)field(gallery,"index")).intValue();if(index<0||index>=ids.size())return;
            Row row=active.get(String.valueOf(ids.get(index)));if(row==null||!row.mime.startsWith("video/"))return;
            android.media.MediaPlayer player=(android.media.MediaPlayer)field(gallery,"media");if(player==null)return;
            if(sampledPlayer!=player){sampledPlayer=player;FEEDBACK.reset();}
            android.os.PersistableBundle m=player.getMetrics();if(m==null)return;
            FEEDBACK.sample(m.getInt(android.media.MediaPlayer.MetricsConstants.FRAMES,-1),m.getInt(android.media.MediaPlayer.MetricsConstants.FRAMES_DROPPED,-1),now);
        }catch(Exception ignored){}
    }
    private static MoaDiskCache737.Fetch raw(Row row,JSONObject cfg)throws Exception{
        Object p=owner;String token=cfg.getString("token");Object c=client(cfg);Method get=clientClass().getDeclaredMethod("get",String.class,int.class,long.class,long.class,long.class);get.setAccessible(true);
        MoaTransport741 transport=new MoaTransport741(row.size,(a,b,max)->{long start=System.nanoTime();try{byte[] data=(byte[])get.invoke(c,"/v3/view/raw/"+row.original,max,a,b,row.size);ADAPT.observe(data.length,System.nanoTime()-start);return data;}catch(Exception ex){ADAPT.failure();throw ex;}},()->current(p,row,token),()->!pressure()&&ADAPT.rateBytes()>=8*1048576L);
        return transport::read;
    }
    private static boolean warmOK(long ep,Object p,Row r,String token){return warmEpoch==ep&&current(p,r,token);}
    private static boolean warmBlock(MoaDiskCache737 store,Row r,long b,long ep,Object p,String token,long gen,MoaDiskCache737.Fetch fetch)throws Exception{
        if(b<0||b>(r.size-1)/MoaRangeCache735.BLOCK)return true;
        // Yield speculative transfers to current decoder demand; never queue more than one speculative range at a time.
        while(store.busy()){if(!warmOK(ep,p,r,token))return false;Thread.sleep(25);}
        if(!warmOK(ep,p,r,token))return false;
        long a=b*MoaRangeCache735.BLOCK,z=a+Math.min((long)MoaRangeCache735.BLOCK,r.size-a)-1;
        store.get(diskKey(r,gen),r.size,a,z,fetch,()->warmOK(ep,p,r,token),false);
        return warmOK(ep,p,r,token);
    }
    private static void warmRow(MoaDiskCache737 store,Row r,long ep,Object p,String token,long gen,MoaDiskCache737.Fetch fetch,int head,boolean full,boolean selected)throws Exception{
        long blocks=(r.size-1)/MoaRangeCache735.BLOCK+1;
        // First prepare head + tail (MP4 metadata can be at either end).
        for(long i=0;i<Math.min(head,blocks);i++)if(!warmBlock(store,r,i,ep,p,token,gen,fetch))return;
        if(blocks>head&&!warmBlock(store,r,blocks-1,ep,p,token,gen,fetch))return;
        if(full){long max=blocks<=ADAPT.fullLimit(selected,fullSelected)?blocks:Math.min(ADAPT.prefix(selected,r.size,r.duration),blocks);for(long i=head;i<max;i++)if(!warmBlock(store,r,i,ep,p,token,gen,fetch))return;}
    }
    // Motion hook only runs on a changed native index; settled selection retains the original gallery.
    public static void galleryFocus(Object gallery){focus(gallery,false);}
    public static void galleryMotion(Object gallery){focus(gallery,true);}
    private static void focus(Object gallery,boolean moving){
        try{List<?> ids=(List<?>)field(gallery,"ids");int i=((Number)field(gallery,"index")).intValue();if(i<0||i>=ids.size()||!timelineVisible)return;
            Activity a=(Activity)field(gallery,"activity");if(a==null)return;Context ctx=a.getApplicationContext();
            synchronized(MoaRemoteTimeline731.class){
                if(warmGallery!=gallery){FEEDBACK.reset();sampledPlayer=null;ADAPT.motion(i,android.os.SystemClock.elapsedRealtime());warmGallery=gallery;}
                else ADAPT.motion(i,android.os.SystemClock.elapsedRealtime());
                cancelWarm();final long ep=warmEpoch;String selectedId=String.valueOf(ids.get(i));
                List<Row> rows=new ArrayList<>();for(int j:ADAPT.order(i,ids.size(),moving)){Row r=active.get(String.valueOf(ids.get(j)));if(r!=null&&!r.mime.startsWith("audio/"))rows.add(r);}
                if(rows.isEmpty())return;
                warmJob=WARM.schedule(()->{try{Object p=owner;JSONObject cfg=config(p);String token=cfg.getString("token");long gen=generation;MoaDiskCache737 store=disk(ctx,cfg);if(store==null)return;
                    ArrayList<MoaDiskCache737.Fetch> fs=new ArrayList<>();for(Row r:rows)fs.add(raw(r,cfg));
                    for(int n=0;n<rows.size();n++){if(warmEpoch!=ep)return;Row r=rows.get(n);boolean selected=r.id.equals(selectedId);if(!selected&&pressure())continue;try{warmRow(store,r,ep,p,token,gen,fs.get(n),ADAPT.head(selected,r.size,r.duration),false,selected);}catch(Exception ignored){}}
                    if(!moving)for(int n=0;n<rows.size();n++){if(warmEpoch!=ep)return;Row r=rows.get(n);boolean selected=r.id.equals(selectedId);if((fullSelected||pressure())&&!selected)continue;try{warmRow(store,r,ep,p,token,gen,fs.get(n),ADAPT.head(selected,r.size,r.duration),true,selected);}catch(Exception ignored){}}
                }catch(Exception ignored){}},moving?120:250,TimeUnit.MILLISECONDS);
            }
        }catch(Exception ignored){}
    }
    public static synchronized void galleryClosed(Object gallery){cancelSelected(gallery);if(warmGallery==gallery){cancelWarm();warmGallery=null;sampledPlayer=null;FEEDBACK.reset();}}
    private static synchronized void setPolicy(String policy)throws IOException{
        if(!policy.equals("full")&&!policy.equals("adaptive")&&!policy.equals("off"))throw new IOException("Invalid cache policy");
        boolean visible=!policy.equals("off"),full=policy.equals("full");if(visible==timelineVisible&&full==fullSelected)return;timelineVisible=visible;fullSelected=full;cancelWarm();
        if(disk!=null){disk.resize(fullSelected?MoaAdaptive739.FULL:MoaAdaptive739.NORMAL);if(!timelineVisible)disk.reset();}
        if(!timelineVisible){MoaTransport741.clear();FEEDBACK.reset();sampledPlayer=null;active=Collections.emptyMap();synchronized(THUMB_CACHE){THUMB_CACHE.clear();}}
    }
    // Full photo decoding must never consume the server's small poster.
    private static final Semaphore PHOTO_SLOTS=new Semaphore(2,true);
    private static final long PHOTO_LIMIT=128L*1024*1024;
    private static android.graphics.Bitmap photoOriginal(Context ctx,Row row,int edge)throws Exception{
        if(!row.mime.startsWith("image/"))throw new IOException("Not a photo");
        Object p=owner;JSONObject cfg=config(p);String token=cfg.getString("token");
        if(!current(p,row,token))throw new IOException("Remote revoked");
        if(!PHOTO_SLOTS.tryAcquire(30,TimeUnit.SECONDS))throw new IOException("Photo decoder busy");
        File tmp=null;
        try{
            // Use a real seekable file, with the exact encoded original; no thumbnail or transcoding.
            if(row.size>PHOTO_LIMIT||ctx.getCacheDir().getUsableSpace()<row.size+64L*1024*1024){
                android.graphics.Bitmap b=android.graphics.ImageDecoder.decodeBitmap(android.graphics.ImageDecoder.createSource(ctx.getContentResolver(),uri(row.id)),(d,i,src)->photoHeader(d,i,edge));
                if(!current(p,row,token)){b.recycle();throw new IOException("Remote revoked");}return b;
            }
            File dir=new File(ctx.getCacheDir(),"moa743-photo-original");if(!dir.exists()&&!dir.mkdirs()&&!dir.isDirectory())throw new IOException("Photo cache unavailable");
            File[] leftovers=dir.listFiles();if(leftovers!=null)for(File old:leftovers)if(System.currentTimeMillis()-old.lastModified()>600000L)old.delete();
            tmp=File.createTempFile("original-", ".media",dir);
            try(MediaDataSource in=source(row,ctx);OutputStream out=new BufferedOutputStream(new FileOutputStream(tmp))){
                MoaOriginal743.copy(row.size,(off,buf,n)->in.readAt(off,buf,0,n),out,()->current(p,row,token));
            }
            if(tmp.length()!=row.size||!current(p,row,token))throw new IOException("Original size or permission changed");
            android.graphics.Bitmap b=android.graphics.ImageDecoder.decodeBitmap(android.graphics.ImageDecoder.createSource(tmp),(d,i,src)->photoHeader(d,i,edge));
            if(!current(p,row,token)){b.recycle();throw new IOException("Remote revoked");}return b;
        }finally{if(tmp!=null)tmp.delete();PHOTO_SLOTS.release();}
    }
    private static void photoHeader(android.graphics.ImageDecoder d,android.graphics.ImageDecoder.ImageInfo info,int edge){
        int w=info.getSize().getWidth(),h=info.getSize().getHeight(),max=Math.max(w,h);if(max>edge)d.setTargetSize(Math.max(1,(int)((long)w*edge/max)),Math.max(1,(int)((long)h*edge/max)));d.setAllocator(android.graphics.ImageDecoder.ALLOCATOR_SOFTWARE);
    }
    // Remote photos are promoted by a separate selected-page worker. Native page jobs
    // must never compete with it or turn a poster into a full-resolution cache entry.
    public static android.graphics.Bitmap galleryPhoto(Object gallery,String id){return null;}
    private static final ThreadPoolExecutor SELECT_PHOTO=new ThreadPoolExecutor(2,2,15,TimeUnit.SECONDS,new ArrayBlockingQueue<Runnable>(2),r->{Thread t=new Thread(r,"MOA-photo747");t.setDaemon(true);return t;},new ThreadPoolExecutor.AbortPolicy());
    static{SELECT_PHOTO.allowCoreThreadTimeOut(true);}
    private static final Map<Object,PhotoSelection> SELECTED=new WeakHashMap<>();
    private static final class PhotoSelection{
        final String id;final Row row;final Object peer;final String token;volatile boolean cancelled;Future<?> job;
        PhotoSelection(String id,Row r,Object p,String t){this.id=id;row=r;peer=p;token=t;}
        boolean allowed(){return !cancelled&&current(peer,row,token);}
    }
    private static String selectedId(Object gallery)throws Exception{
        if(!Boolean.TRUE.equals(field(gallery,"open")))return "";
        List<?> ids=(List<?>)field(gallery,"ids");int i=((Number)field(gallery,"index")).intValue();return i>=0&&i<ids.size()?String.valueOf(ids.get(i)):"";
    }
    private static android.widget.ImageView centerImage(Object gallery,String id)throws Exception{
        String[] pages=(String[])field(gallery,"loadedPageIds");
        android.widget.ImageView[] images=(android.widget.ImageView[])field(gallery,"images");
        return selectedId(gallery).equals(id)&&pages.length>1&&id.equals(pages[1])&&images.length>1?images[1]:null;
    }
    private static void photoStatus(Object gallery,String message){
        try{android.widget.FrameLayout[] pages=(android.widget.FrameLayout[])field(gallery,"pages");if(pages.length<2||pages[1]==null)return;
            android.widget.FrameLayout page=pages[1];android.view.View old=page.findViewWithTag("moa747-photo-status");if(old!=null)page.removeView(old);
            if(message==null)return;android.widget.TextView v=new android.widget.TextView(page.getContext());v.setTag("moa747-photo-status");v.setText(message);v.setTextColor(0xffffffff);v.setTextSize(12);v.setGravity(android.view.Gravity.CENTER);v.setPadding(12,6,12,6);v.setBackgroundColor(0xb0000000);v.setClickable(false);v.setFocusable(false);
            android.widget.FrameLayout.LayoutParams lp=new android.widget.FrameLayout.LayoutParams(-2,-2,android.view.Gravity.TOP|android.view.Gravity.CENTER_HORIZONTAL);lp.topMargin=8;page.addView(v,lp);
        }catch(Exception ignored){}
    }
    private static void cancelSelected(Object gallery){
        PhotoSelection old=SELECTED.remove(gallery);if(old!=null){old.cancelled=true;if(old.job!=null){old.job.cancel(false);if(old.job instanceof Runnable)SELECT_PHOTO.remove((Runnable)old.job);}}
        photoStatus(gallery,null);
    }
    private static android.graphics.Bitmap selectedOriginal(Context ctx,PhotoSelection sel,int edge)throws Exception{
        Row r=sel.row;if(!sel.allowed())throw new IOException("Remote revoked");
        // Direct pinned raw range path, separate from video proxy callbacks / poster endpoints.
        JSONObject cfg=config(sel.peer);Object c=client(cfg);Method get=clientClass().getDeclaredMethod("get",String.class,int.class,long.class,long.class,long.class);get.setAccessible(true);
        MoaTransport741 raw=new MoaTransport741(r.size,(a,b,max)->(byte[])get.invoke(c,"/v3/view/raw/"+r.original,max,a,b,r.size),sel::allowed,()->false);
        if(r.size>PHOTO_LIMIT||ctx.getCacheDir().getUsableSpace()<r.size+64L*1024*1024)return photoOriginal(ctx,r,edge);
        File dir=new File(ctx.getCacheDir(),"moa743-photo-original");if(!dir.isDirectory()&&!dir.mkdirs()&&!dir.isDirectory())throw new IOException("Photo cache unavailable");
        File tmp=File.createTempFile("selected-", ".media",dir);
        try{
            try(OutputStream out=new BufferedOutputStream(new FileOutputStream(tmp))){
                MoaOriginal743.copy(r.size,(off,buf,n)->{try{byte[] data=raw.read(off,off+n-1);System.arraycopy(data,0,buf,0,data.length);return data.length;}catch(IOException e){throw e;}catch(Exception e){throw new IOException("Original range",e);}},out,sel::allowed);
            }
            if(tmp.length()!=r.size||!sel.allowed())throw new IOException("Original length or permission changed");
            android.graphics.Bitmap decoded=android.graphics.ImageDecoder.decodeBitmap(android.graphics.ImageDecoder.createSource(tmp),(d,i,src)->{
                int w=i.getSize().getWidth(),h=i.getSize().getHeight();
                android.util.Log.i("MOA-Photo747","ORIGINAL_HEADER "+w+"x"+h+" bytes="+r.size);
                double scale=Math.min(1.0,Math.min((double)edge/Math.max(w,h),Math.sqrt(9000000.0/Math.max(1.0,(double)w*h))));
                if(scale<1)d.setTargetSize(Math.max(1,(int)(w*scale)),Math.max(1,(int)(h*scale)));
                d.setAllocator(android.graphics.ImageDecoder.ALLOCATOR_SOFTWARE);
            });
            if(!sel.allowed()){decoded.recycle();throw new IOException("Remote revoked");}
            android.util.Log.i("MOA-Photo747","ORIGINAL_DECODED "+decoded.getWidth()+"x"+decoded.getHeight());
            return decoded;
        }finally{tmp.delete();}
    }
    @SuppressWarnings("unchecked")
    public static void selectedPhoto(Object gallery){
        try{
            String id=selectedId(gallery);Row r=active.get(id);if(r==null||!r.mime.startsWith("image/")){cancelSelected(gallery);return;}
            Object p=owner;String token=config(p).getString("token");if(!current(p,r,token)){cancelSelected(gallery);return;}
            android.widget.ImageView image=centerImage(gallery,id);if(image==null)return;
            android.util.LruCache<String,android.graphics.Bitmap> full=(android.util.LruCache<String,android.graphics.Bitmap>)field(gallery,"full");
            android.graphics.Bitmap cached=full.get(id);
            if(cached!=null&&!cached.isRecycled()){image.setImageBitmap(cached);photoStatus(gallery,null);return;}
            PhotoSelection old=SELECTED.get(gallery);if(old!=null&&old.id.equals(id)&&old.allowed())return;
            cancelSelected(gallery);PhotoSelection sel=new PhotoSelection(id,r,p,token);SELECTED.put(gallery,sel);
            Activity activity=(Activity)field(gallery,"activity");Context ctx=activity.getApplicationContext();
            int edge=Math.max(2300,Math.min(4096,Math.max(activity.getResources().getDisplayMetrics().widthPixels,activity.getResources().getDisplayMetrics().heightPixels)));
            photoStatus(gallery,"원본 사진 불러오는 중…");
            sel.job=SELECT_PHOTO.submit(()->{
                android.graphics.Bitmap result=null;Exception failure=null;
                for(int i=0;i<2&&sel.allowed();i++){try{result=selectedOriginal(ctx,sel,edge);break;}catch(Exception e){failure=e;}}
                final android.graphics.Bitmap bitmap=result;final Exception error=failure;
                activity.runOnUiThread(()->{
                    try{android.widget.ImageView target=centerImage(gallery,id);
                        if(SELECTED.get(gallery)!=sel||!sel.allowed()||target==null||!target.isAttachedToWindow()){if(bitmap!=null)bitmap.recycle();return;}
                        if(bitmap==null){photoStatus(gallery,"원본 사진 읽기 실패 · 다른 사진 선택 후 다시 시도");android.util.Log.w("MOA-Photo747","ORIGINAL_FAILED "+diagnostic(error==null?new IOException("Unknown"):error));return;}
                        full.put(id,bitmap);target.setImageBitmap(bitmap);target.setContentDescription("원본 사진 "+bitmap.getWidth()+"×"+bitmap.getHeight());photoStatus(gallery,null);android.util.Log.i("MOA-Photo747","ORIGINAL_DISPLAYED "+bitmap.getWidth()+"x"+bitmap.getHeight());
                    }catch(Exception e){android.util.Log.w("MOA-Photo747","ORIGINAL_DISPLAY_FAILED "+e.getClass().getSimpleName());}
                });
            });
        }catch(Exception e){photoStatus(gallery,"원본 사진 준비 실패 · 다시 선택");android.util.Log.w("MOA-Photo747","SELECT_FAILED "+e.getClass().getSimpleName());}
    }
    private static byte[] webThumb(Row r,JSONObject cfg,int edge)throws Exception{
        if(edge<=320||r.mime.startsWith("video/")){byte[] data=thumbBytes(r,cfg);if(data.length<=128000)return data;android.graphics.Bitmap b=android.graphics.BitmapFactory.decodeByteArray(data,0,data.length);if(b==null)throw new IOException("Poster decode failed");try{ByteArrayOutputStream out=new ByteArrayOutputStream();b.compress(android.graphics.Bitmap.CompressFormat.JPEG,75,out);if(out.size()>128000)throw new IOException("Poster size limit");return out.toByteArray();}finally{b.recycle();}}
        Activity a=(Activity)field(owner,"active");if(a==null)throw new IOException("Gallery unavailable");
        android.graphics.Bitmap b=photoOriginal(a.getApplicationContext(),r,edge);
        try{ByteArrayOutputStream out=new ByteArrayOutputStream();for(int q:new int[]{90,82,72,60}){out.reset();b.compress(android.graphics.Bitmap.CompressFormat.JPEG,q,out);if(out.size()<=460000)return out.toByteArray();}throw new IOException("Preview size limit");}finally{b.recycle();}
    }
    // The cover metadata is derived only from the existing approved catalog; no new share rights.
    private static Map<String,Integer> hostCovers=Collections.emptyMap();
    private static final Map<String,Integer> coverStage=new HashMap<>();
    private static long coverEpoch=-1;private static int coverOffset=0;
    public static synchronized void captureCovers(JSONObject j){
        try{if("off".equals(j.optString("mode"))||!j.optBoolean("viewShare")){hostCovers=Collections.emptyMap();coverStage.clear();coverEpoch=-1;return;}
            JSONArray arr=j.optJSONArray("viewCatalog");if(arr==null)return;int off=j.optInt("viewOffset",-1),total=j.optInt("viewTotal",-1);long ep=j.optLong("viewEpoch",-1);
            if(ep<0||off<0||total<0||total>100000||arr.length()>1000||off+arr.length()>total)return;
            if(off==0){coverStage.clear();coverEpoch=ep;coverOffset=0;}if(coverEpoch!=ep||coverOffset!=off)return;
            for(int i=0;i<arr.length();i++){JSONObject x=arr.optJSONObject(i);if(x==null)continue;String id=x.optString("id"),day=x.optString("day");if(!id.matches("(?:v[0-9]{1,18}|[0-9]{1,19})")||!day.matches("[0-9]{4}-[0-9]{2}-[0-9]{2}"))continue;int flags=(x.optBoolean("coverCurated")?1:0)|(x.optBoolean("coverAutomatic")?2:0);if(flags!=0)coverStage.put(day+":"+id,flags);}
            coverOffset+=arr.length();if(coverOffset==total){hostCovers=Collections.unmodifiableMap(new HashMap<>(coverStage));coverStage.clear();coverEpoch=-1;}
        }catch(Exception ignored){}
    }
    private static synchronized void markCover(JSONObject j){try{int flags=hostCovers.getOrDefault(j.getString("day")+":"+j.getString("id"),0);if((flags&1)!=0)j.put("coverCurated",true);if((flags&2)!=0)j.put("coverAutomatic",true);}catch(Exception ignored){}}

    private static Object call(Object target,String name,Class<?>[] types,Object...args)throws Exception{Method m=target.getClass().getDeclaredMethod(name,types);m.setAccessible(true);return m.invoke(target,args);}
    private static Object field(Object target,String name)throws Exception{Field f=target.getClass().getDeclaredField(name);f.setAccessible(true);return f.get(target);}
    private static JSONObject config(Object p)throws Exception{Object provider=call(p,"provider",new Class<?>[0]);JSONObject cfg=(JSONObject)call(p,"current",new Class<?>[]{Object.class},provider);if(cfg==null||!cfg.optString("pin").matches("[a-f0-9]{64}"))throw new IOException("등록된 직접 연결 없음");return cfg;}
    private static boolean allowed(Object p,String pin){try{return p!=null&&!"off".equals(field(p,"mode"))&&pin.equals(config(p).optString("pin"));}catch(Exception e){return false;}}
    private static void finish(Object p,WebView w,int id,boolean ok,String result){w.post(()->{try{if(field(p,"view")==w)call(p,"js",new Class<?>[]{WebView.class,String.class},w,"window.MoaPeerControl?.done("+id+","+ok+","+JSONObject.quote(result)+")");}catch(Exception ignored){}});}
    private static Class<?> clientClass()throws Exception{return Class.forName(ROOT+"$Client");}
    private static Object client(JSONObject c)throws Exception{Constructor<?> k=clientClass().getDeclaredConstructor(JSONObject.class);k.setAccessible(true);return k.newInstance(c);}
    private static byte[] bytes(Object c,String path,int max)throws Exception{return (byte[])call(c,"get",new Class<?>[]{String.class,int.class,long.class,long.class,long.class},path,max,-1L,-1L,-1L);}
    private static MediaDataSource source(Row row,Context context)throws Exception{
        Object p=owner;JSONObject cfg=config(p);String token=cfg.getString("token");
        if(!current(p,row,token))throw new IOException("연결 중지");
        MoaDiskCache737.Fetch fetch=raw(row,cfg);MoaDiskCache737 store=disk(context,cfg);long gen=generation;
        MoaRangeCache735 buffered=new MoaRangeCache735(row.size,(a,b)->store==null?fetch.fetch(a,b):store.get(diskKey(row,gen),row.size,a,b,fetch,()->current(p,row,token),true),()->current(p,row,token),()->ADAPT.ahead(row.size,row.duration));
        return new MediaDataSource(){@Override public long getSize(){return buffered.size();}@Override public int readAt(long off,byte[] out,int start,int size)throws IOException{return buffered.read(off,out,start,size);}@Override public void close(){buffered.close();}};
    }
    private static final class Row{
        final String pin,original,id,day,name,mime;final long size,t,duration,revision;final boolean coverCurated,coverAutomatic;final Double lat,lon;
        Row(String pin,JSONObject j)throws Exception{this.pin=pin;original=j.getString("id");day=j.getString("day");name=j.optString("name","");mime=j.getString("mime");size=j.getLong("size");if(!day.matches("\\d{4}-\\d{2}-\\d{2}")||size<=0||size>Long.MAX_VALUE/2)throw new IOException("catalog record invalid");boolean audio=mime.startsWith("audio/");if(audio?!(original.matches("a:[0-9]{4}-[0-9]{2}-[0-9]{2}:[A-Za-z0-9_-]{8,90}\\.m4a")&&original.substring(2,12).equals(day)):!original.matches("(?:v[0-9]{1,18}|[0-9]{1,19})"))throw new IOException("catalog id invalid");if(!(mime.startsWith("image/")||mime.startsWith("video/")||audio))throw new IOException("catalog mime invalid");byte[] h=MessageDigest.getInstance("SHA-256").digest((pin+"\u0000"+original).getBytes(StandardCharsets.UTF_8));long x=0;for(int i=0;i<7;i++)x=(x<<8)|(h[i]&255);String v=Long.toString(ID_BASE+x%(ID_LIMIT-ID_BASE));id=audio?"a:"+v:mime.startsWith("video/")?"v"+v:v;t=j.optLong("t",0);duration=j.optLong("duration",0);revision=j.optLong("revision",0);coverCurated=j.optBoolean("coverCurated");coverAutomatic=j.optBoolean("coverAutomatic");lat=coord(j,"lat",90);lon=coord(j,"lon",180);}
        JSONObject json()throws Exception{return new JSONObject().put("id",id).put("day",day).put("name",name).put("mime",mime).put("size",size).put("t",t).put("duration",duration).put("revision",revision).put("coverCurated",coverCurated).put("coverAutomatic",coverAutomatic).put("lat",lat==null?JSONObject.NULL:lat).put("lon",lon==null?JSONObject.NULL:lon);}
    }
    private static Double coord(JSONObject j,String k,int bound){double v=j.optDouble(k,Double.NaN);return Double.isFinite(v)&&Math.abs(v)<=bound?v:null;}
    public static boolean virtual(String id){try{String s=id.startsWith("v")?id.substring(1):id.startsWith("a:")?id.substring(2):id;long n=Long.parseLong(s);return n>=ID_BASE&&n<ID_LIMIT;}catch(Exception e){return false;}}
    private static Row row(String id)throws FileNotFoundException{Row r=active.get(id);if(r==null||!allowed(owner,r.pin))throw new FileNotFoundException("Remote item unavailable");return r;}
    public static Uri uri(String id){if(!virtual(id))return null;return new Uri.Builder().scheme("content").authority(AUTH).appendPath("remote731").appendPath(id).build();}
    public static Uri withAppendedId(Uri local,long id){String s=Long.toString(id);if(!virtual(s))return ContentUris.withAppendedId(local,id);return uri(local.toString().contains("/video/")?"v"+s:s);}
    private static boolean stillSame(Row r){Row n=active.get(r.id);return n!=null&&r.pin.equals(n.pin)&&r.original.equals(n.original)&&r.size==n.size&&n.t==r.t&&n.day.equals(r.day)&&n.mime.equals(r.mime)&&n.revision==r.revision;}
    /** Called only for original R729 server-authorized items. */
    public static JSONObject augment(JSONObject j){markCover(j);try{String id=j.getString("id");if(id.startsWith("a:"))return j;Class<?> cl=Class.forName(ROOT);Field f=cl.getDeclaredField("ctx");f.setAccessible(true);Context c=(Context)f.get(null);Method m=cl.getDeclaredMethod("uri",String.class);m.setAccessible(true);Uri u=(Uri)m.invoke(null,id);if(c==null||u==null)return j;long t=0,d=0,rev=0;String[] cols=id.startsWith("v")?new String[]{"datetaken","date_added","date_modified","duration"}:new String[]{"datetaken","date_added","date_modified"};try(Cursor q=c.getContentResolver().query(u,cols,null,null,null)){if(q!=null&&q.moveToFirst()){t=q.getLong(0);if(t<=0)t=q.getLong(1)*1000;rev=q.getLong(2);if(cols.length==4)d=q.getLong(3);}}j.put("t",t).put("duration",d).put("revision",rev);double lat=Double.NaN,lon=Double.NaN;if(id.startsWith("v")){android.media.MediaMetadataRetriever mm=new android.media.MediaMetadataRetriever();try{mm.setDataSource(c,u);String loc=mm.extractMetadata(android.media.MediaMetadataRetriever.METADATA_KEY_LOCATION);if(loc!=null){java.util.regex.Matcher r=java.util.regex.Pattern.compile("^([+-]\\d+(?:\\.\\d+)?)([+-]\\d+(?:\\.\\d+)?)/*$").matcher(loc);if(r.matches()){lat=Double.parseDouble(r.group(1));lon=Double.parseDouble(r.group(2));}}}finally{mm.release();}}else{Uri orig=u;try{orig=MediaStore.setRequireOriginal(u);}catch(Exception ignored){}try(InputStream in=c.getContentResolver().openInputStream(orig)){if(in!=null){float[] ll=new float[2];android.media.ExifInterface ex=new android.media.ExifInterface(in);if(ex.getLatLong(ll)){lat=ll[0];lon=ll[1];}}}}if(Double.isFinite(lat)&&Double.isFinite(lon)&&Math.abs(lat)<=90&&Math.abs(lon)<=180&&(lat!=0||lon!=0))j.put("lat",lat).put("lon",lon);}catch(Exception ignored){}return j;}
    private static Row fromUri(Uri u)throws FileNotFoundException{if(!AUTH.equals(u.getAuthority())||u.getPathSegments().size()!=2||!"remote731".equals(u.getPathSegments().get(0)))throw new FileNotFoundException("Unknown remote URI");return row(u.getLastPathSegment());}
    public static boolean handle(Object p,WebView w,int id,String cmd){if(!cmd.startsWith(PREFIX))return false;ExecutorService exec=(cmd.startsWith(PREFIX+"thumb:")||cmd.startsWith(PREFIX+"thumbs:"))?THUMBS:WORK;try{exec.execute(()->{try{String op=cmd.substring(PREFIX.length());if(op.equals("policy:off")){setPolicy("off");finish(p,w,id,true,"원격 캐시 중지");return;}JSONObject cfg=config(p);String pin=cfg.getString("pin");if(!allowed(p,pin))throw new IOException("동기화 중지");owner=p;if(op.startsWith("policy:")){setPolicy(op.substring(7));finish(p,w,id,true,"원격 캐시 설정 적용");return;}if(op.startsWith("list:")){String[] parts=op.substring(5).split(":",2);int offset=Integer.parseInt(parts[0]);if(offset==0){if(parts.length==2)setPolicy(parts[1]);else if(!timelineVisible)setPolicy("adaptive");}if(offset<0||offset>100000)throw new IOException("목록 범위 오류");if(offset==0){staged.clear();generation++;synchronized(THUMB_CACHE){THUMB_CACHE.clear();}}else if(!pin.equals(activePin))throw new IOException("등록 기기 변경");activePin=pin;JSONObject data=new JSONObject(new String(bytes(client(cfg),"/v3/view/list?offset="+offset,MAX_LIST),StandardCharsets.UTF_8));JSONArray result=new JSONArray(),items=data.getJSONArray("items");for(int i=0;i<items.length();i++){Row r=new Row(pin,items.getJSONObject(i));Row prev=staged.put(r.id,r);if(prev!=null&&!prev.original.equals(r.original))throw new IOException("원격 ID 충돌");result.put(r.json());}int next=data.getInt("next");boolean more=data.getBoolean("more");if(more&&next<=offset)throw new IOException("목록 순서 오류");if(!allowed(p,pin))throw new IOException("동기화 중지");if(!more)active=Collections.unmodifiableMap(new LinkedHashMap<>(staged));finish(p,w,id,true,new JSONObject().put("items",result).put("next",next).put("more",more).put("generation",generation).toString());}else if(op.startsWith("thumbs:")){String[] args=op.substring(7).split(":",2);int edge=Integer.parseInt(args[0]);if(edge!=260&&edge!=640&&edge!=2048)throw new IOException("Thumbnail size");String[] ids=args[1].split(",");if(ids.length<1||ids.length>(edge>320?1:4))throw new IOException("Thumbnail batch limit");JSONObject result=new JSONObject();int total=0;for(String media:ids){try{Row r=row(media);if(r.mime.startsWith("audio/"))continue;byte[] b=webThumb(r,cfg,edge);if(edge<=320&&b.length>128000)continue;if(total+b.length>480000)continue;if(!current(p,r,cfg.getString("token")))throw new IOException("Remote revoked");result.put(media,"data:image/jpeg;base64,"+Base64.encodeToString(b,Base64.NO_WRAP));total+=b.length;}catch(Exception ignored){}}finish(p,w,id,true,result.toString());}else if(op.startsWith("thumb:")){Row r=row(op.substring(6));if(r.mime.startsWith("audio/"))throw new IOException("음성 썸네일 없음");byte[] b=thumbBytes(r,cfg);if(!allowed(p,pin))throw new IOException("동기화 중지");finish(p,w,id,true,"data:image/jpeg;base64,"+Base64.encodeToString(b,Base64.NO_WRAP));}else if(op.startsWith("voice:")){Row r=row(op.substring(6));if(!r.mime.startsWith("audio/"))throw new IOException("음성 ID 오류");Class<?> cl=Class.forName(ROOT);Method m=cl.getDeclaredMethod("player",Activity.class,clientClass(),String.class,long.class,boolean.class);m.setAccessible(true);Object c=client(cfg);Activity a=(Activity)field(p,"active");w.post(()->{try{if(!allowed(p,pin))throw new IOException("동기화 중지");m.invoke(null,a,c,r.original,r.size,false);finish(p,w,id,true,"원격 음성 재생");}catch(Exception e){finish(p,w,id,false,"원격 음성 열기 실패");}});}else throw new IOException("Unknown remote command");}catch(Exception e){finish(p,w,id,false,"원격 기록 조회 실패 · "+diagnostic(e));}});}catch(RejectedExecutionException ex){finish(p,w,id,false,"원격 썸네일 대기열 사용 중");}return true;}
    /** Only called after PackageInstaller.Session.commit has returned normally. No second close of the already closed openWrite stream. */
    public static void closeAfterCommit(java.io.InputStream in,android.content.pm.PackageInstaller.Session session){
        try{if(in!=null)in.close();}catch(Exception e){android.util.Log.w("MOA-Update","post-commit input cleanup",e);}
        try{if(session!=null)session.close();}catch(Exception e){android.util.Log.w("MOA-Update","post-commit session cleanup",e);}
    }
    private static String diagnostic(Throwable e){
        StringBuilder b=new StringBuilder();for(int i=0;e!=null&&i<4;i++,e=e.getCause()){
            if(i>0)b.append(" / ");b.append(e.getClass().getSimpleName());String m=e.getMessage();
            if(m==null)continue;
            if(m.equals("catalog id invalid"))b.append(" (원격 파일 ID 형식)");
            else if(m.equals("catalog record invalid"))b.append(" (날짜 또는 파일 크기)");
            else if(m.equals("catalog mime invalid"))b.append(" (미디어 종류)");
            else if(m.startsWith("허브 응답 HTTP ")&&m.matches("허브 응답 HTTP [0-9]{3}"))b.append(" (").append(m).append(")");
            else if(m.equals("등록된 직접 연결 없음")||m.equals("동기화 중지")||m.equals("등록 기기 변경")||m.equals("원격 ID 충돌")||m.equals("목록 순서 오류")||m.equals("목록 범위 오류"))b.append(" (").append(m).append(")");
            else if(m.equals("Sharing disabled")||m.equals("Response length")||m.equals("Incomplete response")||m.equals("Response limit")||m.equals("Pairing required")||m.equals("Private LAN only")||m.equals("Range mismatch"))b.append(" (").append(m).append(")");
        }return b.toString();
    }
    private static void sameUid(){if(Binder.getCallingUid()!=Process.myUid())throw new SecurityException("MOA private remote media");}
    public static ParcelFileDescriptor openFile(ContentProvider p,Uri u,String mode)throws FileNotFoundException{sameUid();if(!"r".equals(mode))throw new FileNotFoundException("Read only");try{Row r=fromUri(u);MediaDataSource s=source(r,p.getContext());StorageManager sm=p.getContext().getSystemService(StorageManager.class);if(sm==null){s.close();throw new IOException("Storage manager unavailable");}try{return sm.openProxyFileDescriptor(ParcelFileDescriptor.MODE_READ_ONLY,new ProxyFileDescriptorCallback(){@Override public long onGetSize()throws ErrnoException{check();return r.size;}private void check()throws ErrnoException{if(!allowed(owner,r.pin)||!stillSame(r))throw new ErrnoException("remote revoked",OsConstants.EACCES);}@Override public int onRead(long off,int size,byte[] out)throws ErrnoException{check();try{if(off>=r.size)return 0;int n=s.readAt(off,out,0,(int)Math.min(size,r.size-off));return Math.max(0,n);}catch(IOException ex){throw new ErrnoException("remote read",OsConstants.EIO);}}@Override public void onRelease(){try{s.close();}catch(IOException ignored){}}},ioHandler());}catch(Exception ex){s.close();throw ex;}}catch(Exception e){throw new FileNotFoundException("Remote media not accessible");}}
    public static AssetFileDescriptor typed(ContentProvider p,Uri u,String mime,android.os.Bundle opts)throws FileNotFoundException{sameUid();if(opts==null||!opts.containsKey(ContentResolverExtra.SIZE))return new AssetFileDescriptor(openFile(p,u,"r"),0,AssetFileDescriptor.UNKNOWN_LENGTH);try{Row r=fromUri(u);byte[] b=thumbBytes(r,config(owner));if(!allowed(owner,r.pin))throw new IOException("Remote revoked");ParcelFileDescriptor[] pipe=ParcelFileDescriptor.createPipe();new Thread(()->{try(OutputStream o=new ParcelFileDescriptor.AutoCloseOutputStream(pipe[1])){o.write(b);}catch(IOException ignored){}},"MoaRemote731-thumb").start();return new AssetFileDescriptor(pipe[0],0,b.length);}catch(Exception e){throw new FileNotFoundException("Thumbnail unavailable");}}
    private static class ContentResolverExtra {static final String SIZE="android.content.extra.SIZE";}
    public static String type(Uri u){sameUid();try{return fromUri(u).mime;}catch(Exception e){return null;}}
    public static Cursor query(Uri u,String[] cols){sameUid();try{Row r=fromUri(u);if(cols==null)cols=new String[]{"_id","_display_name","mime_type","_size","datetaken","duration"};MatrixCursor c=new MatrixCursor(cols,1);Object[] vals=new Object[cols.length];for(int i=0;i<cols.length;i++){switch(cols[i]){case "_id":vals[i]=Long.parseLong(r.id.replaceFirst("^(v|a:)",""));break;case "_display_name":case "title":vals[i]=r.name;break;case "mime_type":vals[i]=r.mime;break;case "_size":vals[i]=r.size;break;case "datetaken":vals[i]=r.t;break;case "date_added":case "date_modified":vals[i]=r.t/1000;break;case "duration":vals[i]=r.duration;break;case "latitude":vals[i]=r.lat;break;case "longitude":vals[i]=r.lon;break;default:vals[i]=null;}}c.addRow(vals);return c;}catch(Exception e){return null;}}
}
