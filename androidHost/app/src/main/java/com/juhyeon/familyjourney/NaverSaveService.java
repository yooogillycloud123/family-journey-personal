package com.juhyeon.familyjourney;

import android.accessibilityservice.AccessibilityService;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import android.content.SharedPreferences;
import android.util.Log;
import java.util.ArrayDeque;

/**
 * Opt-in one-location NAVER Maps save assistant. It only inspects Naver Maps.
 * It never reads passwords, clipboard, chat apps or other windows. A user must
 * select the exact search result and enable Accessibility manually. Selector
 * behavior requires validation against the installed NAVER Maps version.
 */
public final class NaverSaveService extends AccessibilityService {
  static final String STORE="familyjourney_naver_oneshot";
  static final String NAVER="com.nhn.android.nmap";
  private long lastAction=0L;
  private String currentJob="";
  private int stage=0;

  @Override protected void onServiceConnected(){
    super.onServiceConnected();
    Log.i("FJ_Naver","Explicit accessibility bridge active, package restricted to NAVER Maps");
  }

  private void result(SharedPreferences p,String status,boolean stop){
    SharedPreferences.Editor editor=p.edit().putString("state",status);
    if(stop)editor.putBoolean("armed",false);
    editor.apply();
    Log.i("FJ_Naver","One-shot job: "+status);
  }

  @Override public void onAccessibilityEvent(AccessibilityEvent event){
    if(event==null||event.getPackageName()==null||!NAVER.contentEquals(event.getPackageName()))return;
    SharedPreferences p=getSharedPreferences(STORE,MODE_PRIVATE);
    if(!p.getBoolean("armed",false))return;
    String job=p.getString("job","");
    String expected=p.getString("expectedPoi","").trim();
    if(job.length()<5||expected.length()<2)return;
    if(System.currentTimeMillis()-p.getLong("started",0)>180000){
      result(p,"TIMEOUT",true);return;
    }
    if(!job.equals(currentJob)){currentJob=job;stage=0;lastAction=0;}
    if(System.currentTimeMillis()-lastAction<1400)return;

    AccessibilityNodeInfo root=getRootInActiveWindow();
    if(root==null)return;
    try{
      // Never select an arbitrary search result. A human opens the correct POI.
      // Require the exact place name and a native detail-screen action.
      boolean nameVisible=exact(root,expected);
      boolean detail=exact(root,"길찾기") || exact(root,"전화") ||
          exact(root,"리뷰") || exact(root,"거리뷰");
      if(stage==0){
        if(!nameVisible || !detail){result(p,"WAITING_EXACT_PLACE",false);return;}
        if(exact(root,"저장됨")||exact(root,"저장 해제")){
          result(p,"ALREADY_SAVED",true);return;
        }
        AccessibilityNodeInfo save=find(root,new String[]{"저장","저장하기","☆ 저장","장소 저장"});
        if(save==null){result(p,"WAITING_SAVE_CONTROL",false);return;}
        if(click(save)){
          stage=1;lastAction=System.currentTimeMillis();result(p,"SAVE_CONTROL_CLICKED",false);
        }
      }else if(stage==1){
        String wanted=p.getString("list","").trim();
        if(wanted.isEmpty()){result(p,"WAITING_USER_LIST",false);return;}
        AccessibilityNodeInfo target=find(root,new String[]{wanted});
        if(target==null){
          if(exact(root,"저장됨")||exact(root,"저장 완료"))result(p,"VERIFIED",true);
          else result(p,"WAITING_LIST",false);
          return;
        }
        if(click(target)){
          stage=2;lastAction=System.currentTimeMillis();result(p,"LIST_CLICKED_UNVERIFIED",false);
        }
      }else if(stage==2){
        if(exact(root,"저장됨") || exact(root,"저장 완료") || exact(root,"저장되었어요")){
          result(p,"VERIFIED",true);return;
        }
        // Some versions require explicit confirmation after choosing list.
        AccessibilityNodeInfo commit=find(root,new String[]{"완료","적용"});
        if(commit!=null&&click(commit)){
          lastAction=System.currentTimeMillis();stage=3;result(p,"COMMIT_CLICKED_UNVERIFIED",false);
        }
      }else if(stage==3){
        if(exact(root,"저장됨")||exact(root,"저장 완료")||exact(root,"저장되었어요"))
          result(p,"VERIFIED",true);
      }
    }catch(Exception e){
      Log.w("FJ_Naver","NAVER screen semantics changed",e);
      result(p,"UI_CHANGED_CHECK_MANUALLY",false);
    }finally{root.recycle();}
  }

  private static boolean exact(AccessibilityNodeInfo root,String needle){
    if(needle==null||needle.isEmpty())return false;
    ArrayDeque<AccessibilityNodeInfo> q=new ArrayDeque<>();q.add(root);int visited=0;
    while(!q.isEmpty()&&visited++<450){
      AccessibilityNodeInfo item=q.removeFirst();
      CharSequence txt=item.getText(),description=item.getContentDescription();
      if((txt!=null&&needle.equalsIgnoreCase(txt.toString().trim()))||
          (description!=null&&needle.equalsIgnoreCase(description.toString().trim())))return true;
      for(int i=0;i<item.getChildCount();i++){AccessibilityNodeInfo ch=item.getChild(i);if(ch!=null)q.add(ch);}
    }return false;
  }
  private static AccessibilityNodeInfo find(AccessibilityNodeInfo root,String[] names){
    ArrayDeque<AccessibilityNodeInfo> q=new ArrayDeque<>();q.add(root);int visited=0;
    while(!q.isEmpty()&&visited++<450){
      AccessibilityNodeInfo item=q.removeFirst();
      CharSequence t=item.getText(),d=item.getContentDescription();
      String text=t==null?"":t.toString().trim(),desc=d==null?"":d.toString().trim();
      for(String n:names)if(n.equalsIgnoreCase(text)||n.equalsIgnoreCase(desc))return item;
      for(int i=0;i<item.getChildCount();i++){AccessibilityNodeInfo ch=item.getChild(i);if(ch!=null)q.add(ch);}
    }return null;
  }
  private static boolean click(AccessibilityNodeInfo node){
    AccessibilityNodeInfo p=node;
    for(int i=0;i<5 && p!=null;i++,p=p.getParent())
      if(p.isClickable()&&p.performAction(AccessibilityNodeInfo.ACTION_CLICK))return true;
    return false;
  }
  @Override public void onInterrupt(){}
}
