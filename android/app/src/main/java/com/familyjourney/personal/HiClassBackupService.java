package com.familyjourney.personal;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/** Permission-gated, local-only UI automation. Never reads another app's private files.
 *  Uses the already authenticated HiClass app; does not bypass any login.
 *  A tap is NOT evidence of a completed download. */
public final class HiClassBackupService extends AccessibilityService {
  private static final String TARGET = "com.iscreammedia.app.hiclass.android";
  private final Handler handler = new Handler(Looper.getMainLooper());
  private WindowManager wm; private View overlay; private TextView status;
  private boolean active = false, targetVisible = false, busy = false;
  private int phase = 0, attempts = 0, noProgress = 0, scrolls = 0;
  private final Set<String> visited = new HashSet<>();
  private String pendingKey = "";
  private final String[] saveWords = {"전체 저장", "모두 저장", "전체 다운로드", "묶음 사진 전체 저장", "모든 사진 저장", "사진 전체 저장"};
  private final String[] menuWords = {"더보기", "메뉴", "옵션"};
  private final String[] confirmWords = {"확인", "저장", "다운로드"};
  @Override public void onServiceConnected() {
    super.onServiceConnected();
    AccessibilityServiceInfo i = getServiceInfo();
    if (i != null) {
      i.packageNames = new String[]{TARGET};
      i.eventTypes = AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED | AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED | AccessibilityEvent.TYPE_NOTIFICATION_STATE_CHANGED;
      i.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC;
      i.flags |= AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS | AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS;
      i.notificationTimeout = 250;
      setServiceInfo(i);
    }
    wm = (WindowManager)getSystemService(Context.WINDOW_SERVICE);
    readHistory();
  }
  @Override public void onAccessibilityEvent(AccessibilityEvent event) {
    if(event == null) return;
    targetVisible = TARGET.equals(String.valueOf(event.getPackageName()));
    if(targetVisible) { ensureOverlay(); if(active && !busy) schedule(600); }
    else { removeOverlay(); if(active) {active=false; busy=false; phase=0;} }
  }
  @Override public void onInterrupt() { pause("서비스 중단"); }
  @Override public void onDestroy() { pause("종료"); removeOverlay(); handler.removeCallbacksAndMessages(null); super.onDestroy(); }
  private void ensureOverlay() {
    if(overlay != null || wm == null) return;
    LinearLayout row = new LinearLayout(this);
    row.setOrientation(LinearLayout.HORIZONTAL);
    row.setPadding(10,8,10,8);
    row.setBackgroundColor(0xee24313f);
    status = new TextView(this); status.setTextColor(0xffffffff); status.setTextSize(12);
    status.setText("모아 · 하이클래스 자동화 시험 (로그인 후 앨범 목록에서 시작)");
    row.addView(status,new LinearLayout.LayoutParams(0,-2,1));
    Button toggle = new Button(this);toggle.setText("시작");row.addView(toggle);
    Button stop = new Button(this);stop.setText("중단");row.addView(stop);
    toggle.setOnClickListener(v->{
      if(active) {pause("일시정지");toggle.setText("시작");}
      else {active=true;phase=0;noProgress=0;scrolls=0;toggle.setText("일시정지"); show("탐색 중 (사진 게시글 목록을 먼저 열어주세요)"); schedule(250);}
    });
    stop.setOnClickListener(v->{pause("사용자 중단");toggle.setText("시작");});
    WindowManager.LayoutParams lp = new WindowManager.LayoutParams(
       -1,-2,WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
       WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
       PixelFormat.TRANSLUCENT);
    lp.gravity = Gravity.TOP;lp.y=45;
    try{wm.addView(row,lp);overlay=row;}catch(Exception e){overlay=null;}
  }
  private void removeOverlay() {if(overlay!=null && wm!=null)try{wm.removeView(overlay);}catch(Exception ignored){} overlay=null;status=null;}
  private void pause(String msg){active=false;busy=false;phase=0;show(msg);}
  private void show(String msg){if(status!=null)status.setText("모아 · "+msg+" / 시도 "+attempts+"건");}
  private void schedule(long ms) {handler.postDelayed(this::step,ms);}
  private void step() {
    if(!active || busy || !targetVisible) return;
    AccessibilityNodeInfo root = getRootInActiveWindow();
    if(root == null) {schedule(900);return;}
    busy=true;
    try {
      if(!TARGET.equals(root.getPackageName()==null?"":root.getPackageName().toString())) {busy=false;return;}
      if(phase==1){ // after entering a candidate post
        AccessibilityNodeInfo all = find(root, saveWords);
        if(all != null && click(all)){phase=3;attempts++;show("전체 저장 버튼 실행 · 실제 저장 확인 필요");busy=false;schedule(1800);return;}
        AccessibilityNodeInfo menu = find(root,menuWords);
        if(menu!=null && click(menu)){phase=2;busy=false;schedule(700);return;}
        phase=4;show("저장 버튼을 찾지 못해 다음 게시글 탐색");
      }
      if(phase==2){
        AccessibilityNodeInfo all=find(root,saveWords);
        if(all!=null && click(all)){phase=3;attempts++;show("전체 저장 버튼 실행 · 실제 저장 확인 필요");busy=false;schedule(1800);return;}
        phase=4;
      }
      if(phase==3){ // optional Android confirmation dialog; do not assume success
        AccessibilityNodeInfo confirm=find(root,confirmWords);
        if(confirm!=null && isDialog(root) && click(confirm)){busy=false;schedule(800);return;}
        phase=4;
      }
      if(phase==4){
        String key=pendingKey;
        if(!TextUtils.isEmpty(key)){visited.add(key);persistHistory();}
        pendingKey="";
        performGlobalAction(GLOBAL_ACTION_BACK);
        phase=0;busy=false;schedule(900);return;
      }
      // The user must begin in the album feed, never in arbitrary messages.
      List<AccessibilityNodeInfo> candidates=new ArrayList<>();
      collectCards(root,candidates,0);
      for(AccessibilityNodeInfo card:candidates){
        String key=signature(card);
        if(visited.contains(key))continue;
        visited.add(key);persistHistory();
        if(click(card)){pendingKey=key;phase=1;noProgress=0;busy=false;show("게시글 열기");schedule(1100);return;}
      }
      AccessibilityNodeInfo scroll=findScrollable(root,0);
      if(scroll != null && scroll.performAction(AccessibilityNodeInfo.ACTION_SCROLL_FORWARD)) {
        scrolls++;noProgress++;
        if(noProgress>=12){pause("새 게시글 없음 또는 탐색 불가 · 직접 확인 필요");}
        else {show("다음 게시글 탐색");busy=false;schedule(1100);}
        return;
      }
      pause("더 이상 탐색할 게시글 없음 · 결과 확인 필요");
    } catch(Throwable t){pause("화면 변경 / 자동화 중단");}
    finally {busy=false;try{root.recycle();}catch(Exception ignored){}}
  }
  private AccessibilityNodeInfo find(AccessibilityNodeInfo root,String[] words){
    List<AccessibilityNodeInfo> q=new ArrayList<>();q.add(root);
    for(int p=0;p<q.size() && p<350;p++){
      AccessibilityNodeInfo n=q.get(p);
      String t=(n.getText()==null?"":n.getText().toString())+" "+(n.getContentDescription()==null?"":n.getContentDescription().toString());
      for(String w:words)if(t.contains(w))return n;
      for(int j=0;j<n.getChildCount();j++){AccessibilityNodeInfo c=n.getChild(j);if(c!=null)q.add(c);}
    }return null;
  }
  private boolean click(AccessibilityNodeInfo n){
    for(int j=0;j<6 && n!=null;j++,n=n.getParent())
      if(n.isClickable() && n.isEnabled())return n.performAction(AccessibilityNodeInfo.ACTION_CLICK);
    return false;
  }
  private void collectCards(AccessibilityNodeInfo n,List<AccessibilityNodeInfo> cards,int depth){
    if(n==null||depth>17||cards.size()>180)return;
    String title=n.getText()==null?"":n.getText().toString();
    String desc=n.getContentDescription()==null?"":n.getContentDescription().toString();
    String s=title+" "+desc;
    // Exclude dangerous navigation/chat actions. Never send a message, delete, or post.
    boolean danger=s.contains("보내기")||s.contains("삭제")||s.contains("작성")||s.contains("댓글")||s.contains("알림");
    boolean photo=s.contains("사진")||s.contains("앨범")||s.contains("동영상")||s.contains("이미지");
    if(photo&&!danger&&n.isClickable()&&s.length()<160)cards.add(n);
    for(int j=0;j<n.getChildCount();j++) collectCards(n.getChild(j),cards,depth+1);
  }
  private AccessibilityNodeInfo findScrollable(AccessibilityNodeInfo n,int depth){
    if(n==null||depth>18)return null;
    for(int j=0;j<n.getChildCount();j++){
      AccessibilityNodeInfo r=findScrollable(n.getChild(j),depth+1);if(r!=null)return r;
    }
    return n.isScrollable()?n:null;
  }
  private String signature(AccessibilityNodeInfo n){
    String t=(n.getText()==null?"":n.getText().toString())+" "+(n.getContentDescription()==null?"":n.getContentDescription().toString());
    Rect r=new Rect();n.getBoundsInScreen(r);
    String data=t+"|"+n.getViewIdResourceName()+"|"+r.width()+"x"+r.height();
    try {byte[] d=MessageDigest.getInstance("SHA-256").digest(data.getBytes("UTF-8"));StringBuilder b=new StringBuilder();for(byte v:d)b.append(String.format("%02x",v));return b.toString();}
    catch(Exception e){return data;}
  }
  private boolean isDialog(AccessibilityNodeInfo n){
    return n.getClassName()!=null&&n.getClassName().toString().contains("Dialog");
  }
  private SharedPreferences prefs(){return getSharedPreferences("hiclass_auto_v1",MODE_PRIVATE);}
  private void readHistory(){visited.clear();visited.addAll(prefs().getStringSet("attempted",new HashSet<>()));}
  private void persistHistory(){prefs().edit().putStringSet("attempted",new HashSet<>(visited)).apply();}
}
