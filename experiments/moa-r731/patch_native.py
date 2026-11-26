from pathlib import Path
import re,sys
root=Path(sys.argv[1]);helper='Lcom/juhyeon/familyjournea/MoaRemoteTimeline731;'
def file(n,name):
 a=list((root/str(n)).rglob(name+'.smali'));assert len(a)==1,(n,name,a);return a[0]
def edit(p,fn):p.write_text(fn(p.read_text()))
def method(s,name,fn):
 pattern=r'(?ms)^\.method [^\n]* '+re.escape(name)+r'\n.*?^\.end method'
 s,n=re.subn(pattern,lambda m:fn(m.group()),s);assert n==1,(name,n);return s
p=file(6,'MoaNativeGallery')
def gallery(s):
 def patch(m):
  old='Landroid/content/ContentUris;->withAppendedId(Landroid/net/Uri;J)Landroid/net/Uri;'
  assert m.count(old)>=1;return m.replace(old,helper+'->withAppendedId(Landroid/net/Uri;J)Landroid/net/Uri;')
 return method(s,'uri(Ljava/lang/String;)Landroid/net/Uri;',patch)
edit(p,gallery)
# Preview provider uses identical local content URI contract.
edit(file(20,'MoaR709PreviewProvider'),lambda s:method(s,'mediaUri(Ljava/lang/String;)Landroid/net/Uri;',lambda m:m.replace('Landroid/content/ContentUris;->withAppendedId(Landroid/net/Uri;J)Landroid/net/Uri;',helper+'->withAppendedId(Landroid/net/Uri;J)Landroid/net/Uri;')))
p=file(22,'MoaPeerProvider')
def peer(s):
 def command(m):
  needle='    invoke-static {p0, p1, p2, p3}, Lcom/juhyeon/familyjournea/MoaPair725;->handle'
  assert m.count(needle)==1
  return m.replace(needle,'    invoke-static {p0, p1, p2, p3}, '+helper+'->handle(Ljava/lang/Object;Landroid/webkit/WebView;ILjava/lang/String;)Z\n    move-result v0\n    if-eqz v0, :r731_original\n    return-void\n    :r731_original\n\n'+needle)
 s=method(s,'command(Landroid/webkit/WebView;ILjava/lang/String;)V',command)
 s=method(s,'getType(Landroid/net/Uri;)Ljava/lang/String;',lambda m:'.method public getType(Landroid/net/Uri;)Ljava/lang/String;\n    .locals 1\n    invoke-static {p1}, '+helper+'->type(Landroid/net/Uri;)Ljava/lang/String;\n    move-result-object v0\n    return-object v0\n.end method')
 s=method(s,'query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;',lambda m:'.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;\n    .locals 1\n    invoke-static {p1,p2}, '+helper+'->query(Landroid/net/Uri;[Ljava/lang/String;)Landroid/database/Cursor;\n    move-result-object v0\n    return-object v0\n.end method')
 assert '.method public openFile(' not in s and '.method public openTypedAssetFile(' not in s
 s+='\n.method public openFile(Landroid/net/Uri;Ljava/lang/String;)Landroid/os/ParcelFileDescriptor;\n    .locals 1\n    invoke-static {p0,p1,p2}, '+helper+'->openFile(Landroid/content/ContentProvider;Landroid/net/Uri;Ljava/lang/String;)Landroid/os/ParcelFileDescriptor;\n    move-result-object v0\n    return-object v0\n.end method\n\n.method public openTypedAssetFile(Landroid/net/Uri;Ljava/lang/String;Landroid/os/Bundle;)Landroid/content/res/AssetFileDescriptor;\n    .locals 1\n    invoke-static {p0,p1,p2,p3}, '+helper+'->typed(Landroid/content/ContentProvider;Landroid/net/Uri;Ljava/lang/String;Landroid/os/Bundle;)Landroid/content/res/AssetFileDescriptor;\n    move-result-object v0\n    return-object v0\n.end method\n'
 return s
edit(p,peer)
def augment(m):
 m,n=re.subn(r'(?m)^(    return-object )(\w+)$',lambda x:'    invoke-static {'+x.group(2)+'}, '+helper+'->augment(Lorg/json/JSONObject;)Lorg/json/JSONObject;\n    move-result-object '+x.group(2)+'\n'+x.group(),m);assert n==1;return m
edit(file(24,'MoaRemote721$Item'),lambda s:method(s,'json()Lorg/json/JSONObject;',augment))
edit(file(24,'MoaUpdate723'),lambda s:method(s,'open(Landroid/app/Activity;)V',lambda m:'.method public static open(Landroid/app/Activity;)V\n    .locals 0\n    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaUpdate731;->open(Landroid/app/Activity;)V\n    return-void\n.end method'))
print('native patch applied, original gallery methods preserved except URI mapping')
