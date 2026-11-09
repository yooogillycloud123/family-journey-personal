package com.juhyeon.familyjourney;

import android.app.Activity;
import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import java.util.ArrayList;

/** Presentation ONLY for the pre-existing photo/video quick memo activity.
 * Never changes recorder, MediaStore, M4A/voice file paths, listeners, or saving.
 */
public final class MoaR217MemoPolish {
 private static final int INK=0xff263040, PALE=0xfffbf9fb, RED=0xffed3159, EDGE=0xffe9dfe5;
 private MoaR217MemoPolish(){}
 private static int dp(Context c,float n){return (int)(n*c.getResources().getDisplayMetrics().density+.5f);}
 private static GradientDrawable bg(Context c,int fill,int stroke,int radius){
  GradientDrawable d=new GradientDrawable();d.setColor(fill);d.setCornerRadius(dp(c,radius));d.setStroke(dp(c,1),stroke);return d;
 }
 private static void beautify(View v,Activity a){
  if(v instanceof EditText){
   EditText e=(EditText)v;e.setBackground(bg(a,0xfffffcfd,0xffe9d1db,19));
   e.setPadding(dp(a,18),dp(a,16),dp(a,18),dp(a,16));
   e.setTextColor(INK);e.setHintTextColor(0xff99909d);e.setTextSize(16f);
   e.setMinLines(6);e.setMinHeight(dp(a,190));
  }else if(v instanceof CheckBox){
   CheckBox cb=(CheckBox)v;cb.setTextSize(12f);cb.setTextColor(0xff5c5865);
   cb.setButtonTintList(ColorStateList.valueOf(RED));
  }else if(v instanceof Button){
   Button b=(Button)v;String s=b.getText()==null?"":b.getText().toString();
   boolean primary=s.contains("모아 일기에")||s.contains("기록 저장");
   // All secondary buttons share one quiet surface; only the Save action is pink.
   int fill=primary?RED:0xfffaf9fb;
   int border=primary?RED:0xffe7dce4;
   b.setBackgroundTintList(null);b.setBackground(bg(a,fill,border,16));
   b.setTextColor(primary?Color.WHITE:INK);
   b.setAllCaps(false);b.setTextSize(14f);b.setTypeface(null,Typeface.BOLD);
   b.setMinHeight(dp(a,46));b.setElevation(0f);
   b.setPadding(dp(a,9),dp(a,8),dp(a,9),dp(a,8));
  }else if(v instanceof TextView){
   TextView t=(TextView)v;String s=t.getText()==null?"":t.getText().toString();
   if(s.startsWith("방금 찍은 사진")||s.contains("모아 시간대별 메모")){
    t.setText("모아 · 순간 기록");t.setTextColor(INK);t.setTextSize(21f);t.setTypeface(null,Typeface.BOLD);
   }else if(s.startsWith("기억나는 말을 적거나 음성으로")){
    t.setText("방금 찍은 순간을 남겨요.");
    t.setTextColor(0xff777582);t.setTextSize(13f);
   }
  }
  if(v instanceof ViewGroup){ViewGroup g=(ViewGroup)v;
   for(int i=0;i<g.getChildCount();i++)beautify(g.getChildAt(i),a);
  }
 }
 private static void foldBackup(Activity a,View root){
  if(!(root instanceof ViewGroup))return;
  ScrollView scroll=findScroll(root);if(scroll==null||scroll.getChildCount()==0)return;
  View child=scroll.getChildAt(0);if(!(child instanceof LinearLayout))return;
  LinearLayout body=(LinearLayout)child;
  ArrayList<View> collapsible=new ArrayList<>();int insertion=-1;
  for(int i=0;i<body.getChildCount();i++){
   View v=body.getChildAt(i);boolean include=false;
   if(v instanceof CheckBox)include=true;
   else if(v instanceof Button){String s=String.valueOf(((Button)v).getText());include=s.contains("기존 음성 전체 외부");}
   else if(v instanceof TextView){String s=String.valueOf(((TextView)v).getText());
    include=s.contains("Music/MOA-Recordings") || s.contains("앱 삭제 후에도 외부") || s.contains("녹음 외부 보관");
   }
   if(include){if(insertion<0)insertion=i;collapsible.add(v);}
  }
  if(collapsible.size()<2||insertion<0)return;
  LinearLayout more=new LinearLayout(a);more.setOrientation(LinearLayout.VERTICAL);
  more.setPadding(dp(a,13),dp(a,10),dp(a,13),dp(a,12));
  more.setBackground(bg(a,0xfffbfafc,EDGE,14));
  for(View v:collapsible){body.removeView(v);more.addView(v,new LinearLayout.LayoutParams(-1,-2));}
  more.setVisibility(View.GONE);
  TextView toggle=new TextView(a);toggle.setText("녹음 보관 · 백업 설정  ▾");
  toggle.setTextSize(13f);toggle.setTypeface(null,Typeface.BOLD);toggle.setTextColor(0xff686674);
  toggle.setPadding(dp(a,12),dp(a,15),dp(a,12),dp(a,15));
  toggle.setBackground(bg(a,0xfff4f3f6,EDGE,13));toggle.setClickable(true);
  toggle.setContentDescription("녹음 보관 설정 펼치기 또는 접기");
  toggle.setOnClickListener(v->{boolean opening=more.getVisibility()!=View.VISIBLE;
   more.setVisibility(opening?View.VISIBLE:View.GONE);
   toggle.setText(opening?"녹음 보관 · 백업 설정  ▴":"녹음 보관 · 백업 설정  ▾");
  });
  // R219: archive options belong at the very BOTTOM of the scrolling body,
  // never in the keyboard-visible first fold above the memo editing field.
  LinearLayout.LayoutParams advanced=new LinearLayout.LayoutParams(-1,-2);
  advanced.topMargin=dp(a,30);
  body.addView(toggle,advanced);
  body.addView(more,new LinearLayout.LayoutParams(-1,-2));
 }
 private static ScrollView findScroll(View v){
  if(v instanceof ScrollView)return (ScrollView)v;
  if(v instanceof ViewGroup){ViewGroup g=(ViewGroup)v;for(int i=0;i<g.getChildCount();i++){
   ScrollView r=findScroll(g.getChildAt(i));if(r!=null)return r;
  }}return null;
 }
 private static Button findButton(View root,String name){
  if(root instanceof Button){Button b=(Button)root;
   if(String.valueOf(b.getText()).contains(name))return b;}
  if(root instanceof ViewGroup){ViewGroup group=(ViewGroup)root;
   for(int i=0;i<group.getChildCount();i++){
    Button b=findButton(group.getChildAt(i),name);if(b!=null)return b;
   }}return null;
 }
 private static LinearLayout.LayoutParams cell(Activity a,boolean right){
  LinearLayout.LayoutParams p=new LinearLayout.LayoutParams(0,dp(a,48),1f);
  if(right)p.leftMargin=dp(a,10);return p;
 }
 private static void rearrangeFooter(Activity a,ViewGroup content){
  if(content.getChildCount()<1||!(content.getChildAt(0) instanceof LinearLayout))return;
  LinearLayout base=(LinearLayout)content.getChildAt(0);
  if(base.getChildCount()<2||!(base.getChildAt(base.getChildCount()-1) instanceof LinearLayout))return;
  LinearLayout footer=(LinearLayout)base.getChildAt(base.getChildCount()-1);
  if(footer.getChildCount()<3||!(footer.getChildAt(0) instanceof LinearLayout)
    ||!(footer.getChildAt(1) instanceof LinearLayout))return;
  LinearLayout first=(LinearLayout)footer.getChildAt(0),second=(LinearLayout)footer.getChildAt(1);
  Button rec=findButton(footer,"음성 녹음");
  Button mic=findButton(footer,"음성으로 말하기");
  Button play=findButton(footer,"녹음 듣기");
  Button clear=findButton(footer,"내용 전체 지우기");
  Button save=findButton(footer,"모아 일기에 기록 저장");
  if(rec==null||mic==null||play==null||clear==null||save==null)return;
  // Preserve exact preexisting Button instances and their click listeners.
  first.removeAllViews();second.removeAllViews();
  rec.setText("음성 녹음");mic.setText("음성 기록");
  play.setText("녹음 듣기");clear.setText("내용 전체 지우기");
  first.addView(rec,cell(a,false));first.addView(mic,cell(a,true));
  second.addView(play,cell(a,false));second.addView(clear,cell(a,true));
  footer.setPadding(dp(a,14),dp(a,11),dp(a,14),dp(a,14));
  footer.setBackground(bg(a,0xfffffcfd,0xfff0e7ec,20));
  first.setPadding(0,0,0,dp(a,5));
  second.setPadding(0,dp(a,5),0,dp(a,7));
  LinearLayout.LayoutParams saveP=new LinearLayout.LayoutParams(-1,dp(a,50));
  saveP.topMargin=dp(a,7);save.setLayoutParams(saveP);
  save.setTextColor(Color.WHITE);
 }
 public static void apply(Activity a){
  try{ViewGroup content=a.findViewById(android.R.id.content);
   if(content==null||content.getChildCount()==0)return;
   View base=content.getChildAt(0);content.setBackgroundColor(PALE);
   beautify(base,a);foldBackup(a,base);rearrangeFooter(a,content);
   a.getWindow().setStatusBarColor(0xfff7f6f9);a.getWindow().setNavigationBarColor(0xff101116);
  }catch(Throwable ignored){/* Cosmetic changes must never block capture/record/save. */}
 }
}
