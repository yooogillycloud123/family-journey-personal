package com.juhyeon.familyjourney;

import android.accessibilityservice.AccessibilityService;
import android.content.SharedPreferences;
import android.graphics.Rect;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.accessibility.AccessibilityWindowInfo;
import java.util.List;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Locale;

/**
 * R18: One-shot, user-armed Android NAVER Maps save-sheet assistant.
 * Only com.nhn.android.nmap windows are observed. Passwords, authentication,
 * and all other packages are explicitly out of scope. No coordinate/photo upload.
 *
 * The accessibility tree varies across NAVER versions. Never pretend a tap
 * guarantees persistence; only report VERIFIED for a visible confirmation.
 */
public final class NaverSaveService extends AccessibilityService {
  static final String STORE="familyjourney_naver_oneshot";
  static final String NAVER="com.nhn.android.nmap";
  private String running="";
  private int stage=0; // 0 detail, 1 collapsed save sheet, 2 expanded editor, 3 list, 4 save, 5 verification
  private long lastAction=0L;
  // A successful programmatic click/text input may emit no new event.
  // Poll only while a user-authorized Naver job is armed.
  private final Handler scheduler=new Handler(Looper.getMainLooper());
  private boolean runningStep=false;
  private final Runnable pulse=new Runnable(){
    @Override public void run(){
      try{step();}catch(Exception e){Log.w("FJ_Naver","save pulse",e);}
      SharedPreferences pref=getSharedPreferences(STORE,MODE_PRIVATE);
      scheduler.postDelayed(this,pref.getBoolean("armed",false)?500:2400);
    }
  };
  @Override protected void onServiceConnected(){
    super.onServiceConnected();
    scheduler.removeCallbacks(pulse);
    scheduler.postDelayed(pulse,250);
  }
  @Override public void onDestroy(){
    scheduler.removeCallbacks(pulse);
    super.onDestroy();
  }

