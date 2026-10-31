package com.juhyeon.familyjourney;

import android.accessibilityservice.AccessibilityService;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import java.util.ArrayDeque;
import java.util.Locale;

/** User-armed, one-place NAVER Maps address-to-list assistant. No credentials or photos. */
public final class NaverSaveService extends AccessibilityService {
  static final String STORE="familyjourney_naver_oneshot";
  static final String NAVER="com.nhn.android.nmap";
  private String running="";
  private int stage=0;
  private long cooldown=0;
  private void state(SharedPreferences p,String value,boolean stop){
    SharedPreferences.Editor e=p.edit().putString("state",value);
    if(stop)e.putBoolean("armed",false);
    e.apply();
    Log.i("FJ_Naver","job_state="+value);
  }
  @Override public void onAccessibilityEvent(AccessibilityEvent event){
    if(event==null||event.getPackageName()==null||
       !NAVER.contentEquals(event.getPackageName()))return;
    SharedPreferences p=getSharedPreferences(STORE,MODE_PRIVATE);
    if(!p.getBoolean("armed",false))return;
    String job=p.getString("job","");
    String address=p.getString("expectedAddress","");
    if(job.length()<6||address.length()<8)return;
    if(System.currentTimeMillis()-p.getLong("started",0)>180000){
      state(p,"TIMEOUT",true);return;
    }
    if(!job.equals(running)){running=job;stage=0;cooldown=0;}
    if(System.currentTimeMillis()-cooldown<1100)return;
    AccessibilityNodeInfo root=getRootInActiveWindow();if(root==null)return;
    try{
      boolean detail=exact(root,"길찾기")||exact(root,"거리뷰")||
          exact(root,"출발")||exact(root,"도착")||exact(root,"전화")||exact(root,"주소");
      if(stage==0){
        // Never click the first search hit: owner must open its matching detail.
        if(!detail || !containsAddress(root,address)){
          state(p,"WAITING_ADDRESS_RESULT",false);return;
        }
        if(exact(root,"저장됨")||exact(root,"저장 해제")){
          stage=2;state(p,"ALREADY_SAVED_NOTE_PENDING",false);return;
        }
        AccessibilityNodeInfo save=find(root,"저장","저장하기","장소 저장");
        if(save==null){state(p,"WAITING_SAVE_CONTROL",false);return;}
        if(click(save)){
          stage=1;cooldown=System.currentTimeMillis();
          state(p,"SAVE_CONTROL_CLICKED",false);
        }
      }else if(stage==1){
        String list=p.getString("list","내 장소");
        AccessibilityNodeInfo dest=find(root,list);
        if(dest==null){
          if(exact(root,"저장됨")||exact(root,"저장 완료")){
            stage=2;state(p,"LIST_MAY_BE_SAVED",false);
          }else state(p,"WAITING_USER_LIST",false);
          return;
        }
        if(click(dest)){
          cooldown=System.currentTimeMillis();
          stage=2;state(p,"LIST_CLICKED_UNVERIFIED",false);
        }
      }else if(stage==2){
        AccessibilityNodeInfo done=find(root,"완료","저장","적용");
        if(done!=null && (exact(root,"저장할 리스트")||exact(root,"저장 리스트"))){
          if(click(done)){cooldown=System.currentTimeMillis();state(p,"COMMIT_CLICKED_UNVERIFIED",false);}
          return;
        }
        // On Naver, nickname / note are user-specific saved-place metadata.
        // Open that editor only by a clearly labeled memo/alias action.
        String note=p.getString("memo","").trim();
        String alias=p.getString("alias","").trim();
        if(!alias.isEmpty()){note=alias+(note.isEmpty()?"":" · "+note);}
        if(note.isEmpty()){
          if(exact(root,"저장됨")||exact(root,"저장 완료")){
            state(p,"VERIFIED",true);
          }else state(p,"WAITING_SAVED_CONFIRMATION",false);
          return;
        }
        AccessibilityNodeInfo memoButton=find(root,"메모","메모 추가","메모하기","메모 입력","저장 메모","별명");
        if(memoButton==null){state(p,"NEEDS_USER_MEMO_EDIT",false);return;}
        if(click(memoButton)){
          stage=3;cooldown=System.currentTimeMillis();
          state(p,"MEMO_EDITOR_OPENED",false);
        }
      }else if(stage==3){
        // Avoid entering a note into Naver search/login text boxes. Only edit
        // when the UI exposes a memo-specific caption next to an editable field.
        boolean editor=exact(root,"메모")||exact(root,"메모 입력")||
          exact(root,"저장 메모")||exact(root,"메모 추가")||exact(root,"별명");
        if(!editor){state(p,"NEEDS_USER_MEMO_EDIT",false);return;}
        AccessibilityNodeInfo input=findEdit(root);
        if(input==null){state(p,"NEEDS_USER_MEMO_EDIT",false);return;}
        String note=p.getString("memo","").trim();
        String alias=p.getString("alias","").trim();
        String combined=alias+(note.isEmpty()?"":" · "+note);
        if(combined.length()>350)combined=combined.substring(0,350);
        Bundle args=new Bundle();args.putCharSequence(
          AccessibilityNodeInfo.ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE,combined);
        if(input.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT,args)){
          stage=4;cooldown=System.currentTimeMillis();
          state(p,"MEMO_ENTERED_UNVERIFIED",false);
        }else state(p,"NEEDS_USER_MEMO_EDIT",false);
      }else if(stage==4){
        AccessibilityNodeInfo commit=find(root,"완료","저장");
        if(commit!=null && click(commit)){
          stage=5;cooldown=System.currentTimeMillis();
          state(p,"MEMO_COMMIT_UNVERIFIED",false);
        }
      }else if(stage==5){
        String note=p.getString("memo","").trim();
        String alias=p.getString("alias","").trim();
        if(!alias.isEmpty()&&visibleContains(root,alias)){
          state(p,"VERIFIED",true);
        }else if(alias.isEmpty()&&!note.isEmpty()&&visibleContains(root,note)){
          state(p,"VERIFIED",true);
        }else state(p,"NEEDS_USER_MEMO_VERIFY",false);
      }
    }catch(Exception ex){
      Log.w("FJ_Naver","Naver UI not recognized",ex);
      state(p,"UI_CHANGED_CHECK_MANUALLY",false);
    }finally{root.recycle();}
  }
  private static String normalize(String s){
    return s==null?"":s.replaceAll("\\s+","").toLowerCase(Locale.ROOT);
  }
  private static boolean containsAddress(AccessibilityNodeInfo root,String address){
    String key=normalize(address).replace("대한민국","")
      .replace("전라북도","전북").replace("전북특별자치도","전북");
    // Require a distinctive street/lot number PLUS at least one locality token.
    String[] tokens=address.trim().split("\\s+");
    String number="";
    for(int i=tokens.length-1;i>=0;i--)if(tokens[i].matches(".*\\d.*")){
      number=normalize(tokens[i]);break;
    }
    String locality="";
    for(String token:tokens)if(token.endsWith("읍")||token.endsWith("면")||
      token.endsWith("동")||token.endsWith("리")||token.endsWith("길")||
      token.endsWith("로"))locality=normalize(token);
    if(number.isEmpty()||locality.isEmpty())return visibleContains(root,address);
    String visible=allVisibleText(root);
    return visible.contains(number)&&visible.contains(locality);
  }
  private static String allVisibleText(AccessibilityNodeInfo root){
    StringBuilder sb=new StringBuilder();
    ArrayDeque<AccessibilityNodeInfo> q=new ArrayDeque<>();q.add(root);int n=0;
    while(!q.isEmpty()&&n++<800){
      AccessibilityNodeInfo v=q.removeFirst();
      if(v.getText()!=null)sb.append(normalize(v.getText().toString()));
      if(v.getContentDescription()!=null)sb.append(normalize(v.getContentDescription().toString()));
      for(int i=0;i<v.getChildCount();i++){AccessibilityNodeInfo c=v.getChild(i);if(c!=null)q.add(c);}
    }return sb.toString();
  }
  private static boolean visibleContains(AccessibilityNodeInfo root,String value){
    return !value.isEmpty()&&allVisibleText(root).contains(normalize(value));
  }
  private static boolean exact(AccessibilityNodeInfo root,String label){
    return find(root,label)!=null;
  }
  private static AccessibilityNodeInfo find(AccessibilityNodeInfo root,String... labels){
    ArrayDeque<AccessibilityNodeInfo> q=new ArrayDeque<>();q.add(root);int n=0;
    while(!q.isEmpty()&&n++<800){
      AccessibilityNodeInfo v=q.removeFirst();
      String text=v.getText()==null?"":v.getText().toString().trim();
      String desc=v.getContentDescription()==null?"":v.getContentDescription().toString().trim();
      for(String label:labels)if(label.equals(text)||label.equals(desc))return v;
      for(int i=0;i<v.getChildCount();i++){AccessibilityNodeInfo c=v.getChild(i);if(c!=null)q.add(c);}
    }return null;
  }
  private static AccessibilityNodeInfo findEdit(AccessibilityNodeInfo root){
    ArrayDeque<AccessibilityNodeInfo> q=new ArrayDeque<>();q.add(root);int n=0;
    while(!q.isEmpty()&&n++<500){
      AccessibilityNodeInfo v=q.removeFirst();
      String cls=String.valueOf(v.getClassName());
      if(v.isEditable()&&cls.contains("EditText")&&!v.isPassword())return v;
      for(int i=0;i<v.getChildCount();i++){AccessibilityNodeInfo c=v.getChild(i);if(c!=null)q.add(c);}
    }return null;
  }
  private static boolean click(AccessibilityNodeInfo v){
    for(int i=0;i<5&&v!=null;i++,v=v.getParent()){
      if(v.isClickable()&&v.performAction(AccessibilityNodeInfo.ACTION_CLICK))return true;
    }return false;
  }
  @Override public void onInterrupt(){}
}