  private void state(SharedPreferences p,String status,boolean stop){
    if(status.equals(p.getString("state",""))&&!stop)return;
    SharedPreferences.Editor e=p.edit().putString("state",status);
    if(stop)e.putBoolean("armed",false);
    e.apply();
    Log.i("FJ_Naver","naver_save_stage="+status);
  }
  @Override public void onAccessibilityEvent(AccessibilityEvent event) {
    if(event!=null&&event.getPackageName()!=null&&
       NAVER.contentEquals(event.getPackageName()))step();
  }
  private synchronized void step() {
    if(runningStep)return;
    runningStep=true;
    try{processStep();}finally{runningStep=false;}
  }
  private void processStep() {
    SharedPreferences pref=getSharedPreferences(STORE,MODE_PRIVATE);
    if(!pref.getBoolean("armed",false))return;
    String job=pref.getString("job","");
    String address=pref.getString("expectedAddress","");
    if(job.length()<6||address.length()<8)return;
    if(System.currentTimeMillis()-pref.getLong("started",0)>180000){
      state(pref,"TIMEOUT",true);return;
    }
    if(!job.equals(running)){running=job;stage=0;lastAction=0;}
    if(System.currentTimeMillis()-lastAction<850)return;
    AccessibilityNodeInfo root=naverRoot();
    if(root==null)return;
    try{
      final String list=pref.getString("list","내 장소").trim();
      final String memo=trim(pref.getString("memo",""),50);
      final String alias=trim(pref.getString("alias",""),25);
      boolean sheet=isSaveSheet(root);
      boolean editor=isMemoEditor(root);
      if(stage==0){
        if(sheet){stage=1;state(pref,"SHEET_FOUND",false);return;}
        boolean detail=has(root,"출발")||has(root,"도착")||
          has(root,"길찾기")||has(root,"거리뷰")||has(root,"주소");
        // Never auto-pick the first search result. User opens the matching
        // detailed address, not any nearby business.
        if(!detail||!containsAddress(root,address)){
          state(pref,"WAITING_ADDRESS_RESULT",false);return;
        }
        AccessibilityNodeInfo save=find(root,"저장","저장하기","장소 저장","저장됨","즐겨찾기","즐겨찾기 추가");
        if(save==null)save=findBookmarkControl(root);
        if(save==null)save=findDetailHeaderStar(root,address);
        if(save==null){state(pref,"WAITING_SAVE_CONTROL",false);return;}
        if(click(save)){stage=1;action();state(pref,"SAVE_CONTROL_CLICKED",false);}
      }else if(stage==1){
        if(editor){stage=2;state(pref,"MEMO_EDITOR_OPENED",false);return;}
        if(!sheet){
          state(pref,"WAITING_SAVE_SHEET",false);return;
        }
        if(memo.isEmpty()&&alias.isEmpty()){stage=3;return;}
        AccessibilityNodeInfo opener=findContains(root,"메모, 별명, URL 추가",
          "메모·별명·URL 추가","메모,별명,URL 추가","메모, 별명, URL");
        if(opener==null)opener=find(root,"메모 추가","별명 추가","메모, 별명");
        if(opener==null){state(pref,"WAITING_MEMO_EXPAND",false);return;}
        if(click(opener)){stage=2;action();state(pref,"MEMO_EDITOR_OPENED",false);}
        else state(pref,"WAITING_MEMO_EXPAND",false);
      }else if(stage==2){
        if(!editor){
          if(sheet){state(pref,"WAITING_MEMO_EDITOR",false);return;}
          state(pref,"WAITING_SAVE_SHEET",false);return;
        }
        AccessibilityNodeInfo noteField=findMemoField(root,true);
        AccessibilityNodeInfo aliasField=findMemoField(root,false);
        if(noteField==null||aliasField==null||noteField.equals(aliasField)){
          state(pref,"FIELDS_NOT_ACCESSIBLE",false);return;
        }
        boolean noteOk=putIfDifferent(noteField,memo);
        boolean aliasOk=putIfDifferent(aliasField,alias);
        if(noteOk&&aliasOk){
          stage=3;action();
          state(pref,"MEMO_FIELDS_ENTERED_UNVERIFIED",false);
        }else state(pref,"MEMO_INPUT_RETRY",false);
      }else if(stage==3){
        if(!sheet){state(pref,"WAITING_SAVE_SHEET",false);return;}
        if(keyboardIsVisible()){
          // Screen recording: keyboard obscured the unchecked list/save CTA.
          // Dismiss only when an actual input method window is present.
          performGlobalAction(GLOBAL_ACTION_BACK);
          action();state(pref,"CLOSING_KEYBOARD",false);return;
        }
        AccessibilityNodeInfo row=findList(root,list);
        if(row==null){
          state(pref,"NEEDS_LIST_SELECTION",false);return;
        }
        if(isSelected(row)){
          stage=4;state(pref,"LIST_SELECTED",false);return;
        }
        // NAVER currently preselects "내 장소". Without check metadata do
        // not toggle a potentially selected list off. Non-default lists may
        // be explicitly selected once; check result before final save.
        if(click(row)){
          stage=4;action();state(pref,"LIST_CLICKED_UNVERIFIED",false);
        }else state(pref,"NEEDS_LIST_SELECTION",false);
      }else if(stage==4){
        if(!sheet){state(pref,"WAITING_SAVE_SHEET",false);return;}
        if(!memo.isEmpty()||!alias.isEmpty()){
          if(!editor || !enteredTextVisible(root,memo,alias)){
            // Do not commit a list-only save if memo/alias failed.
            state(pref,"MEMO_READBACK_FAILED",false);return;
          }
        }
        AccessibilityNodeInfo submit=findBottomSave(root);
        if(submit==null){state(pref,"SAVE_SUBMIT_NOT_FOUND",false);return;}
        if(!submit.isEnabled()){state(pref,"SAVE_DISABLED_CHECK_LIST",false);return;}
        if(click(submit)){
          stage=5;action();
          state(pref,"SAVE_CLICKED_UNVERIFIED",false);
        }
      }else if(stage==5){
        if(has(root,"저장 완료")||has(root,"저장되었습니다")||
            has(root,"저장했어요")||has(root,"저장되었어요")){
          state(pref,"VERIFIED",true);
        }else if(!sheet && (has(root,"저장됨")||has(root,"저장 해제"))){
          // Distinguish a known saved-place icon from actual memo persistence.
          state(pref,"PLACE_SAVED_MEMO_UNVERIFIED",true);
        }else state(pref,"WAITING_NAVER_SAVE_CONFIRM",false);
      }
    }catch(Exception e){
      Log.w("FJ_Naver","NAVER content changed during save",e);
      state(pref,"UI_CHANGED_CHECK_MANUALLY",false);
    }finally{root.recycle();}
  }
  private void action(){lastAction=System.currentTimeMillis();}
  private static String trim(String t,int max){
    String s=t==null?"":t.trim();return s.substring(0,Math.min(max,s.length()));
  }
  private static AccessibilityNodeInfo findBookmarkControl(AccessibilityNodeInfo root){
    ArrayDeque<AccessibilityNodeInfo> q=new ArrayDeque<>();q.add(root);int n=0;
    while(!q.isEmpty()&&n++<700){
      AccessibilityNodeInfo item=q.removeFirst();
      String id=item.getViewIdResourceName()==null?"":item.getViewIdResourceName().toLowerCase(Locale.ROOT);
      String desc=item.getContentDescription()==null?"":item.getContentDescription().toString().toLowerCase(Locale.ROOT);
      if((id.contains("bookmark")||id.contains("favorite")||id.contains("save_place")||
          desc.contains("즐겨찾기")||desc.contains("장소 저장"))&&item.isClickable())return item;
      for(int i=0;i<item.getChildCount();i++){
        AccessibilityNodeInfo child=item.getChild(i);if(child!=null)q.add(child);
      }
    }return null;
  }
  private static AccessibilityNodeInfo findDetailHeaderStar(AccessibilityNodeInfo root,String address){
    // Only inspect clickable nodes next to an exact on-screen address header,
    // never an arbitrary search result or first item.
    String[] parts=address.trim().split("\\s+");
    String streetNumber="",locality="";
    for(int i=parts.length-1;i>=0;i--)if(parts[i].matches(".*\\d.*")){
      streetNumber=compact(parts[i]);break;
    }
    for(String p:parts)if(p.endsWith("리")||p.endsWith("동")||p.endsWith("길"))
      locality=compact(p);
    if(streetNumber.isEmpty()||locality.isEmpty())return null;
    ArrayDeque<AccessibilityNodeInfo> queue=new ArrayDeque<>();queue.add(root);
    ArrayList<AccessibilityNodeInfo> buttons=new ArrayList<>();
    Rect heading=null;
    int seen=0;
    while(!queue.isEmpty()&&seen++<800){
      AccessibilityNodeInfo n=queue.removeFirst();
      if(n.getText()!=null){
        String value=compact(n.getText().toString());
        if(value.contains(streetNumber)&&value.contains(locality)){
          Rect r=new Rect();n.getBoundsInScreen(r);
          if(heading==null||r.top<heading.top)heading=r;
        }
      }
      if(n.isClickable())buttons.add(n);
      for(int j=0;j<n.getChildCount();j++){
        AccessibilityNodeInfo ch=n.getChild(j);if(ch!=null)queue.add(ch);
      }
    }
    if(heading==null)return null;
    Rect rootBox=new Rect();root.getBoundsInScreen(rootBox);
    for(AccessibilityNodeInfo n:buttons){
      Rect r=new Rect();n.getBoundsInScreen(r);
      if(r.width()>rootBox.width()*.18||r.height()>rootBox.height()*.12)continue;
      float relX=(float)(r.centerX()-rootBox.left)/Math.max(1,rootBox.width());
      if(relX<.72f||relX>.87f)continue;
      if(Math.abs(r.centerY()-heading.centerY())>130)continue;
      String desc=n.getContentDescription()==null?"":n.getContentDescription().toString();
      if(desc.contains("닫기")||desc.contains("공유"))continue;
      return n;
    }
    return null;
  }
  private static boolean isSaveSheet(AccessibilityNodeInfo root){
    return has(root,"새 리스트 만들기")&&
      (has(root,"메모, 별명, URL 추가")||
        contains(root,"메모, 별명, URL")||contains(root,"내 장소")||
        contains(root,"저장할 리스트"));
  }
  private static boolean isMemoEditor(AccessibilityNodeInfo root) {
    return contains(root,"메모를 남겨주세요")||
      contains(root,"지도 위에 표시될 별명")||
      contains(root,"관련 URL을 추가해주세요");
  }
  private AccessibilityNodeInfo naverRoot(){
    AccessibilityNodeInfo focused=getRootInActiveWindow();
    if(focused!=null&&focused.getPackageName()!=null&&
       NAVER.contentEquals(focused.getPackageName()))return focused;
    // While Samsung/Gboard keyboard is open, the active root may be the IME.
    // Read only the NAVER Maps window, still restricted to an armed job.
    try{
      List<AccessibilityWindowInfo> windows=getWindows();
      if(windows!=null)for(AccessibilityWindowInfo w:windows){
        if(w==null)continue;
        AccessibilityNodeInfo r=w.getRoot();
        if(r!=null&&r.getPackageName()!=null&&NAVER.contentEquals(r.getPackageName()))
          return r;
      }
    }catch(Exception e){Log.d("FJ_Naver","NAVER window not accessible");}
    return null;
  }
  private boolean keyboardIsVisible(){
    try{
      List<AccessibilityWindowInfo> windows=getWindows();
      if(windows!=null)for(AccessibilityWindowInfo window:windows)
        if(window!=null&&window.getType()==AccessibilityWindowInfo.TYPE_INPUT_METHOD)return true;
    }catch(Exception ignored){}
    return false;
  }
  private static AccessibilityNodeInfo findMemoField(AccessibilityNodeInfo root,boolean note){
    String[] keys=note?new String[]{"메모를 남겨주세요","메모"}:
      new String[]{"지도 위에 표시될 별명","별명을 남겨주세요","별명"};
    ArrayList<AccessibilityNodeInfo> editables=allEdits(root);
    for(AccessibilityNodeInfo field:editables){
      String hint=field.getHintText()==null?"":field.getHintText().toString();
      String text=field.getText()==null?"":field.getText().toString();
      String desc=field.getContentDescription()==null?"":field.getContentDescription().toString();
      for(String key:keys)if(hint.contains(key)||desc.contains(key)||
          text.contains(key))return field;
    }
    // Screenshot-proven three-field memo/alias/URL editor: order is memo,
    // nickname, URL. Only use the positional fallback in that precise dialog.
    if(isMemoEditor(root)&&editables.size()>=3){
      editables.sort((a,b)->{
        Rect aa=new Rect(),bb=new Rect();a.getBoundsInScreen(aa);b.getBoundsInScreen(bb);
        return Integer.compare(aa.top,bb.top);
      });
      return editables.get(note?0:1);
    }
    return null;
  }
  private static boolean putIfDifferent(AccessibilityNodeInfo edit,String value){
    String before=edit.getText()==null?"":edit.getText().toString();
    if(value.equals(before))return true;
    if(!edit.isEditable()||edit.isPassword())return false;
    Bundle arg=new Bundle();
    arg.putCharSequence(AccessibilityNodeInfo.ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE,value);
    return edit.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT,arg);
  }
  private static boolean enteredTextVisible(AccessibilityNodeInfo root,String memo,String alias){
    AccessibilityNodeInfo a=findMemoField(root,true),b=findMemoField(root,false);
    if(a==null||b==null)return false;
    String av=a.getText()==null?"":a.getText().toString();
    String bv=b.getText()==null?"":b.getText().toString();
    return (memo.isEmpty()||av.equals(memo))&&(alias.isEmpty()||bv.equals(alias));
  }
  private static ArrayList<AccessibilityNodeInfo> allEdits(AccessibilityNodeInfo root){
    ArrayList<AccessibilityNodeInfo> list=new ArrayList<>();
    ArrayDeque<AccessibilityNodeInfo> q=new ArrayDeque<>();q.add(root);int n=0;
    while(!q.isEmpty()&&n++<500){
      AccessibilityNodeInfo node=q.removeFirst();
      if(node.isEditable()&&!node.isPassword())list.add(node);
      for(int i=0;i<node.getChildCount();i++){
        AccessibilityNodeInfo ch=node.getChild(i);if(ch!=null)q.add(ch);
      }
    }
    return list;
  }
  private static AccessibilityNodeInfo findList(AccessibilityNodeInfo root,String name){
    ArrayDeque<AccessibilityNodeInfo> q=new ArrayDeque<>();q.add(root);int n=0;
    while(!q.isEmpty()&&n++<700){
      AccessibilityNodeInfo node=q.removeFirst();
      String label=node.getText()==null?"":node.getText().toString().trim();
      // A list is rendered as "내 장소 174" with a count. Never match
      // substring "내 장소" in unrelated address/search text.
      if(label.equals(name)||label.matches(java.util.regex.Pattern.quote(name)+"\\s+\\d+")){
        return node;
      }
      for(int i=0;i<node.getChildCount();i++){
        AccessibilityNodeInfo ch=node.getChild(i);if(ch!=null)q.add(ch);
      }
    }
    return null;
  }
  private static boolean isSelected(AccessibilityNodeInfo n){
    for(int i=0;i<4&&n!=null;i++,n=n.getParent()){
      if(n.isChecked()||n.isSelected())return true;
      CharSequence d=n.getContentDescription();
      if(d!=null&&(d.toString().contains("선택됨")||
        d.toString().contains("체크됨")))return true;
      for(int j=0;j<n.getChildCount();j++){
        AccessibilityNodeInfo child=n.getChild(j);
        if(child!=null&&child.isChecked())return true;
      }
    }return false;
  }
  private static AccessibilityNodeInfo findBottomSave(AccessibilityNodeInfo root){
    AccessibilityNodeInfo best=null;int bestY=-1;
    ArrayDeque<AccessibilityNodeInfo> q=new ArrayDeque<>();q.add(root);int n=0;
    while(!q.isEmpty()&&n++<700){
      AccessibilityNodeInfo node=q.removeFirst();
      String txt=node.getText()==null?"":node.getText().toString().trim();
      String desc=node.getContentDescription()==null?"":node.getContentDescription().toString().trim();
      if("저장".equals(txt)||"저장".equals(desc)){
        Rect box=new Rect();node.getBoundsInScreen(box);
        if(box.centerY()>bestY){best=node;bestY=box.centerY();}
      }
      for(int i=0;i<node.getChildCount();i++){
        AccessibilityNodeInfo child=node.getChild(i);if(child!=null)q.add(child);
      }
    }return best;
  }
  private static boolean click(AccessibilityNodeInfo n){
    for(int i=0;i<5&&n!=null;i++,n=n.getParent()){
      if(n.isClickable()&&n.performAction(AccessibilityNodeInfo.ACTION_CLICK))return true;
    }
    return false;
  }
  private static AccessibilityNodeInfo find(AccessibilityNodeInfo root,String... labels){
    ArrayDeque<AccessibilityNodeInfo> q=new ArrayDeque<>();q.add(root);int n=0;
    while(!q.isEmpty()&&n++<700){
      AccessibilityNodeInfo node=q.removeFirst();
      String txt=node.getText()==null?"":node.getText().toString().trim();
      String desc=node.getContentDescription()==null?"":node.getContentDescription().toString().trim();
      for(String label:labels)if(label.equals(txt)||label.equals(desc))return node;
      for(int i=0;i<node.getChildCount();i++){
        AccessibilityNodeInfo child=node.getChild(i);if(child!=null)q.add(child);
      }
    }return null;
  }
  private static AccessibilityNodeInfo findContains(AccessibilityNodeInfo root,String... labels){
    ArrayDeque<AccessibilityNodeInfo> q=new ArrayDeque<>();q.add(root);int n=0;
    while(!q.isEmpty()&&n++<700){
      AccessibilityNodeInfo node=q.removeFirst();
      String txt=node.getText()==null?"":node.getText().toString().trim();
      String desc=node.getContentDescription()==null?"":node.getContentDescription().toString().trim();
      for(String label:labels)if(txt.contains(label)||desc.contains(label))return node;
      for(int i=0;i<node.getChildCount();i++){
        AccessibilityNodeInfo child=node.getChild(i);if(child!=null)q.add(child);
      }
    }return null;
  }
  private static boolean contains(AccessibilityNodeInfo root,String needle){
    return findContains(root,needle)!=null;
  }
  private static boolean has(AccessibilityNodeInfo root,String needle){
    return find(root,needle)!=null;
  }
  private static String compact(String text){
    return text==null?"":text.replaceAll("\\s+","").toLowerCase(Locale.ROOT);
  }
  private static String allText(AccessibilityNodeInfo root){
    StringBuilder sb=new StringBuilder();
    ArrayDeque<AccessibilityNodeInfo> q=new ArrayDeque<>();q.add(root);int n=0;
    while(!q.isEmpty()&&n++<700){
      AccessibilityNodeInfo v=q.removeFirst();
      if(v.getText()!=null)sb.append(compact(v.getText().toString()));
      if(v.getContentDescription()!=null)sb.append(compact(v.getContentDescription().toString()));
      for(int i=0;i<v.getChildCount();i++){
        AccessibilityNodeInfo ch=v.getChild(i);if(ch!=null)q.add(ch);
      }
    }return sb.toString();
  }
  private static boolean containsAddress(AccessibilityNodeInfo root,String address){
    String[] chunks=address.trim().split("\\s+");
    String number="",local="";
    for(int i=chunks.length-1;i>=0;i--)if(chunks[i].matches(".*\\d.*")){
      number=compact(chunks[i]);break;
    }
    for(String token:chunks)if(token.endsWith("읍")||token.endsWith("면")||
      token.endsWith("동")||token.endsWith("리")||token.endsWith("길")||
      token.endsWith("로"))local=compact(token);
    String ui=allText(root);
    if(!number.isEmpty()&&!local.isEmpty())return ui.contains(number)&&ui.contains(local);
    return ui.contains(compact(address));
  }
  @Override public void onInterrupt(){}
}