/* 사진 여행 지도 — 모바일 앱 UI(TDS 스타일). 렌더링은 engine.js, 영상 생성은 render-worker.js */
(() => {
'use strict';
const $ = (s) => document.querySelector(s);
const $$ = (s) => Array.from(document.querySelectorAll(s));
if (!window.PhotoMapEngine) { document.body.innerHTML = '<p style="padding:2rem;font-family:sans-serif">지도 데이터(world.js)가 없습니다.</p>'; return; }
const NATIVE = !!window.__nativeHost;
window.__openUrlQueue = []; window.__openUrl = (u) => { window.__openUrlQueue.push(u); };
const escH = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));   // HTML 이스케이프 (모든 화면 공용)   // 네이티브 딥링크(phototravelmap://…)가 부팅 전에 오면 큐에 — boot 안에서 실제 핸들러로 교체
const PLATFORM = window.AndroidBridge ? 'android' : 'ios';   // 워터마크 문구 등 스토어 이름 분기
const nlog = (t) => { try { if (NATIVE && window.webkit && window.webkit.messageHandlers.log) window.webkit.messageHandlers.log.postMessage({ text: t }); } catch (e) { /* ignore */ } console.warn(t); };
const { clamp, fmtN, fmtShort, fmtYMD, fmtTime, parseLocal, flag, isoToday, hav } = PhotoMapEngine.util;
const { THEMES, TILE_STYLES } = PhotoMapEngine;
const I18N = window.I18N; const tr = (k, p) => (I18N ? I18N.t(k, p) : k); const ord = (n) => (I18N ? I18N.ord(n) : String(n));   // 다국어(i18n.js): 한국어 원문이 키

function boot(DATA) {
// ---------- 설정 ----------
const DEFAULTS = { selection: 'all', preset: 'all', from: '', to: '', camera: 'follow', mapMode: 'flat', theme: 'light', aspect: '9:16',
  shortEdge: 1080, duration: 'auto', tempo: 1.5, includeShort: false, title: '', subtitle: '', outro: '', photoDots: true, emoji: true, watermark: true, tiles: 'esri', posterStyle: 'classic', posterAspect: '9:16' };
const S = Object.assign({}, DEFAULTS, loadSettings());
S.lang = I18N ? I18N.lang : 'ko';   // 영상 워커(다른 전역)도 같은 언어로 자막을 그리도록 설정에 실어 보낸다
const qp = new URLSearchParams(location.search);
if (typeof S.duration === 'string' && S.duration.startsWith('auto-')) { S.tempo = Math.min(4, parseFloat(S.duration.slice(5)) || 1.5); S.duration = 'auto'; }
else if (typeof S.duration === 'string' && +S.duration > 0) S.duration = +S.duration;
if (![1, 1.5, 2, 3, 4].includes(+S.tempo)) S.tempo = 1.5;
if (!(S.tiles in TILE_STYLES)) S.tiles = 'esri'; if (!(S.theme in THEMES)) S.theme = 'light';
function loadSettings() { try { return JSON.parse(localStorage.getItem('photo-map-settings.v3') || '{}'); } catch (e) { return {}; } }
function saveSettings() { try { localStorage.setItem('photo-map-settings.v3', JSON.stringify(S)); } catch (e) { /* ignore */ } }

// ---------- 엔진 (미리보기용, 화면 캔버스) ----------
const canvas = $('#stage');
let tileOkLogged = ''; const E = PhotoMapEngine.create({ canvas, S, DATA, platform: PLATFORM, onTileLoaded: () => { dirty = true; if (tileOkLogged !== S.tiles) { tileOkLogged = S.tiles; nlog('tiles ok: ' + S.tiles); } }, onTileError: (u, n) => { if (n <= 3) nlog('tile error #' + n + ' ' + u); }, onTileRequest: (u, n) => { if (n < 2) nlog('tile request #' + n + ' ' + u + ' useTiles=' + (S.tiles !== 'none' && S.mapMode !== 'globe') + ' healthy=' + E.tilesHealthy); }, onTilesUnavailable: () => { const n = $('#tiles-note'); if (n) n.textContent = tr('지금은 지도 타일을 받을 수 없어 내장 지도로 보여요 (오프라인이거나 차단됨).'); } });
const titleText = E.titleText, tripOK = E.tripOK;

// ---------- 프리미엄 / 광고 ----------
// 무료: 1080p 무제한, 기본 옵션. 프리미엄(1회 구매): 광고 제거 + 아래 잠긴 옵션 해제.
const PREMIUM = { theme: ['light'], mapMode: ['flat'], tiles: ['esri', 'none'], camera: ['follow'], shortEdge: ['1080'] };
const PREMIUM_TOGGLES = ['photoDots', 'emoji', 'watermark']; // 무료는 항상 켜짐 (워터마크 포함)
let premium = !NATIVE ? true : (() => { try { return localStorage.getItem('premium.cached') === '1'; } catch (e) { return false; } })();
let premiumPrice = '';
const isLocked = (key, value) => !premium && PREMIUM[key] && !PREMIUM[key].includes(String(value));
function enforceFree() {
  if (premium) return;
  for (const [key, allowed] of Object.entries(PREMIUM)) if (!allowed.includes(String(S[key]))) S[key] = key === 'shortEdge' ? 1080 : allowed[0];
  for (const key of PREMIUM_TOGGLES) S[key] = true;
}
window.__setPremium = (on, price) => {
  premium = !!on; premiumPrice = price || '';
  try { localStorage.setItem('premium.cached', premium ? '1' : '0'); } catch (e) { /* ignore */ }
  enforceFree(); syncUI(); rebuild(true);
  const pill = $('#btn-premium'); if (pill) pill.hidden = true;   // 프리미엄은 설정 탭에서
  if (typeof renderSettings === 'function' && tab === 'settings' && step === 0) renderSettings();
  const buy = $('#btn-buy'); if (buy) buy.textContent = premium ? tr('이미 프리미엄이에요') : `${tr('구매하기')}${premiumPrice ? ' · ' + premiumPrice : ''}`;
  if (buy) buy.disabled = premium;
  syncBanner();   // 프리미엄이 되면 배너 광고 숨김
};
const nativeEvents = {};
window.__nativeEvent = (name, payload) => { const cb = nativeEvents[name]; if (cb) { delete nativeEvents[name]; cb(payload || {}); } };
const askNative = (name, body) => new Promise((resolve) => { nativeEvents[name] = resolve; try { window.webkit.messageHandlers[name].postMessage(body || {}); } catch (e) { delete nativeEvents[name]; resolve({ ok: false, available: false, message: tr('이 환경에서는 지원하지 않아요.') }); } });
function openPremium(msg) { $('#premium-msg').textContent = msg || ''; $('#premium-root').hidden = false; document.body.style.overflow = 'hidden'; if (NATIVE) { try { window.webkit.messageHandlers.premiumInfo.postMessage({}); } catch (e) { /* ignore */ } } }
function closePremium() { $('#premium-root').hidden = true; document.body.style.overflow = ''; }
$('#premium-dim').addEventListener('click', closePremium); $('#premium-close').addEventListener('click', closePremium);
$('#btn-premium').addEventListener('click', () => openPremium());
(() => { const b = $('#btn-ad-privacy'); if (b && NATIVE) { b.hidden = false; b.addEventListener('click', async (e) => { e.preventDefault(); const r = await askNative('adPrivacy'); if (r && r.message) alert(r.message); }); } })();
$('#btn-buy').addEventListener('click', async () => { if (premium) return; $('#premium-msg').textContent = tr('구매 창을 여는 중…'); const r = await askNative('purchase'); $('#premium-msg').textContent = r.message || ''; if (r.ok) setTimeout(closePremium, 900); });
$('#btn-restore').addEventListener('click', async () => { $('#premium-msg').textContent = tr('복원하는 중…'); const r = await askNative('restore'); $('#premium-msg').textContent = r.message || ''; });
/// 무료 사용자의 저장 게이트: 보상형 광고를 보면 저장. 광고를 못 불러오면 그냥 통과.
async function gateSave(action) {
  if (premium || !NATIVE) return action();
  const st = $('#rec-status'); const prev = st.textContent; st.textContent = tr('잠깐 광고를 보고 나면 저장할 수 있어요 (프리미엄은 광고 없이 바로 저장).');
  const r = await askNative('rewardedAd');
  if (!r.available) { st.textContent = prev; return action(); }
  if (r.rewarded) { st.textContent = prev; return action(); }
  st.textContent = tr('광고를 끝까지 보면 저장할 수 있어요.');
}

// ---------- 재생 루프 ----------
let T = 0, playing = false, lastTs = null, dirty = true, step = 1;
function loop(ts) {
  requestAnimationFrame(loop);
  const dt = lastTs == null ? 0 : Math.min(0.1, (ts - lastTs) / 1000); lastTs = ts;
  if (playing) { T += dt; if (T >= E.TL.total) { T = E.TL.total; setPlaying(false); if (recording) stopRecording(); } dirty = true; }
  if (step < 4 && !recording) return;
  const st = E.stateAt(T);
  if (playing || dirty) { E.stepCamera(st, dt || 1 / 60); E.draw(T); updateBar(); dirty = playing; }
}
function setPlaying(v) {
  playing = v; $('#ic-play').hidden = v; $('#ic-pause').hidden = !v; $('#btn-big-play').hidden = v || recording;
  if (v && T >= E.TL.total) { T = 0; E.snapCamera(E.stateAt(0)); } dirty = true;
}
function seekTo(t, snap) { T = clamp(t, 0, E.TL.total); if (snap) E.snapCamera(E.stateAt(T)); dirty = true; }
let seeking = false;
function updateBar() { const sk = $('#seek'); const tot = E.TL.total; const pct = tot ? T / tot * 100 : 0; if (!seeking) sk.value = String(Math.round(pct * 100)); sk.style.setProperty('--p', pct.toFixed(2) + '%'); $('#time').textContent = `${fmtTime(T)} / ${fmtTime(tot)}`; }
let renderSig = '';
function rebuild(keepTime) {
  E.rebuild();
  const sig = JSON.stringify([S.selection, S.preset, S.from, S.to, S.includeShort, S.camera, S.mapMode, S.theme, S.aspect, S.shortEdge, S.duration, S.tempo, S.title, S.subtitle, S.outro, S.photoDots, S.emoji, S.watermark, S.tiles]);
  if (sig !== renderSig) { renderSig = sig; lastBlob = null; if (rendering) renderCancel = true; const ra = $('#rec-actions'); if (ra) ra.hidden = true; const st = $('#rec-status'); if (st && !rendering) st.textContent = ''; }
  if (step === 5) renderDurationUI();
  T = keepTime ? clamp(T, 0, E.TL.total) : 0;
  E.snapCamera(E.stateAt(T)); dirty = true; renderStats(); updateBar(); updateMock();
}

// ---------- UI: 옵션 정의 ----------
const OPTIONS = {
  theme: [{ v: 'light', l: '밝은 지도', d: '흰 배경에 파란 경로' }, { v: 'dark', l: '어두운 지도', d: '차분한 밤 느낌' }],
  mapMode: [{ v: 'flat', l: '평면 지도', d: '상세 지도(위성·OSM)를 쓸 수 있어요' }, { v: 'globe', l: '지구본', d: '해외 여행이 많을 때 잘 어울려요 · 내장 지도만 사용' }],
  tiles: [{ v: 'esri', l: '기본 (온라인)', d: '확대하면 도로와 지명이 보여요' }, { v: 'esri-sat', l: '위성사진' }, { v: 'osm', l: 'OpenStreetMap' }, { v: 'none', l: '내장 지도 (오프라인)', d: '인터넷 없이도 돼요. 확대하면 단순하게 보여요' }],
  camera: [{ v: 'follow', l: '부드럽게 따라가기', d: '이동할 땐 두 지점을, 머물 땐 도시를 보여줘요' }, { v: 'close', l: '클로즈업 추적', d: '이동 중인 아이콘을 가까이 따라가요' }, { v: 'fixed', l: '전체 고정', d: '전체 경로가 보이도록 고정해요' }],
  duration: [{ v: 'auto', l: '자동 · 여유롭게' }, { v: 'auto-1.6', l: '자동 · 조금 빠르게', d: '추천' }, { v: 'auto-2.5', l: '자동 · 빠르게' }, { v: 'auto-4', l: '자동 · 아주 빠르게' }, { v: '30', l: '30초' }, { v: '60', l: '1분' }, { v: '90', l: '1분 30초' }, { v: '120', l: '2분' }, { v: '180', l: '3분' }],
  shortEdge: [{ v: '720', l: '720p', d: '가볍고 빠르게' }, { v: '1080', l: '1080p', d: '추천' }, { v: '1440', l: '1440p', d: '선명하지만 녹화가 무거워요' }],
  posterStyle: [{ v: 'classic', l: '기본', d: '경로와 제목 카드' }, { v: 'highlight', l: '갔던 곳만 밝히기', d: '경로 없이 다녀온 곳을 빛나게' }, { v: 'deco', l: '꾸미기', d: '테두리·국기·통계 칩으로 꾸민 포스터' }, { v: 'minimal', l: '미니멀', d: '큰 제목과 가는 경로만' }],
  posterAspect: [{ v: '9:16', l: '세로 9:16', d: '스토리·잠금화면' }, { v: 'kakao', l: '카톡 프로필 배경', d: '9:16 · 잘릴 수 있는 가장자리를 피해 위쪽에 배치, 아래는 이름·버튼 자리로 비움' }, { v: '4:5', l: '인스타 피드 4:5' }, { v: '1:1', l: '정사각 1:1' }, { v: '16:9', l: '가로 16:9' }],
};
for (const arr of Object.values(OPTIONS)) for (const o of arr) { o.l = tr(o.l); if (o.d) o.d = tr(o.d); }   // 옵션 이름·설명 번역
const labelOf = (key) => { const o = OPTIONS[key].find(o => String(o.v) === String(S[key])); return o ? o.l : String(S[key]); };
function applySetting(key) {
  nlog('setting ' + key + ' = ' + S[key]);
  if (key === 'posterStyle' || key === 'posterAspect') { syncUI(); posterPreview(); return; }   // 이미지 옵션은 영상과 무관
  if (key === 'tiles' && S.tiles !== 'none' && S.mapMode === 'globe') { S.mapMode = 'flat'; saveSettings(); }   // 타일은 평면 지도에서만 → 자동 전환
  if (key === 'theme') { $('#app').dataset.theme = S.theme; E.invalidateBase(); dirty = true; }
  else if (key === 'tiles') { E.resetTiles(); rebuild(true); }
  else if (key === 'duration') rebuild();
  else rebuild(true);
  syncUI();
}
// 바텀시트
function openSheet(key) {
  const root = $('#sheet-root'); const list = $('#sheet-options'); list.innerHTML = ''; $('#sheet-log').hidden = true;
  $('#sheet-title').textContent = tr({ theme: '테마', mapMode: '지도 종류', tiles: '상세 지도', camera: '카메라', duration: '영상 길이', shortEdge: '해상도', posterStyle: '이미지 스타일', posterAspect: '이미지 비율' }[key] || '');
  for (const o of OPTIONS[key]) {
    const locked = isLocked(key, o.v);
    const li = document.createElement('li'); li.className = 'row' + (String(o.v) === String(S[key]) ? ' active' : '') + (locked ? ' locked' : '');
    li.innerHTML = `<div class="row-body"><div class="row-title">${o.l}${locked ? `<span class="lock">${tr('프리미엄')}</span>` : ''}</div>${o.d ? `<div class="row-desc">${o.d}</div>` : ''}</div><span class="check"></span>`;
    li.addEventListener('click', () => { if (locked) { closeSheet(); openPremium(tr('이 옵션은 프리미엄에서 쓸 수 있어요.')); return; } S[key] = key === 'shortEdge' ? +o.v : o.v; saveSettings(); closeSheet(); applySetting(key); });
    list.appendChild(li);
  }
  root.hidden = false; document.body.style.overflow = 'hidden';
}
function closeSheet() { $('#sheet-root').hidden = true; document.body.style.overflow = ''; }
// 전체 기록(시간순) 시트
function openLog() {
  const root = $('#sheet-root'); $('#sheet-options').innerHTML = ''; $('#sheet-title').textContent = tr('전체 기록');
  const box = $('#sheet-log'); box.hidden = false; box.innerHTML = '';
  const fmtR = (s) => `${fmtYMD(parseLocal(s.start))}${s.end.slice(0, 10) !== s.start.slice(0, 10) ? ' ~ ' + fmtShort(parseLocal(s.end)) : ''}`;
  const tripsById = new Map(DATA.trips.map(t => [t.id, t]));   // (엔진 내부 변수와 별개 — 없으면 ReferenceError 로 시트가 안 열렸음)
  let curTrip = null;
  DATA.stops.forEach((s) => {
    if (!s.home && s.trip && s.trip !== curTrip && tripsById.has(s.trip)) {
      curTrip = s.trip; const t = tripsById.get(s.trip);
      const h = document.createElement('div'); h.className = 'log-trip'; h.innerHTML = `<span>${t.abroad ? icon('plane', 'i-plane') + ' ' : ''}${escH(t.title)}</span><small>${tr('{d}일 · 사진 {n}장', { d: t.days, n: fmtN(t.n) })} · ${fmtN(t.km)}km</small>`; box.appendChild(h);
    }
    if (s.home) curTrip = null;
    const el = document.createElement('div'); el.className = 'log-item' + (s.home ? ' home' : '') + (s.minor ? ' minor' : '');
    const name = s.home ? escH(tr('집 · {name}', { name: s.name })) : `${ccBadge(s.cc)} ${escH(s.name)}${s.admin1 && s.admin1 !== s.name ? ' (' + escH(s.admin1) + ')' : ''}`;
    el.innerHTML = `<span class="dot"></span><div><div class="name">${name}</div><div class="meta">${fmtR(s)} · ${tr('{d}일 · 사진 {n}장', { d: s.days, n: fmtN(s.n) })}${s.minor ? ' · ' + tr('잠깐 들름') : ''}</div></div>`;
    box.appendChild(el);
  });
  root.hidden = false; document.body.style.overflow = 'hidden';
}
$('#sheet-dim').addEventListener('click', closeSheet); $('#sheet-close').addEventListener('click', closeSheet);
$$('.row.tap[data-sheet]').forEach(r => r.addEventListener('click', () => openSheet(r.dataset.sheet)));

// 스텝
const STEP_TITLES = ['', '', '여행 선택', '문구', '스타일', '영상'].map(s => (s ? tr(s) : s));
const RETURNING = true;   // 소개 화면은 없다: 항상 0단계(탭 홈)로 시작. 첫 실행 안내는 튜토리얼(startTutorial)
const homeStep = () => 0;
const prevStep = (n) => n === 2 ? 0 : n - 1;
// 탭(나의 지도 · 추천 · 대결 · 기록 · 설정): 앱 뼈대. 0단계 = 탭 화면, 1~5단계 = 영상 만들기 흐름(탭바 숨김·CTA 표시)
let tab = 'diary';
const TAB_TITLES = { home: '나의 지도', reco: '추천', record: '기록', settings: '설정' };
function showTab(name) {
  if (recording) return;
  if (name === 'video') { goStep(2); return; }
  if (rendering) renderCancel = true;
  tab = name; step = 0;
  $$('.page').forEach(p => { p.hidden = !(name === 'home' ? p.dataset.page === '0' : p.dataset.page === name); });
  $('#btn-back').hidden = true; $('#top-title').textContent = ''; $('#progress').hidden = true;   // 탭 화면은 본문 큰 제목만(헤더 제목 중복 방지)
  const player = $('#player'); player.hidden = true; if (playing) setPlaying(false);
  $('#tabbar').hidden = false; $('#cta').hidden = true; $('#top').hidden = true; $('#app').classList.add('tabs');   // 탭 화면은 본문 큰 제목이 헤더 역할
  $$('#tabbar button').forEach(b => b.classList.toggle('active', b.dataset.tab === name));
  if (name === 'home') renderHome(); else if (name === 'reco') { recoSeed = 1 + Math.floor(Math.random() * 1e6); renderReco(); } else if (name === 'record') renderRecord(); else if (name === 'battle') renderBattle(); else if (name === 'settings') renderSettings();   // 추천은 들어올 때마다 다른 곳
  window.scrollTo(0, 0);
  try { history.replaceState(null, '', '#' + name); } catch (e) { /* ignore */ }
  syncBanner();
}
$$('#tabbar button').forEach(b => b.addEventListener('click', () => showTab(b.dataset.tab)));
function goStep(n) {
  if (recording) return;
  if (rendering && n !== 5) renderCancel = true;
  step = clamp(n, homeStep(), 5);
  if (step === 0) { showTab(tab === 'video' ? 'home' : tab); return; }
  $$('.page').forEach(p => { p.hidden = p.dataset.page !== String(step); });
  $('#tabbar').hidden = true; $('#cta').hidden = false; $('#top').hidden = false; $('#app').classList.remove('tabs');
  $('#btn-back').hidden = step <= homeStep(); $('#top-title').textContent = STEP_TITLES[step]; $('#progress').hidden = step === 0; $('#progress i').style.width = (step / 5 * 100) + '%';
  if (step === 0) renderHome();
  const player = $('#player');
  if (step >= 4) { const slot = step === 4 ? $('#slot-style') : $('#slot-video'); if (player.parentNode !== slot) slot.appendChild(player); player.hidden = false; dirty = true; }
  else { player.hidden = true; if (playing) setPlaying(false); }
  if (step === 3) updateMock(); if (step === 5) renderStats();
  if (step === 5) { renderDurationUI(); posterPreview(); }
  updateCTA(); window.scrollTo(0, 0);
  try { history.replaceState(null, '', '#' + step); } catch (e) { /* ignore */ }
  syncBanner();
}
function updateCTA() {
  const p = $('#cta-primary'), s = $('#cta-secondary');
  s.hidden = step <= 1 || recording; s.textContent = tr('이전'); s.onclick = () => goStep(prevStep(step));
  p.className = 'btn primary'; p.disabled = false;
  if (step === 0) { p.textContent = tr('영상 만들기'); p.onclick = () => goStep(2); }
  else if (step < 5) { p.textContent = tr('다음'); p.onclick = () => goStep(step + 1); }
  else if (rendering) { p.textContent = tr('영상 저장하기'); p.disabled = true; }
  else if (recording) { p.textContent = tr('녹화 중지'); p.className = 'btn danger'; p.onclick = stopRecording; }
  else if (lastBlob && NATIVE) { p.textContent = premium ? tr('영상 저장하기') : tr('광고 보고 영상 저장'); p.onclick = () => gateSave(() => window.__onVideoReady && window.__onVideoReady(lastBlob, lastName)); }
  else if (lastBlob) { p.textContent = tr('영상 다운로드'); p.onclick = () => $('#btn-download').click(); }
  else { p.textContent = tr('영상 만들기'); p.onclick = makeVideo; }
}
$('#btn-back').addEventListener('click', () => goStep(prevStep(step)));
$$('#steps li').forEach(li => li.addEventListener('click', () => goStep(+li.dataset.step)));
// 하단 배너 광고(네이티브 뷰, WebView 아래): 무료 사용자 + 탭 화면(나의 지도·추천·대결·기록·설정)에서만. 영상 만들기 흐름·프리미엄은 없음
var bannerShown = null;
function syncBanner() {
  if (!NATIVE) return;
  const want = !premium && step === 0;
  if (want === bannerShown) return; bannerShown = want;
  try { window.webkit.messageHandlers.adBanner.postMessage({ show: want }); } catch (e) { /* ignore */ }
}

// 여행 목록
function renderTrips() {
  const ul = $('#trip-list'); ul.innerHTML = '';
  const mk = (cls, ico, title, desc, tags, onClick, active) => {
    const li = document.createElement('li'); li.className = 'row ' + cls + (active ? ' active' : '');
    li.innerHTML = `<span class="row-ico">${ico}</span><div class="row-body"><div class="row-title">${title}</div><div class="row-desc">${desc}</div>${tags ? `<div class="tags">${tags.map(t => `<span>${t}</span>`).join('')}</div>` : ''}</div><span class="check"></span>`;
    li.addEventListener('click', onClick); ul.appendChild(li);
  };
  const r = DATA.meta.range || ['', ''];
  mk('all', icon('compass'), tr('전체 여정'), `${r[0].replace(/-/g, '.')} ~ ${r[1].replace(/-/g, '.')} · ${tr('여행 {n}개', { n: DATA.trips.length })}`, null, () => { S.selection = 'all'; saveSettings(); rebuild(); renderTrips(); }, S.selection === 'all');
  [...DATA.trips].sort((a, b) => b.start.localeCompare(a.start)).forEach(t => {
    const flags = t.countries.slice(0, 2).map(ccBadge).filter(Boolean).join('') || icon('car');
    const desc = `${fmtYMD(parseLocal(t.start))}${t.days > 1 ? ' ~ ' + fmtShort(parseLocal(t.end)) : ''} · ${tr('{d}일 · 사진 {n}장', { d: t.days, n: fmtN(t.n) })}`;
    mk(tripOK(t) ? '' : 'faded', t.abroad ? flags : icon('car'), t.title, desc, tripOK(t) ? null : [tr('짧은 나들이')], () => { S.selection = String(t.id); saveSettings(); rebuild(); renderTrips(); }, String(S.selection) === String(t.id));
  });
  $('#range-block').hidden = S.selection !== 'all';
}
// 기간 칩
$$('#range-block .chip').forEach(b => b.addEventListener('click', () => { S.preset = b.dataset.preset; saveSettings(); syncUI(); rebuild(); }));
$('#date-from').addEventListener('change', (e) => { S.from = e.target.value; S.preset = 'custom'; saveSettings(); rebuild(); });
$('#date-to').addEventListener('change', (e) => { S.to = e.target.value; S.preset = 'custom'; saveSettings(); rebuild(); });
$('#include-short').addEventListener('change', (e) => { S.includeShort = e.target.checked; saveSettings(); rebuild(); renderTrips(); });
// 문구
for (const [id, key] of [['#inp-title', 'title'], ['#inp-subtitle', 'subtitle'], ['#inp-outro', 'outro']]) {
  $(id).addEventListener('input', (e) => { S[key] = e.target.value; saveSettings(); updateMock(); dirty = true; lastBlob = null; renderSig = ''; posterPreview(); });
}
function updateMock() {
  const mt = $('#mock-title'); if (!mt) return;
  const tot = E.SEQ.length >= 2 ? E.counters({ g: E.TL.segs[E.TL.segs.length - 1], p: 1 }) : { photos: 0, countries: 0, cities: 0 };
  mt.textContent = titleText();
  $('#mock-sub').textContent = (S.subtitle || '').trim() || (E.SEQ.length ? `${fmtYMD(E.SEQ[0].ts0)} – ${fmtYMD(E.SEQ[E.SEQ.length - 1].ts1)}` : '');
  $('#mock-meta').textContent = tr('사진 {p}장 · {a}개국 {b}개 도시', { p: fmtN(tot.photos), a: tot.countries, b: tot.cities });
}
// 스타일
$$('#seg-aspect button').forEach(b => b.addEventListener('click', () => { S.aspect = b.dataset.v; saveSettings(); syncUI(); rebuild(true); }));
$('#chk-dots').addEventListener('change', (e) => { if (!premium) { e.target.checked = true; openPremium(tr('표시 옵션은 프리미엄에서 바꿀 수 있어요.')); return; } S.photoDots = e.target.checked; saveSettings(); dirty = true; lastBlob = null; renderSig = ''; });
$('#chk-emoji').addEventListener('change', (e) => { if (!premium) { e.target.checked = true; openPremium(tr('표시 옵션은 프리미엄에서 바꿀 수 있어요.')); return; } S.emoji = e.target.checked; saveSettings(); dirty = true; lastBlob = null; renderSig = ''; });
$('#chk-wm').addEventListener('change', (e) => { if (!premium) { e.target.checked = true; openPremium(tr('앱 홍보 문구는 프리미엄에서 끌 수 있어요.')); return; } S.watermark = e.target.checked; saveSettings(); dirty = true; lastBlob = null; renderSig = ''; });
// 길이(종료 시간) · 배속
let durMode = typeof S.duration === 'number' ? ([15, 30, 60, 90].includes(S.duration) ? String(S.duration) : 'custom') : 'auto';
$$('#dur-chips .chip').forEach(b => b.addEventListener('click', () => {
  durMode = b.dataset.v;
  if (durMode === 'auto') S.duration = 'auto';
  else if (durMode === 'custom') S.duration = +$('#dur-slider').value;
  else S.duration = +durMode;
  saveSettings(); rebuild(true); updateCTA();
}));
$('#dur-slider').addEventListener('input', (e) => { $('#dur-slider-val').textContent = fmtTime(+e.target.value); });
$('#dur-slider').addEventListener('change', (e) => { durMode = 'custom'; S.duration = +e.target.value; saveSettings(); rebuild(true); updateCTA(); });
$$('#tempo-row .chip').forEach(b => b.addEventListener('click', () => { S.tempo = +b.dataset.v; if (S.duration !== 'auto') { S.duration = 'auto'; durMode = 'auto'; } saveSettings(); rebuild(true); updateCTA(); }));
function renderDurationUI() {
  const TL = E.TL; if (!TL || !TL.total) return;
  $$('#dur-chips .chip').forEach(b => b.classList.toggle('active', b.dataset.v === durMode));
  $('#dur-custom').hidden = durMode !== 'custom';
  if (durMode === 'custom') { $('#dur-slider').value = String(Math.round(S.duration)); $('#dur-slider-val').textContent = fmtTime(S.duration); }
  const auto = S.duration === 'auto';
  $$('#tempo-row .chip').forEach(b => { b.classList.toggle('active', auto && +b.dataset.v === +S.tempo); b.disabled = !auto; b.style.opacity = auto ? '' : '.5'; });
  $('#dur-info').textContent = tr('총 {t} · 배속 ×{k}', { t: fmtTime(TL.total), k: TL.tempo.toFixed(1) }) + (auto ? '' : ' ' + tr('(종료 시간에 맞춰 자동)'));
  const reco = $('#reco'); const total = TL.total; const vertical = S.aspect === '9:16';
  const fit60 = () => { durMode = '60'; S.duration = 60; saveSettings(); rebuild(true); updateCTA(); };
  const fitBtn = (label, fn) => { const b = document.createElement('button'); b.textContent = label; b.addEventListener('click', fn); return b; };
  reco.className = 'reco'; reco.innerHTML = '';
  if (vertical && total <= 60.5) { reco.classList.add('good'); reco.innerHTML = tr('<b>인스타 스토리 업로드에 추천해요</b> · 1분 이하 · 세로'); }
  else if (vertical && total <= 90.5) { reco.innerHTML = tr('릴스·쇼츠에 맞아요 (90초 이하). 스토리에 올리려면 1분 이하로 맞춰야 해요.'); reco.appendChild(fitBtn(tr('1분으로 맞추기'), fit60)); }
  else if (vertical) { reco.classList.add('warn'); reco.innerHTML = tr('<b>1분 30초를 넘으면</b> 릴스·쇼츠·스토리에 올릴 수 없어요.'); reco.appendChild(fitBtn(tr('1분으로 맞추기'), fit60)); }
  else if (S.aspect === '16:9') { reco.innerHTML = tr('유튜브·PC 화면에 맞는 가로 영상이에요. 스토리·릴스는 세로 비율을 골라주세요.'); }
  else { reco.innerHTML = tr('정사각 영상은 인스타 피드에 잘 맞아요.') + (total > 60.5 ? ' ' + tr('피드 영상은 1분 이하를 권장해요.') : ''); if (total > 60.5) reco.appendChild(fitBtn(tr('1분으로 맞추기'), fit60)); }
}
// 플레이어
$('#btn-play').addEventListener('click', () => setPlaying(!playing));
$('#btn-big-play').addEventListener('click', () => setPlaying(true));
$('#btn-restart').addEventListener('click', () => seekTo(0, true));
$('#seek').addEventListener('input', (e) => { seeking = true; seekTo(+e.target.value / 10000 * E.TL.total, true); });
$('#seek').addEventListener('change', () => { seeking = false; });
window.addEventListener('keydown', (e) => {
  if (['INPUT', 'SELECT', 'TEXTAREA'].includes(e.target.tagName)) return;
  if (e.code === 'Space' && step >= 4) { e.preventDefault(); setPlaying(!playing); }
  if (e.code === 'Escape') closeSheet();
});
function syncUI() {
  $('#app').dataset.theme = S.theme;
  $$('.row-value[data-value]').forEach(el => { el.textContent = labelOf(el.dataset.value); if (el.dataset.value === 'tiles' && S.mapMode === 'globe') el.textContent = tr('지구본에선 내장 지도'); });
  $$('#seg-aspect button').forEach(b => b.classList.toggle('active', b.dataset.v === S.aspect));
  $$('#range-block .chip').forEach(b => b.classList.toggle('active', b.dataset.preset === S.preset));
  $('#dates').hidden = S.preset !== 'custom'; $('#date-from').value = S.from || ''; $('#date-to').value = S.to || '';
  $('#include-short').checked = !!S.includeShort; $('#chk-dots').checked = !!S.photoDots; $('#chk-emoji').checked = !!S.emoji; $('#chk-wm').checked = S.watermark !== false;
  const wl = $('#wm-lock'); if (wl) wl.hidden = premium;
  $('#inp-title').value = S.title || ''; $('#inp-subtitle').value = S.subtitle || ''; $('#inp-outro').value = S.outro || '';
  renderDurationUI();
}
function renderStats() {
  const tile = (v, l, i) => `<div class="stat c${i + 1}"><b>${v}</b><span>${l}</span></div>`;
  const tot = E.SEQ.length >= 2 ? E.counters({ g: E.TL.segs[E.TL.segs.length - 1], p: 1 }) : { countries: 0, cities: 0, photos: 0, km: 0 };
  const sdays = E.SEQ.length ? Math.round((E.SEQ[E.SEQ.length - 1].ts1 - E.SEQ[0].ts0) / 864e5) + 1 : 0;
  $('#stats').innerHTML = [[tot.countries, tr('개국', { n: tot.countries })], [tot.cities, tr('개 도시', { n: tot.cities })], [fmtN(tot.photos), tr('장의 사진', { n: tot.photos })], [fmtN(tot.km), tr('km 이동')], [fmtN(sdays), tr('일', { n: sdays })], [fmtTime(E.TL.total), tr('영상 길이')]].map(([v, l], i) => tile(v, l, i)).join('');
  $('#country-list').innerHTML = DATA.countries.map(c => `<li class="row"><div class="row-body"><div class="row-title">${ccBadge(c.cc)} ${escH(c.name)}</div></div><span class="r">${tr('{s}곳 · 사진 {n}장 · {d}일', { s: c.stops, n: fmtN(c.n), d: c.days })}</span></li>`).join('');
}

// ---------- 영상 생성: 웹 워커(OffscreenCanvas + WebCodecs) → MP4. 화면과 분리되어 렉이 없다 ----------
let rendering = false, renderCancel = false, renderPct = 0, renderWorker = null;
const sleep = (ms) => new Promise(r => setTimeout(r, ms));
const nextFrame = () => new Promise(r => requestAnimationFrame(r));
const canRender = () => typeof VideoEncoder !== 'undefined' && typeof VideoFrame !== 'undefined' && window.Mp4Muxer;
const canWorker = () => typeof Worker !== 'undefined' && typeof OffscreenCanvas !== 'undefined' && !!window.__workerURL;
function makeVideo() { if (canWorker() || canRender()) renderVideo(); else startRecording(); }
function setProgress(frac, elapsedMs) {
  renderPct = Math.min(99, Math.floor(frac * 100));
  const remain = frac > 0.02 ? Math.round(elapsedMs / frac * (1 - frac) / 1000) : null;
  $('#rec-text').textContent = tr('저장 준비 중 {p}%', { p: renderPct }); $('#rec-time').textContent = remain != null ? `· ${fmtTime(remain)}` : '';
  $('#rec-status').innerHTML = `<span class="prog"><i style="width:${renderPct}%"></i></span> ${tr('저장 준비 중 {p}% — 미리보기는 자유롭게 보세요.', { p: renderPct })}`;
}
function renderBegin() {
  rendering = true; renderCancel = false; renderPct = 0; lastBlob = null; if (step !== 5) goStep(5); updateCTA();
  $('#rec-badge').hidden = true; $('#rec-actions').hidden = true; setProgress(0, 0);
}
function renderEnd(result, t0) {
  rendering = false; renderWorker = null; $('#rec-badge').hidden = true; dirty = true;
  const status = $('#rec-status');
  if (result && result.ok) {
    lastBlob = new Blob([result.buffer], { type: 'video/mp4' }); lastName = `photo-travel-map-${isoToday()}.mp4`; lastExt = 'mp4';
    nlog(`render ok ${(lastBlob.size / 1048576).toFixed(1)}MB in ${((performance.now() - t0) / 1000).toFixed(1)}s`);
    const sec = ((performance.now() - t0) / 1000).toFixed(0);
    status.textContent = `${tr('영상이 준비됐어요')} · ${fmtTime(E.TL.total)} · ${(lastBlob.size / 1048576).toFixed(1)}MB`;
    const cta = $('#cta-primary'); if (cta) { cta.classList.remove('pop'); void cta.offsetWidth; cta.classList.add('pop'); }
    try { if (navigator.vibrate) navigator.vibrate(30); } catch (e) { /* ignore */ }
    const a = $('#btn-download'); a.href = URL.createObjectURL(lastBlob); a.download = lastName;
    if (window.__onVideoReady) { if (premium) window.__onVideoReady(lastBlob, lastName); }
    else { $('#rec-actions').hidden = false; const shareBtn = $('#btn-share'); const file = new File([lastBlob], lastName, { type: 'video/mp4' }); shareBtn.hidden = !(navigator.canShare && navigator.canShare({ files: [file] })); shareBtn.onclick = () => navigator.share({ files: [file], title: tr('우리 가족 여행') }).catch(() => {}); }
    if (window.__renderDone) window.__renderDone(lastBlob.size, performance.now() - t0);
  } else if (renderCancel) status.textContent = '';
  else { status.textContent = tr('영상을 만들지 못했어요: {msg}', { msg: (result && result.message) || tr('알 수 없는 오류') }); if (window.__renderDone) document.title = 'render error ' + ((result && result.message) || ''); }
  updateCTA();
}
async function renderVideo() {
  if (rendering || recording) return;
  const fps = E.TL.total > 150 ? 24 : 30; const t0 = performance.now();
  renderBegin();
  if (canWorker()) {
    try {
      const off = new OffscreenCanvas(16, 16);
      const w = new Worker(window.__workerURL); renderWorker = w;
      const result = await new Promise((resolve) => {
        w.onmessage = (e) => { const m = e.data; if (m.type === 'progress') setProgress(m.frac, performance.now() - t0); else if (m.type === 'done') resolve({ ok: true, buffer: m.buffer }); else if (m.type === 'error') resolve({ ok: false, message: m.message }); else if (m.type === 'log') console.log('[worker]', m.text); };
        w.onerror = (e) => resolve({ ok: false, message: (e.message || 'worker error') + (e.filename ? ` @${e.filename}:${e.lineno}` : '') });
        w.postMessage({ type: 'start', canvas: off, S: JSON.parse(JSON.stringify(S)), DATA, fps, platform: PLATFORM }, [off]);
        const tick = setInterval(() => { if (renderCancel) { clearInterval(tick); w.postMessage({ type: 'cancel' }); } if (!rendering) clearInterval(tick); }, 200);
      });
      try { w.terminate(); } catch (e) { /* ignore */ }
      if (result.ok || renderCancel) return renderEnd(result, t0);
      nlog('worker render failed, falling back to main thread: ' + result.message);
    } catch (e) { nlog('worker unavailable: ' + (e && e.message)); }
  }
  // 메인 스레드 대비책 (숨긴 캔버스에 그려서 화면 갱신 부담을 줄임)
  if (!canRender()) return renderEnd({ ok: false, message: tr('이 기기에서는 영상 인코딩을 지원하지 않아요.') }, t0);
  const hidden = document.createElement('canvas');
  const E2 = PhotoMapEngine.create({ canvas: hidden, S, DATA, platform: PLATFORM }); E2.rebuild();
  const w = E2.W - (E2.W % 2), h = E2.H - (E2.H % 2);
  let codec = null;
  for (const c of ['avc1.640028', 'avc1.64002a', 'avc1.4d0028', 'avc1.42001f']) { try { const r = await VideoEncoder.isConfigSupported({ codec: c, width: w, height: h, bitrate: 8e6, framerate: fps, avc: { format: 'avc' } }); if (r && r.supported) { codec = c; break; } } catch (e) { /* next */ } }
  if (!codec) return renderEnd({ ok: false, message: tr('H.264 인코더를 쓸 수 없어요.') }, t0);
  let encErr = null;
  const muxer = new Mp4Muxer.Muxer({ target: new Mp4Muxer.ArrayBufferTarget(), video: { codec: 'avc', width: w, height: h }, fastStart: 'in-memory', firstTimestampBehavior: 'offset' });
  const encoder = new VideoEncoder({ output: (chunk, meta) => muxer.addVideoChunk(chunk, meta), error: (e) => { encErr = e; } });
  encoder.configure({ codec, width: w, height: h, bitrate: Math.round(7e6 * Math.pow(E2.u, 1.4)), framerate: fps, avc: { format: 'avc' }, latencyMode: 'quality' });
  const total = Math.ceil(E2.TL.total * fps); let RT = 0; E2.snapCamera(E2.stateAt(0));
  for (let i = 0; i < total && !renderCancel && !encErr; i++) {
    RT = i / fps; const st = E2.stateAt(RT); if (i > 0) E2.stepCamera(st, 1 / fps);
    E2.draw(RT); let waited = 0; while (E2.tilesPending > 0 && waited < 2500 && !renderCancel) { await sleep(50); waited += 50; E2.draw(RT); }
    try { const frame = new VideoFrame(hidden, { timestamp: Math.round(i * 1e6 / fps), duration: Math.round(1e6 / fps) }); encoder.encode(frame, { keyFrame: i % (fps * 2) === 0 }); frame.close(); } catch (e) { encErr = e; break; }
    while (encoder.encodeQueueSize > 6) await sleep(4);
    setProgress(i / total, performance.now() - t0); await nextFrame();
  }
  let result = { ok: false, message: encErr && encErr.message };
  if (!renderCancel && !encErr) { try { await encoder.flush(); muxer.finalize(); result = { ok: true, buffer: muxer.target.buffer }; } catch (e) { result = { ok: false, message: e.message }; } }
  try { encoder.close(); } catch (e) { /* ignore */ }
  renderEnd(result, t0);
}

// ---------- 전체 여정 이미지(포스터) ----------
// 스타일(S.posterStyle)·비율(S.posterAspect)은 영상 설정과 별개. 'kakao' 는 카톡 프로필 배경용 1080×2340 + 위쪽 안전 영역 배치.
const posterS = (shortEdge) => Object.assign({}, S, { aspect: S.posterAspect || '9:16', shortEdge });
let previewE = null, previewTimer = null;
// 카톡 프로필 화면 안내 오버레이(미리보기에만) — 2026 카톡 프로필 실기기 스크린샷 기준:
// 위 ~13% 잘림, 9~25% 상단 버튼·위젯, 61% 아래 프로필 사진(왼쪽)·이름·상태 메시지·배경 편집 버튼, 아래 ~5% 잘림
function kakaoGuide(cv) {
  const c = cv.getContext('2d'); const W = cv.width, H = cv.height; const u = W / 1080;
  const rr = (x, y, w, h, r) => { c.beginPath(); c.roundRect(x, y, w, h, r); c.fill(); };
  c.save();
  c.fillStyle = 'rgba(25,31,40,0.55)'; c.fillRect(0, 0, W, H * 0.13); c.fillRect(0, H * 0.95, W, H * 0.05);      // 잘리는 부분
  c.fillStyle = 'rgba(25,31,40,0.32)'; c.fillRect(0, H * 0.13, W, H * 0.12); c.fillRect(0, H * 0.61, W, H * 0.34);   // 카톡 UI 가 겹치는 부분
  c.fillStyle = 'rgba(255,255,255,0.9)';
  rr(W * 0.04, H * 0.145, 140 * u, 76 * u, 38 * u); rr(W * 0.5 - 50 * u, H * 0.145, 100 * u, 76 * u, 38 * u); rr(W * 0.96 - 140 * u, H * 0.145, 140 * u, 76 * u, 38 * u);   // 취소 · 삭제 · 완료
  rr(W * 0.04, H * 0.20, W * 0.40, 56 * u, 28 * u); rr(W * 0.56, H * 0.20, W * 0.40, 56 * u, 28 * u);   // 음악 · TODAY 위젯
  rr(W * 0.04, H * 0.63, 150 * u, 150 * u, 40 * u);   // 프로필 사진 (왼쪽)
  rr(W * 0.04, H * 0.63 + 175 * u, 220 * u, 44 * u, 12 * u);   // 이름
  rr(W * 0.04, H * 0.63 + 240 * u, 360 * u, 30 * u, 12 * u);   // 상태 메시지
  rr(W * 0.5 - 120 * u, H * 0.87, 240 * u, 60 * u, 30 * u);   // 배경 편집 버튼
  c.font = `600 ${26 * u}px -apple-system, sans-serif`; c.textAlign = 'center'; c.fillStyle = 'rgba(255,255,255,0.9)';
  c.fillText(tr('카톡에서 잘리는 부분'), W / 2, H * 0.075); c.fillText(tr('카톡 버튼 · 위젯 자리'), W / 2, H * 0.30 - 8 * u);
  c.fillText(tr('프로필 사진 · 이름 · 상태 메시지 자리'), W / 2, H * 0.80);
  c.restore();
}
function posterPreview() {
  const cv = $('#poster-canvas'); if (!cv || step !== 5) return;
  clearTimeout(previewTimer);
  previewTimer = setTimeout(() => {
    try {
      const redraw = () => { previewE.snapCamera({ g: previewE.TL.segs[previewE.TL.segs.length - 1], p: 1 }); previewE.draw(previewE.TL.total, { poster: true }); };
      previewE = PhotoMapEngine.create({ canvas: cv, S: posterS(540), DATA, platform: PLATFORM, onTileLoaded: () => { clearTimeout(previewTimer); previewTimer = setTimeout(() => draw(), 120); } });
      const draw = () => { redraw(); if (S.posterAspect === 'kakao') kakaoGuide(cv); };
      previewE.rebuild(); draw();
      const note = $('#poster-note'); if (note) note.textContent = S.posterAspect === 'kakao' ? tr('어두운 부분은 카톡 프로필 화면에서 잘리거나 버튼·프로필 사진에 가려지는 자리예요. 저장되는 이미지엔 안 들어가요.') : `${previewE.W * 2}×${previewE.H * 2} PNG`;
    } catch (e) { nlog('poster preview error: ' + (e && e.message)); }
  }, 60);
}
async function savePoster() {
  const st = $('#poster-status'); st.textContent = tr('이미지를 만들고 있어요…');
  try {
    const hidden = document.createElement('canvas');
    const E2 = PhotoMapEngine.create({ canvas: hidden, S: posterS(Math.max(+S.shortEdge || 1080, 1080)), DATA, platform: PLATFORM }); E2.rebuild();
    E2.snapCamera({ g: E2.TL.segs[E2.TL.segs.length - 1], p: 1 });
    E2.draw(E2.TL.total, { poster: true });
    let waited = 0; while (E2.tilesPending > 0 && waited < 4000) { await sleep(60); waited += 60; E2.draw(E2.TL.total, { poster: true }); }
    const blob = await new Promise((res) => hidden.toBlob(res, 'image/png'));
    const name = `photo-travel-map-${S.posterAspect === 'kakao' ? 'kakao-' : ''}${isoToday()}.png`;
    if (window.__onVideoReady) { st.textContent = tr('공유 창에서 "이미지 저장"을 누르면 사진 앱에 저장돼요.'); window.__onVideoReady(blob, name); }
    else { const a = $('#btn-poster-download'); a.href = URL.createObjectURL(blob); a.download = name; a.hidden = false; st.textContent = `${tr('이미지가 준비됐어요')} (${E2.W}×${E2.H} · ${(blob.size / 1048576).toFixed(1)}MB)`; }
  } catch (e) { st.textContent = tr('이미지를 만들지 못했어요: {msg}', { msg: e.message }); }
}
$('#btn-poster').addEventListener('click', savePoster);
(() => { const st = $('#rec-status'); if (st && !st.textContent) st.textContent = tr('길이와 배속을 정하고 "영상 만들기"를 누르면 화면과 상관없이 뒤에서 만들어져요.'); })();

// ---------- 녹화 (WebCodecs 를 못 쓰는 환경의 대비책: 실시간) ----------
let recording = false, recorder = null, chunks = [], recStart = 0, recTimer = null, lastBlob = null, lastName = '', lastExt = 'webm';
function pickMime() {
  const c = ['video/mp4;codecs=avc1.42E01E', 'video/mp4;codecs=avc1', 'video/mp4', 'video/webm;codecs=vp9', 'video/webm;codecs=vp8', 'video/webm'];
  for (const m of c) { try { if (window.MediaRecorder && MediaRecorder.isTypeSupported(m)) return m; } catch (e) { /* ignore */ } } return '';
}
function startRecording() {
  const status = $('#rec-status');
  if (!window.MediaRecorder || !canvas.captureStream) { status.textContent = tr('이 환경에서는 화면 녹화를 지원하지 않아요. 최신 iOS 또는 Chrome/Safari 를 사용해 주세요.'); return; }
  const mime = pickMime(); if (!mime) { status.textContent = tr('지원되는 영상 형식이 없어요.'); return; }
  lastExt = mime.startsWith('video/mp4') ? 'mp4' : 'webm'; lastBlob = null;
  goStep(5); seekTo(0, true); draw(0);
  let stream; try { stream = canvas.captureStream(30); } catch (e) { status.textContent = tr('캔버스 캡처 실패: {msg}', { msg: e.message }); return; }
  chunks = [];
  try { recorder = new MediaRecorder(stream, { mimeType: mime, videoBitsPerSecond: Math.round(12e6 * Math.pow(u, 1.5)) }); }
  catch (e) { status.textContent = tr('녹화기를 만들지 못했어요: {msg}', { msg: e.message }); return; }
  recorder.ondataavailable = (e) => { if (e.data && e.data.size) chunks.push(e.data); };
  recorder.onstop = () => {
    lastBlob = new Blob(chunks, { type: mime }); const url = URL.createObjectURL(lastBlob);
    lastName = `photo-travel-map-${isoToday()}.${lastExt}`;
    const a = $('#btn-download'); a.href = url; a.download = lastName;
    status.textContent = `${tr('녹화 완료')} · ${(lastBlob.size / 1048576).toFixed(1)}MB (${lastExt.toUpperCase()})`;
    if (window.__onVideoReady) { status.textContent = tr('영상을 준비하고 있어요…'); window.__onVideoReady(lastBlob, lastName); }
    else { $('#rec-actions').hidden = false; const shareBtn = $('#btn-share'); const file = new File([lastBlob], lastName, { type: mime }); shareBtn.hidden = !(navigator.canShare && navigator.canShare({ files: [file] })); shareBtn.onclick = () => navigator.share({ files: [file], title: tr('우리 가족 여행') }).catch(() => {}); }
    stream.getTracks().forEach(t => t.stop()); updateCTA();
  };
  recording = true; recStart = performance.now();
  $('#rec-badge').hidden = false; $('#rec-text').textContent = tr('녹화 중'); $('#rec-actions').hidden = true; $('#btn-back').disabled = true;
  status.textContent = tr('이 기기에선 실시간으로 녹화해요. 끝나면 자동으로 저장 준비가 돼요 (약 {t}).', { t: fmtTime(E.TL.total) });
  recTimer = setInterval(() => { $('#rec-time').textContent = fmtTime((performance.now() - recStart) / 1000); }, 500);
  recorder.start(1000); setPlaying(true); updateCTA();
}
function stopRecording() {
  if (!recording) return; recording = false; clearInterval(recTimer);
  $('#rec-badge').hidden = true; $('#btn-back').disabled = false; setPlaying(false);
  try { recorder.stop(); } catch (e) { /* ignore */ }
  updateCTA();
}
const DEMO = !!(DATA.meta && DATA.meta.source === 'demo');
const postRescan = () => { try { localStorage.setItem('photo-map-rescan', '1'); } catch (e) { /* ignore */ } try { window.webkit.messageHandlers.rescan.postMessage({}); } catch (e) { nlog('rescan unavailable'); } };   // 플래그: 다음 부팅은 저장된 지도 대신 처음부터
if (NATIVE) { const b = $('#btn-rescan'); const sec = $('#native-section'); if (sec) sec.hidden = false; if (b) { b.hidden = false; b.addEventListener('click', postRescan); } }
// 데모 모드(샘플 여행): 배너 + '내 사진으로 만들기'. 일반 모드(앱): 설정 탭의 '샘플 여행으로 체험하기'
if (DEMO) {
  const bn = $('#demo-banner'); if (bn) bn.hidden = false;
  const ex = $('#btn-demo-exit'); if (ex) ex.addEventListener('click', postRescan);
  const rs = $('#btn-rescan'); if (rs) rs.hidden = true;
}


// ---------- 사진 출처: 기기 밖(Immich · Google Drive · OneDrive). 목록은 cloud.js, 합치기는 native.js ----------
const CS = window.CloudSources || null;
const SOURCES_ON = !!CS && (NATIVE || qp.has('sources'));
function closeSources() { $('#source-root').hidden = true; document.body.style.overflow = ''; }
function sourceRefresh() { try { localStorage.setItem('photo-map-sources.refresh', '1'); } catch (e) { /* ignore */ } postRescan(); }
function renderSources(msg) {
  const list = $('#source-list'); list.innerHTML = ''; $('#source-msg').textContent = msg || '';
  const dev = document.createElement('li'); dev.className = 'row';
  dev.innerHTML = `<span class="row-ico">${icon('phone')}</span><div class="row-body"><div class="row-title">${tr('이 기기의 사진')}</div><div class="row-desc">${tr('위치 있는 사진 {n}장', { n: fmtN(DATA.stats.photos) })}</div></div>`; list.appendChild(dev);
  const pc = document.createElement('li'); pc.className = 'row tap';
  pc.innerHTML = '<span class="row-ico">📁</span><div class="row-body"><div class="row-title">PC · 클라우드 사진·ZIP 가져오기</div><div class="row-desc">Drive·OneDrive·Dropbox 또는 휴대폰에 있는 사진 선택 · 원본 기기에 복사</div></div><span class="chev"></span>';
  pc.addEventListener('click', () => {
    if (window.NativeHost && typeof window.NativeHost.post === 'function') {
      window.NativeHost.post('diaryImportPc', '{}');
      const el = document.getElementById('source-msg');
      if (el) el.textContent = '파일 선택창에서 사진 또는 ZIP을 선택하세요. 클라우드 앱이 목록에 없다면 먼저 설치하고 로그인하세요.';
    } else {
      const el = document.getElementById('source-msg');
      if (el) el.textContent = 'Android APK에서만 파일 가져오기를 지원합니다.';
    }
  });
  list.appendChild(pc);
  for (const key of CS.providers) {
    const i = CS.info(key); const li = document.createElement('li'); li.className = 'row tap';
    const who = i.user || (i.server || '').replace(/^https?:\/\//, '');
    const desc = i.connected ? (i.error ? tr('오류: {msg}', { msg: i.error }) : `${i.enabled ? tr('연결됨') : tr('꺼짐')}${who ? ' · ' + who : ''}${i.count != null ? ' · ' + tr('사진 {n}장', { n: fmtN(i.count) }) : ''}`) : (i.configured ? tr('연결 안 됨') : (['gdrive','onedrive','dropbox'].includes(key) ? 'PC 사진·ZIP 직접 가져오기 가능 · 계정 자동 연동은 미설정' : tr('아직 연동 준비 중이에요.')));
    li.innerHTML = `<span class="row-ico">${icon(SRC_ICON[key] || 'cloud')}</span><div class="row-body"><div class="row-title">${i.name}</div><div class="row-desc">${desc}</div></div><span class="chev"></span>`;
    li.addEventListener('click', () => openSourceDetail(key));
    list.appendChild(li);
  }
}
const SRC_ICON = { immich: 'database', photoprism: 'prism', synology: 'folder', gdrive: 'drive', onedrive: 'cloud', dropbox: 'dropbox' };   // icons.js 이름
// 출처 상세: 시트에서 한 단계 들어간 전용 화면(뒤로 → 목록 시트로 복귀)
let sdKey = null;
function openSourceDetail(key) { sdKey = key; closeSources(); renderDetail(); const d = $('#source-detail'); d.hidden = false; d.scrollTop = 0; document.body.style.overflow = 'hidden'; }
function closeSourceDetail(reopen) { $('#source-detail').hidden = true; document.body.style.overflow = ''; sdKey = null; if (reopen) openSources(); }
function renderDetail(msg) {
  const key = sdKey; if (!key) return; const i = CS.info(key);
  $('#sd-top-title').textContent = i.name; $('#sd-icon').innerHTML = icon(SRC_ICON[key] || 'cloud'); $('#sd-title').textContent = i.name; $('#sd-msg').textContent = msg || '';
  $('#sd-desc').textContent = key === 'synology' ? tr('Synology Photos(DSM 7)의 개인·공용 공간에서 위치·시간 정보만 읽어요. 2단계 인증 계정은 아직 연결할 수 없어요.') : tr('{name}의 사진에서 위치·시간 정보만 읽어요. 원본은 내려받지 않아요.', { name: i.name });
  const c = $('#sd-content'); const p = $('#sd-primary'); p.disabled = false; p.className = 'btn primary'; p.onclick = null;
  if (i.connected) {
    const who = i.user || (i.server || '').replace(/^https?:\/\//, '');
    c.innerHTML = `<div class="sd-status"><b>${i.error ? tr('오류: {msg}', { msg: i.error }) : tr('연결됨')}</b><div class="row-desc">${[who, i.count != null ? tr('사진 {n}장', { n: fmtN(i.count) }) : ''].filter(Boolean).join(' · ')}</div></div>
      <ul class="rows"><li class="row switch-row"><div class="row-body"><div class="row-title">${tr('이 출처 사용')}</div><div class="row-desc">${tr('끄면 지도에서 이 출처의 사진을 빼요')}</div></div><span class="switch"><input type="checkbox" id="sd-enabled" ${i.enabled ? 'checked' : ''}><i></i></span></li></ul>
      <button type="button" class="btn secondary" id="sd-disconnect">${tr('연결 해제')}</button>`;
    $('#sd-enabled').addEventListener('change', (e) => { CS.setEnabled(key, e.target.checked); sourceRefresh(); });
    $('#sd-disconnect').onclick = () => { CS.disconnect(key); closeSourceDetail(true); sourceRefresh(); };
    p.textContent = tr('다시 읽기'); p.onclick = sourceRefresh;
    return;
  }
  if (!i.configured) {
    if (['gdrive','onedrive','dropbox'].includes(key)) {
      // Offline-safe fallback: use the system Files picker and the proven R25
      // per-file import rather than pretending an OAuth connection exists.
      // Third-party providers appear only if they expose Android DocumentsProvider.
      $('#sd-desc').textContent = i.name + '의 사진·ZIP을 휴대폰으로 가져올 수 있어요. 이 작업은 계정 전체 자동 동기화가 아닙니다.';
      c.innerHTML = `<p class="caption">① PC에서 ${i.name}에 사진(JPG·PNG·HEIC 등) 또는 ZIP 압축 파일을 업로드하세요.<br>② 아래 버튼을 눌러 Android 파일 선택창을 열고 왼쪽 메뉴에서 ${i.name}을 선택하세요. (앱 설치·로그인이 필요할 수 있어요.)<br>③ 사진·ZIP을 선택하면 휴대폰 <b>Pictures/FamilyJourney PC Imports</b>에 원본이 복사되고 일기의 사진 목록을 다시 읽어요.<br><br><b>용량 안내:</b> 원본을 기기에 복사하므로 사진만큼 저장 공간이 증가합니다. 사진·위치는 우리 앱 자체 서버에 전송하지 않아요.<br><b>자동 연동:</b> 이 서비스의 전체 계정 스캔은 별도의 OAuth 개발자 등록이 필요해 아직 제공하지 않습니다.</p>`;
      p.textContent = '사진·ZIP 파일 선택해서 가져오기';
      p.disabled = false;
      p.onclick = () => {
        $('#sd-msg').textContent = '파일 선택창에서 Google Drive·OneDrive·Dropbox 또는 기기 파일을 선택하세요. 사진과 ZIP만 가져올 수 있어요.';
        if (window.NativeHost && typeof window.NativeHost.post === 'function') {
          window.NativeHost.post('diaryImportPc', '{}');
        } else {
          $('#sd-msg').textContent = 'Android용 우리 가족 여행 앱에서만 파일 선택을 지원해요.';
        }
      };
      return;
    }
    c.innerHTML = `<p class="caption">${tr('이 출처는 개발자 설정(OAuth 클라이언트 ID)이 끝나면 쓸 수 있어요.')}</p>`; p.textContent = tr('아직 연동 준비 중이에요.'); p.disabled = true; return;
  }
  if (i.auth === 'immich') {
    c.innerHTML = `<div class="field"><label>${tr('서버 주소')}</label><input type="url" id="src-server" placeholder="https://immich.example.com" autocapitalize="none" autocorrect="off" inputmode="url"></div>
      <div class="field"><label>${tr('API 키')}</label><input type="text" id="src-key" placeholder="${tr('Immich › 계정 설정 › API 키')}" autocapitalize="none" autocorrect="off"></div>
      <p class="caption">${tr('API 키 대신 이메일·비밀번호로 로그인해도 돼요.')}</p>
      <div class="field"><label>${tr('이메일')}</label><input type="email" id="src-email" autocapitalize="none" inputmode="email"></div>
      <div class="field"><label>${tr('비밀번호')}</label><input type="password" id="src-pw"></div>`;
    p.textContent = tr('연결하기'); p.onclick = () => doConnect(key, { server: $('#src-server').value, apiKey: $('#src-key').value, email: $('#src-email').value, password: $('#src-pw').value });
  } else if (i.auth === 'userpass') {
    const ph = key === 'synology' ? 'https://nas.example.com:5001' : 'https://photos.example.com';
    c.innerHTML = `<div class="field"><label>${tr('서버 주소')}</label><input type="url" id="src-server" placeholder="${ph}" autocapitalize="none" autocorrect="off" inputmode="url"></div>
      <div class="field"><label>${tr('사용자 이름')}</label><input type="text" id="src-user" autocapitalize="none" autocorrect="off"></div>
      <div class="field"><label>${tr('비밀번호')}</label><input type="password" id="src-pw"></div>
      ${i.userOptional ? `<p class="caption">${tr('공개 서버면 사용자 이름과 비밀번호를 비워 두세요.')}</p>` : ''}`;
    p.textContent = tr('연결하기'); p.onclick = () => doConnect(key, { server: $('#src-server').value, user: $('#src-user').value, password: $('#src-pw').value });
  } else {
    c.innerHTML = `<p class="caption">${tr('{name} 계정으로 로그인하면 사진의 위치·시간 정보만 읽어요. 원본은 내려받지 않아요.', { name: i.name })}</p>`;
    p.textContent = tr('{name} 연결하기', { name: i.name }); p.onclick = () => doConnect(key, {});
  }
}
async function doConnect(key, input) {
  const p = $('#sd-primary'); p.disabled = true; $('#sd-msg').textContent = tr('연결하는 중…');
  const r = await CS.connect(key, input); p.disabled = false;
  if (r.error) { $('#sd-msg').textContent = r.error; return; }
  renderDetail(tr('연결됐어요. 사진 목록을 읽어 올게요.')); setTimeout(sourceRefresh, 800);
}
function openSources() { renderSources(); $('#source-root').hidden = false; document.body.style.overflow = 'hidden'; }
if (SOURCES_ON) { $$('#btn-sources, #set-sources').forEach(el => { el.hidden = false; el.addEventListener('click', openSources); }); $('#source-dim').addEventListener('click', closeSources); $('#source-close').addEventListener('click', closeSources); $('#source-back').addEventListener('click', () => closeSourceDetail(true)); }

// ---------- 나의 지도(홈): 두 번째 실행부터. 실행 기록(로그)을 저장해 두고 지난번과 비교해 새로 밝힌 곳을 보여준다 ----------
const LOG_KEY = 'photo-map-log.v1';
function loadLog() { try { const j = JSON.parse(localStorage.getItem(LOG_KEY) || 'null'); return j && j.v === 1 && j.zones ? j : null; } catch (e) { return null; } }
function saveLog(l) { try { localStorage.setItem(LOG_KEY, JSON.stringify(l)); } catch (e) { /* ignore */ } }
const day10 = (s) => (s || '').slice(0, 10);
/** 정류지(stop)를 '곳(zone)' 단위로 합친다: 같은 나라·같은 이름 = 같은 곳. 방문 횟수는 여행 수로 센다 */
function computeZones() {
  const map = new Map(); let homeDays = 0, homePhotos = 0, homeBig = 0, homeRep = null; const homeIds = [], homeStopIdx = [], homePts = [];
  // 사진 ID 가 없는 데이터(맥 파이프라인·샘플 여행)는 자리표시 썸네일용 가짜 ID ('ph:정류지:번호')
  const idsOf = (s, idx) => (s.ids && s.ids.length) ? s.ids : (!NATIVE || DEMO ? Array.from({ length: Math.min(s.n, 40) }, (_, k) => `ph:${idx}:${k}`) : []);
  const addIds = (arr, s, idx, cap) => { for (const id of idsOf(s, idx)) { if (arr.length >= cap) break; arr.push(id); } };
  DATA.stops.forEach((s, idx) => {
    if (s.home) { homeDays += s.days; homePhotos += s.n; homeStopIdx.push(idx); addIds(homeIds, s, idx, 20000); const hid = idsOf(s, idx); if (s.n > homeBig && hid.length) { homeBig = s.n; homeRep = hid[Math.floor(hid.length / 2)]; } if (s.pts) for (const q of s.pts) { if (homePts.length >= 5000) break; homePts.push([q[1], q[0]]); } return; }
    const key = `${s.cc || ''}|${s.name}`;
    let z = map.get(key);
    if (!z) { z = { key, name: s.name, cc: s.cc, flag: '', country: s.country, admin1: s.admin1, sx: 0, sy: 0, w: 0, n: 0, days: 0, tripSet: new Set(), first: day10(s.start), last: day10(s.end), minor: true, ids: [], pts: [], stopIdx: [], big: 0, rep: null }; map.set(key, z); }
    z.sx += s.lon * s.n; z.sy += s.lat * s.n; z.w += s.n; z.n += s.n; z.days += s.days; if (s.trip) z.tripSet.add(s.trip); if (!s.minor) z.minor = false;
    if (day10(s.start) < z.first) z.first = day10(s.start); if (day10(s.end) > z.last) z.last = day10(s.end);
    z.stopIdx.push(idx); addIds(z.ids, s, idx, 20000);
    if (s.pts) for (const p of s.pts) { if (z.pts.length >= 8000) break; z.pts.push([p[1], p[0]]); }
    const ids = idsOf(s, idx); if (s.n > z.big && ids.length) { z.big = s.n; z.rep = ids[Math.floor(ids.length / 2)]; }   // 대표 사진: 가장 큰 방문의 한가운데 사진
  });
  const zones = [...map.values()].map(z => { z.lon = z.sx / z.w; z.lat = z.sy / z.w; z.ll = [z.lon, z.lat]; z.trips = z.tripSet.size || 1; delete z.tripSet; z.score = z.trips * 4 + z.days * 1.5 + Math.log2(z.n + 1); return z; });
  const home = DATA.home ? { ll: [DATA.home.lon, DATA.home.lat], name: DATA.home.name, cc: DATA.home.cc, country: DATA.home.country, days: homeDays, n: homePhotos, ids: homeIds, stopIdx: homeStopIdx, rep: homeRep, pts: homePts } : null;
  const pts = []; for (const z of zones) { for (const p of z.pts) { if (pts.length >= 80000) break; pts.push(p); } }
  const homeCC = home ? home.cc : (zones[0] && zones[0].cc);
  // 제2·제3의 고향: 집 밖에서 자주 간 곳 — 여행 3회 이상, 또는 2회 이상이면서 5일 이상 머문 곳
  const qualifies = (z) => z.trips >= 3 || (z.trips >= 2 && z.days >= 5);
  const ranked = zones.slice().sort((a, b) => b.score - a.score);
  const hometowns = ranked.filter(qualifies).slice(0, 2); hometowns.forEach((z, i) => { z.tier = i + 2; });
  const candidates = ranked.filter(z => !qualifies(z)).slice(0, 2);   // 아직 고향은 아니지만 가까운 곳
  return { zones, ranked, home, homeCC, hometowns, candidates, pts, countries: new Set(zones.map(z => z.cc).filter(Boolean).concat(homeCC ? [homeCC] : [])).size };
}
const Z = computeZones();
// ---- 다녀온 지역 색칠: 대한민국은 시·군·구 250개(data/kr-sigungu.js), 그 외 나라는 주·도·현(Natural Earth admin-1, data/world-admin1.js, 4,300여 개).
//      사진 찍은 자리(pts)가 들어 있는 구역을 칠한다. admin-1 은 나라별로 필요할 때만 features 로 풀어 쓴다(4천 개 전부 풀면 부팅이 느려짐) ----
const SIG = (() => { try { const t = window.KR_SIGUNGU; if (!t || !window.topojson) return []; const fs = topojson.feature(t, t.objects.sigungu).features; for (const f of fs) { f.bb = d3.geoBounds(f); } return fs; } catch (e) { nlog('sigungu load error ' + (e && e.message)); return []; } })();
function fixRings(f) {   // 뒤집힌 폴리곤(면적 > 반구): 바깥 고리 방향을 반대로. 그래도 반구를 넘으면 고리별로 다시 판정
  const g = f.geometry; if (!g) return;
  const flip = (poly) => poly.map(r => r.slice().reverse());
  if (g.type === 'Polygon') g.coordinates = flip(g.coordinates);
  else if (g.type === 'MultiPolygon') g.coordinates = g.coordinates.map(p => (d3.geoArea({ type: 'Polygon', coordinates: p }) > 2 * Math.PI ? flip(p) : p));
  if (d3.geoArea(f) > 2 * Math.PI && g.type === 'Polygon') g.coordinates = g.coordinates.map((r, i) => (i === 0 ? r : r.slice().reverse()));   // 구멍 고리만 뒤집힌 경우
}
const ADM = (() => {
  const t = window.WORLD_ADMIN1; if (!t || !window.topojson) return { byCC: () => [], total: () => 0 };
  const geoms = t.objects.admin1.geometries; const cache = new Map();
  return {
    byCC(cc) { if (!cc) return []; let fs = cache.get(cc); if (fs) return fs; try { fs = topojson.feature(t, { type: 'GeometryCollection', geometries: geoms.filter(g => g.properties.cc === cc) }).features; for (const f of fs) { if (d3.geoArea(f) > 2 * Math.PI) fixRings(f); f.bb = d3.geoBounds(f); f.inv = false; } /* 단순화로 뒤집힌(구면 면적이 반구 초과) 폴리곤은 고리 방향을 되돌린다 — 그대로 그리면 지구 전체가 칠해져 지도가 온통 파래진다 */ } catch (e) { nlog('admin1 error ' + (e && e.message)); fs = []; } cache.set(cc, fs); return fs; },
    total(cc) { return geoms.reduce((a, g) => a + (g.properties.cc === cc ? 1 : 0), 0); },
  };
})();
function computeRegions() {
  const byCode = new Map(); const homeCC = Z.homeCC;
  const inBB = (f, p) => p[0] >= f.bb[0][0] && p[0] <= f.bb[1][0] && p[1] >= f.bb[0][1] && p[1] <= f.bb[1][1];
  const featsFor = (cc) => (cc === 'KR' ? SIG : ADM.byCC(cc));
  const mark = (f, cc, tag) => { const code = f.properties.code; let r = byCode.get(code); if (!r) { r = { code, cc, name: f.properties.name, f, n: 0, zones: new Set() }; byCode.set(code, r); } r.n++; if (tag) r.zones.add(tag); return true; };
  const hit = (p, cc, tag) => {
    if (!cc) return false; const fs = featsFor(cc); let near = null, nd = Infinity;
    for (const f of fs) { if (!inBB(f, p)) continue; if (d3.geoContains(f, p) !== !!f.inv) return mark(f, cc, tag); }
    // 해안 도시는 단순화된 경계 밖(바다)에 떨어질 수 있다 → 그 나라 안에서 가장 가까운 구역(경계 상자 중심 기준, 3도 이내)으로
    for (const f of fs) { const dx = Math.max(f.bb[0][0] - p[0], 0, p[0] - f.bb[1][0]), dy = Math.max(f.bb[0][1] - p[1], 0, p[1] - f.bb[1][1]); const d = Math.hypot(dx, dy); if (d < nd) { nd = d; near = f; } }   // 경계 상자까지의 거리
    return near && nd < 0.3 ? mark(near, cc, tag) : false;   // 약 30km 안쪽만 (예전 3도=300km 는 엉뚱한 지역을 칠했음)
  };
  for (const z of Z.zones) { z.regionHit = false; for (const p of z.pts) if (hit(p, z.cc, z.key)) z.regionHit = true; }
  if (Z.home) for (const p of Z.home.pts) hit(p, Z.home.cc, 'home');
  const list = [...byCode.values()]; const maxN = Math.max(1, ...list.map(r => r.n));
  const fill = list.map(r => ({ f: r.f, a: 0.62 + 0.33 * Math.sqrt(r.n / maxN), code: r.code, cc: r.cc, name: r.name, n: r.n }));   // 사진이 많을수록 진하게 (0.62~0.95)
  const homeList = list.filter(r => r.cc === homeCC);
  return { fill, count: homeList.length, total: homeCC === 'KR' ? SIG.length : ADM.total(homeCC), abroad: list.length - homeList.length, byCode, homeKR: homeCC === 'KR' };
}
const REG = computeRegions();
const today = isoToday(); const nowIso = new Date().toISOString();
let LOG = loadLog(); const hadLog = !!LOG;
let newKeys = hadLog ? Z.zones.filter(z => !LOG.zones[z.key]).map(z => z.key) : [];
if (!DEMO) {   // 샘플 여행은 기록하지 않는다
  if (!LOG) LOG = { v: 1, created: nowIso, visits: [], zones: {} };
  for (const z of Z.zones) if (!LOG.zones[z.key]) LOG.zones[z.key] = { name: z.name, cc: z.cc, first: z.first, seen: today, initial: !hadLog };
  const last = LOG.visits[LOG.visits.length - 1];
  const v = { at: nowIso, day: today, zones: Z.zones.length, countries: Z.countries, photos: DATA.stats.photos, newKeys, initial: !hadLog };
  if (last && last.day === today) Object.assign(last, v, { newKeys: [...new Set((last.newKeys || []).concat(newKeys))], initial: last.initial });
  else LOG.visits.push(v);
  if (LOG.visits.length > 60) LOG.visits.splice(0, LOG.visits.length - 60);
  saveLog(LOG);
}
// 최근 7일 안의 실행에서 새로 밝힌 곳(첫 실행 제외). ?home=1 미리보기(기록 없음)는 가장 최근에 처음 간 3곳을 새로 밝힌 곳으로 보여준다
const recentNewKeys = new Set();
if (LOG) { const cut = Date.now() - 7 * 864e5; for (const v of LOG.visits) if (!v.initial && Date.parse(v.at) >= cut) (v.newKeys || []).forEach(k => recentNewKeys.add(k)); }
if (!hadLog && qp.has('home')) Z.zones.slice().sort((a, b) => b.first.localeCompare(a.first)).slice(0, 3).forEach(z => recentNewKeys.add(z.key));
for (const z of Z.zones) z.isNew = recentNewKeys.has(z.key);
const recentNew = Z.zones.filter(z => z.isNew).sort((a, b) => b.first.localeCompare(a.first));

let HE = null, homeRegion = null, homeTimer = null, homeDrawn = false;
const OWN_LABELS = !!(I18N && I18N.lang !== 'en');   // 한국어·일본어: 영문 라벨 타일 대신 앱 언어 지명을 직접 그린다
let baseLabels = null;
function getBaseLabels() {   // 나라(도시 데이터로 국가코드 추정) · 도시(인구순) · 다녀온 나라의 주/도 · 대한민국 시군구
  if (baseLabels) return baseLabels; const L = []; const lang = I18N ? I18N.lang : 'ko';
  const cities = (window.CITIES || []).filter(c => c[5] >= 60000).sort((a, b) => b[5] - a[5]);
  try {
    const feats = topojson.feature(window.WORLD_50, window.WORLD_50.objects.countries).features;
    for (const f of feats) { const bb = d3.geoBounds(f); let cc = null; for (const c of cities) { const p = [c[3], c[2]]; if (p[0] < bb[0][0] || p[0] > bb[1][0] || p[1] < bb[0][1] || p[1] > bb[1][1]) continue; if (d3.geoContains(f, p)) { cc = c[4]; break; } } if (!cc) continue; const area = d3.geoArea(f); L.push({ ll: d3.geoCentroid(f), text: countryName(cc), pri: 0, minZ: area > 0.03 ? 0 : (area > 0.006 ? 1.4 : 2.6), maxZ: area > 0.03 ? 4.2 : 6, w: area }); }
  } catch (e) { nlog('country labels error ' + (e && e.message)); }
  for (const c of cities) { const [en, ko, lat, lon, cc, pop] = c; if (lang === 'ko' && !ko && pop < 1e6) continue; let text = (lang === 'ko' && ko) ? ko : en; if (lang === 'ko' && text.length >= 3 && text.endsWith('시')) text = text.slice(0, -1); L.push({ ll: [lon, lat], text, pri: 1, minZ: pop >= 8e6 ? 1.2 : pop >= 3e6 ? 2.2 : pop >= 1e6 ? 3.4 : pop >= 3e5 ? 4.8 : pop >= 1.5e5 ? 6 : 8, maxZ: 13, w: pop }); }
  const ccs = new Set(Z.zones.map(z => z.cc).filter(Boolean)); if (Z.homeCC) ccs.add(Z.homeCC);
  for (const cc of ccs) { if (cc === 'KR') continue; for (const f of ADM.byCC(cc)) L.push({ ll: d3.geoCentroid(f), text: f.properties[lang] || f.properties.name, pri: 2, minZ: 5.2, maxZ: 13, w: d3.geoArea(f) }); }
  const cityNames = new Set(L.filter(x => x.pri === 1).map(x => x.text));   // '양산시'(시군구) 와 '양산'(도시) 중복 방지
  for (const f of SIG) { const nm = f.properties.name; const base = nm.length >= 3 ? nm.replace(/[시군]$/, '') : nm; if (cityNames.has(base) || cityNames.has(nm)) continue; L.push({ ll: d3.geoCentroid(f), text: nm, pri: 3, minZ: 7.4, maxZ: 14, w: d3.geoArea(f) }); }
  L.sort((a, b) => (a.pri - b.pri) || (b.w - a.w)); baseLabels = L; return L;
}
// 확대한 지도의 사진 자리: 화면을 격자로 나눠 셀마다 대표 사진 하나 + 장수
const spotImgs = new Map(); const spotPending = new Set();
function computeSpots(E2) {
  const ph = DATA.photos; if (!ph || !ph.length || E2.cam.z < 7.0) return null;
  const cell = 84 * (E2.S.pxRatio > 0 ? E2.S.pxRatio : 1); const W = E2.W, H = E2.H; const cells = new Map();
  for (const p of ph) { const q = E2.llToScreen([p[2], p[1]]); if (!q || q[0] < -cell || q[1] < -cell || q[0] > W + cell || q[1] > H + cell) continue; const cx = Math.floor(q[0] / cell), cy = Math.floor(q[1] / cell); const k = cx + ',' + cy; let c = cells.get(k); if (!c) { c = { ids: [], n: 0, best: null, bd: 1e9, cx: (cx + 0.5) * cell, cy: (cy + 0.5) * cell }; cells.set(k, c); } c.n++; c.ids.push(p[0]); const d = Math.hypot(q[0] - c.cx, q[1] - c.cy); if (d < c.bd) { c.bd = d; c.best = p; } }
  return [...cells.values()].sort((a, b) => b.n - a.n).slice(0, 40).map(c => ({ ll: [c.best[2], c.best[1]], id: c.best[0], n: c.n, ids: c.ids }));
}
async function loadSpotThumbs(spots, redraw) {
  const need = spots.filter(s => !spotImgs.has(s.id) && !spotPending.has(s.id)).slice(0, 24); if (!need.length) return;
  need.forEach(s => spotPending.add(s.id)); const res = await getThumbs(need.map(s => s.id), 200); let pending = 0;
  for (const s of need) { const d = res.get(s.id); if (!d) { spotPending.delete(s.id); continue; } const img = new Image(); pending++; img.onload = () => { spotImgs.set(s.id, img); spotPending.delete(s.id); if (--pending % 4 === 0 || pending === 0) redraw(); }; img.onerror = () => { pending--; spotPending.delete(s.id); }; img.src = d; }
}
let lastSpots = null;
const domestic = () => Z.zones.filter(z => z.cc === Z.homeCC), abroad = () => Z.zones.filter(z => z.cc !== Z.homeCC);
// ---- 사진 썸네일 (네이티브가 기기 안에서 만들어 줌. 웹/샘플은 자리표시 그림) ----
const thumbCache = new Map(); const markerImgs = new Map(); let markerLoaded = false;
function placeholderThumb(id, size) {
  const cv = document.createElement('canvas'); cv.width = cv.height = size; const c = cv.getContext('2d');
  let h = 0; for (const ch of id) h = (h * 31 + ch.charCodeAt(0)) >>> 0; const hue = h % 360;
  const g = c.createLinearGradient(0, 0, size, size); g.addColorStop(0, `hsl(${hue},70%,74%)`); g.addColorStop(1, `hsl(${(hue + 50) % 360},70%,56%)`); c.fillStyle = g; c.fillRect(0, 0, size, size);
  c.fillStyle = 'rgba(255,255,255,.85)'; c.font = `600 ${Math.round(size / 7)}px -apple-system, sans-serif`; c.textAlign = 'center'; c.fillText(tr('샘플'), size / 2, size / 2 + size / 20);
  return cv.toDataURL('image/jpeg', 0.8);
}
async function getThumbs(ids, size) {
  const out = new Map(); const need = [];
  for (const id of ids) { const k = size + ':' + id; if (thumbCache.has(k)) out.set(id, thumbCache.get(k)); else need.push(id); }
  if (!need.length) return out;
  if (!window.__requestThumbs || need[0].startsWith('ph:')) { for (const id of need) { const d = placeholderThumb(id, Math.min(size, 256)); thumbCache.set(size + ':' + id, d); out.set(id, d); } return out; }
  for (let i = 0; i < need.length; i += 40) {
    const part = need.slice(i, i + 40); let res = new Map();
    try { res = await window.__requestThumbs(part, size); } catch (e) { nlog('thumbs error ' + (e && e.message)); }
    for (const id of part) { const d = res.get(id) || null; thumbCache.set(size + ':' + id, d); out.set(id, d); }
  }
  return out;
}
async function loadCardThumbs() {   // 홈 카드 배경 사진 (data-rep)
  const els = $$('#pages [data-rep]'); const ids = [...new Set(els.map(e => e.dataset.rep).filter(Boolean))]; if (!ids.length) return;
  const res = await getThumbs(ids, 400);
  for (const e of els) { const d = res.get(e.dataset.rep); if (d) { e.style.backgroundImage = `url(${d})`; e.classList.add('photo'); } }
}
async function loadMarkerThumbs() {   // 지도 마커용 대표 사진
  if (markerLoaded) return; markerLoaded = true;
  const zs = Z.zones.filter(z => z.rep); if (!zs.length) return;
  const res = await getThumbs(zs.map(z => z.rep), 160); let pending = 0;
  for (const z of zs) { const d = res.get(z.rep); if (!d) continue; const img = new Image(); pending++; img.onload = () => { markerImgs.set(z.key, img); if (--pending % 6 === 0 || pending === 0) { homeDraw(); mapRedraw(); } }; img.onerror = () => { pending--; }; img.src = d; }
}
const territoryOpts = (labels, maxThumbs) => ({ zones: Z.zones, home: Z.home, homeCC: Z.homeCC, labels, pts: Z.pts, thumbs: markerImgs, fill: REG.fill, outline: SIG, fog: !REG.fill.length, wish: wishMarkers(), countries: [...new Set(abroad().map(z => z.cc).filter(Boolean))], glow: abroad().filter(z => !z.regionHit), /* 해외: 나라 전체를 아주 연하게 + 주·도 색칠, 구역을 못 찾은 곳만 글로우 */ thumbKeys: maxThumbs ? new Set(Z.ranked.slice(0, maxThumbs).map(z => z.key).concat(Z.zones.filter(z => z.isNew).map(z => z.key))) : null });
function homeDraw() {
  if (!HE) return;
  HE.draw(0, { territory: Object.assign(territoryOpts(homeRegion === 'world' ? 6 : 8, homeRegion === 'world' ? 8 : 10), { baseLabels: OWN_LABELS ? getBaseLabels() : null }) });   // 홈 지도: 자주 간 10곳 + 새로 밝힌 곳만 사진 마커
}
// ---- 전체화면 지도: 핀치 확대·이동, 두 번 탭 확대, 장소 탭 → 사진 ----
let ME = null, mapOpen = false, mapRaf = 0, mapRegion = null;
function mapSize() { const r = $('#map-root').getBoundingClientRect(); const dpr = Math.min(window.devicePixelRatio || 1, 2); return { w: Math.max(320, Math.round((r.width || innerWidth) * dpr)), h: Math.max(320, Math.round((r.height || innerHeight) * dpr)) }; }
const MAPOPT = Object.assign({ thumbs: true, labels: true, dots: true }, (() => { try { return JSON.parse(localStorage.getItem('photo-map-mapopts.v1') || '{}'); } catch (e) { return {}; } })());   // 전체화면 지도 오른쪽 아래 토글
function mapDraw() {
  mapRaf = 0; if (!ME || !mapOpen) return;
  lastSpots = MAPOPT.thumbs ? computeSpots(ME) : null; if (lastSpots) loadSpotThumbs(lastSpots, mapRedraw);
  ME.draw(0, { territory: Object.assign(territoryOpts(MAPOPT.labels ? 10 : 0), { thumbs: MAPOPT.thumbs ? markerImgs : null, noLabels: !MAPOPT.labels, pts: MAPOPT.dots ? Z.pts : [], spots: lastSpots, spotImgs, baseLabels: OWN_LABELS ? getBaseLabels() : null, thumbKeys: lastSpots ? new Set() : null }) });   // 확대해서 사진 자리가 보이면 곳 마커의 큰 썸네일은 숨긴다
}
$$('#map-toggles .map-toggle').forEach(b => { const k = b.dataset.opt; b.classList.toggle('active', !!MAPOPT[k]); b.addEventListener('click', () => { MAPOPT[k] = !MAPOPT[k]; try { localStorage.setItem('photo-map-mapopts.v1', JSON.stringify(MAPOPT)); } catch (e) { /* ignore */ } b.classList.toggle('active', !!MAPOPT[k]); mapRedraw(); }); });
function mapRedraw() { if (ME && mapOpen && !mapRaf) mapRaf = requestAnimationFrame(mapDraw); }
function openMap() {
  $('#map-root').hidden = false; document.body.style.overflow = 'hidden'; mapOpen = true;
  if (!ME) {
    const ms = Object.assign({}, S, { selection: 'all', preset: 'all', from: '', to: '', includeShort: true, mapMode: 'flat', aspect: '9:16', shortEdge: 1080, watermark: false, photoDots: true, camera: 'fixed', tiles: S.tiles === 'none' ? 'none' : S.tiles, stage: mapSize(), pxRatio: Math.min(window.devicePixelRatio || 1, 2), ownLabels: OWN_LABELS });
    ME = PhotoMapEngine.create({ canvas: $('#map-canvas'), S: ms, DATA, platform: PLATFORM, onTileLoaded: mapRedraw });
    ME.rebuild();
    const rg = $('#map-region'); rg.innerHTML = '';
    for (const [v, l] of [['home', (Z.home && Z.home.country) || tr('국내')], ['world', tr('전체|world')]]) {
      if ((v === 'home' && !domestic().length) || (v === 'world' && !abroad().length)) continue;
      const b = document.createElement('button'); b.type = 'button'; b.className = 'chip'; b.dataset.v = v; b.textContent = l; b.addEventListener('click', () => mapFit(v)); rg.appendChild(b);
    }
    attachMapGestures($('#map-canvas'), ME, mapRedraw, mapTap);
    window.addEventListener('resize', () => { if (!ME || !mapOpen) return; ME.S.stage = mapSize(); ME.rebuild(); mapRedraw(); });
    loadMarkerThumbs();
  } else { const sz = mapSize(); if (sz.w !== ME.W || sz.h !== ME.H) { ME.S.stage = sz; ME.rebuild(); } }
  mapFit(mapRegion || homeRegion || (domestic().length ? 'home' : 'world'));
}
function mapFit(region) {
  mapRegion = region; $$('#map-region .chip').forEach(b => b.classList.toggle('active', b.dataset.v === region));
  const world = region === 'world'; const pts = (world ? Z.zones : domestic()).map(z => z.ll); if (Z.home && (world || Z.home.cc === Z.homeCC)) pts.push(Z.home.ll);
  const c = ME.fitPoints(pts, world ? 0.15 : 0.2); c.z = Math.min(c.z, 7.6); ME.cam.lon = c.lon; ME.cam.lat = c.lat; ME.cam.z = c.z; mapRedraw();
}
function closeMap() { $('#map-root').hidden = true; document.body.style.overflow = ''; mapOpen = false; }
function mapTap(x, y) {   // 캔버스 픽셀 → 사진 자리 → 가장 가까운 곳 → 색칠된 지역
  const lim = 30 * (ME.W / Math.max(1, $('#map-canvas').getBoundingClientRect().width)); let best = null, bd = 1e9;
  if (lastSpots) { let sb = null, sd = 1e9; for (const sp of lastSpots) { const q = ME.llToScreen(sp.ll); if (!q) continue; const d = Math.hypot(q[0] - x, q[1] - y); if (d < sd) { sd = d; sb = sp; } } if (sb && sd <= lim * 0.8) { openSpot(sb); return; } }
  for (const z of Z.zones) { const q = ME.llToScreen(z.ll); if (!q) continue; const d = Math.hypot(q[0] - x, q[1] - y); if (d < bd) { bd = d; best = z; } }
  if (Z.home) { const q = ME.llToScreen(Z.home.ll); if (q) { const d = Math.hypot(q[0] - x, q[1] - y); if (d < bd) { bd = d; best = 'home'; } } }
  if (best && bd <= lim) { openPlace(best === 'home' ? homeAsZone() : best); return; }
  const ll = ME.screenToLL(x, y); const r = ll && regionAt(ll); if (r) openRegion(r);   // 색칠된 지역을 누르면 그 지역에서 찍은 사진
}
function openSpot(sp) {   // 사진 자리 격자 하나 → 그 자리 사진들
  const r = regionAt(sp.ll); let near = null, nd = 1e9; for (const z of Z.zones) { const d = hav(sp.ll, z.ll); if (d < nd) { nd = d; near = z; } }
  const name = r ? r.name : (near && nd < 60 ? near.name : (Z.home && hav(sp.ll, Z.home.ll) < 60 ? Z.home.name : tr('사진 찍은 자리')));
  openPlace({ key: 'spot:' + sp.id, name, flag: '', icon: 'pin', trips: 1, days: 0, n: sp.ids.length, ids: sp.ids.slice(), stopIdx: [], first: '', isSpot: true });
}
function regionAt(p) {   // 밝힌 지역(REG.fill) 중 지점을 포함하는 것
  for (const r of REG.fill) { const f = r.f; if (!f.bb || p[0] < f.bb[0][0] || p[0] > f.bb[1][0] || p[1] < f.bb[0][1] || p[1] > f.bb[1][1]) continue; if (d3.geoContains(f, p) !== !!f.inv) return r; }
  return null;
}
function openRegion(r) {   // 지역 → 그 지역 안에 중심이 있는 정류지들의 사진 (없으면 표본 지점이 걸치는 정류지)
  const info = REG.byCode.get(r.code); const inside = (p) => d3.geoContains(r.f, p) !== !!r.f.inv;
  const idxs = new Set(); for (const key of (info ? info.zones : [])) { const src = key === 'home' ? Z.home : Z.zones.find(z => z.key === key); for (const i of ((src && src.stopIdx) || [])) idxs.add(i); }
  let stops = [...idxs].map(i => [i, DATA.stops[i]]).filter(([, s]) => inside([s.lon, s.lat]));
  if (!stops.length) stops = [...idxs].map(i => [i, DATA.stops[i]]).filter(([, s]) => (s.pts || []).some(q => inside([q[1], q[0]])));
  if (!stops.length) return;
  const ids = []; const trips = new Set(); let days = 0, first = null;
  for (const [i, s] of stops) { for (const id of ((s.ids && s.ids.length) ? s.ids : (!NATIVE || DEMO ? Array.from({ length: Math.min(s.n, 40) }, (_, k) => `ph:${i}:${k}`) : []))) { if (ids.length >= 20000) break; ids.push(id); } if (s.trip) trips.add(s.trip); days += s.days || 0; const d = day10(s.start); if (!first || d < first) first = d; }
  openPlace({ key: 'region:' + r.code, name: r.name, cc: r.cc, flag: '', icon: 'pin', trips: Math.max(1, trips.size), days, n: stops.reduce((a, [, s]) => a + (s.n || 0), 0), ids, stopIdx: stops.map(([i]) => i).sort((a, b) => a - b), first: first || day10(new Date().toISOString()), isRegion: true });
}
function attachMapGestures(canvas, E2, redraw, onTap) {
  const ptrs = new Map(); let downAt = 0, downPos = null, moved = false, lastTap = 0, pinch = null;
  const cpos = (e) => { const r = canvas.getBoundingClientRect(); return [(e.clientX - r.left) * canvas.width / Math.max(1, r.width), (e.clientY - r.top) * canvas.height / Math.max(1, r.height)]; };
  const ZMIN = 1.0, ZMAX = () => (E2.S.tiles !== 'none' ? 11.5 : 7.2);
  const panBy = (dx, dy) => { const c = E2.cam; const p0 = E2.llToScreen([c.lon, c.lat]); if (!p0) return; const ll = E2.screenToLL(p0[0] - dx, p0[1] - dy); if (ll) { c.lon = ((ll[0] + 540) % 360) - 180; c.lat = clamp(ll[1], -80, 80); } };
  const zoomAt = (x, y, dz) => { const before = E2.screenToLL(x, y); E2.cam.z = clamp(E2.cam.z + dz, ZMIN, ZMAX()); if (before) { const after = E2.llToScreen(before); if (after) panBy(x - after[0], y - after[1]); } };
  canvas.addEventListener('pointerdown', (e) => { e.preventDefault(); try { canvas.setPointerCapture(e.pointerId); } catch (err) { /* ignore */ } const p = cpos(e); ptrs.set(e.pointerId, p); if (ptrs.size === 1) { downAt = performance.now(); downPos = p; moved = false; pinch = null; } else if (ptrs.size === 2) { const [a, b] = [...ptrs.values()]; pinch = { d: Math.hypot(a[0] - b[0], a[1] - b[1]), m: [(a[0] + b[0]) / 2, (a[1] + b[1]) / 2] }; } });
  canvas.addEventListener('pointermove', (e) => {
    if (!ptrs.has(e.pointerId)) return; const p = cpos(e); const prev = ptrs.get(e.pointerId); ptrs.set(e.pointerId, p);
    if (ptrs.size === 1) { if (downPos && Math.hypot(p[0] - downPos[0], p[1] - downPos[1]) > 8 * canvas.width / Math.max(1, canvas.getBoundingClientRect().width)) moved = true; if (moved) { panBy(p[0] - prev[0], p[1] - prev[1]); redraw(); } }
    else if (ptrs.size === 2 && pinch) { const [a, b] = [...ptrs.values()]; const d = Math.hypot(a[0] - b[0], a[1] - b[1]); const m = [(a[0] + b[0]) / 2, (a[1] + b[1]) / 2]; if (pinch.d > 0 && d > 0) zoomAt(m[0], m[1], Math.log2(d / pinch.d)); panBy(m[0] - pinch.m[0], m[1] - pinch.m[1]); pinch = { d, m }; moved = true; redraw(); }
  });
  const up = (e) => {
    if (!ptrs.has(e.pointerId)) return; const p = ptrs.get(e.pointerId); ptrs.delete(e.pointerId); if (ptrs.size < 2) pinch = null;
    if (ptrs.size === 0 && !moved && performance.now() - downAt < 400) { const now = performance.now(); if (now - lastTap < 320) { zoomAt(p[0], p[1], 1); redraw(); lastTap = 0; } else { lastTap = now; onTap(p[0], p[1]); } }
  };
  canvas.addEventListener('pointerup', up); canvas.addEventListener('pointercancel', up);
  canvas.addEventListener('wheel', (e) => { e.preventDefault(); const p = cpos(e); zoomAt(p[0], p[1], -e.deltaY / 250); redraw(); }, { passive: false });
}
// R211: Map photo markers must use the SAME native mixed-media gallery as Diary.
// Only an explicit ON for the existing user setting permits a bottom-up photo sheet.
function mapR211SheetAllowed() {
  try { return localStorage.getItem('moa.gallery.return.sheet.v1') === 'on'; }
  catch (_) { return false; }
}
function mapR211MediaId(raw) {
  const x = String(raw == null ? '' : raw);
  if (/^[0-9]{1,18}\|v$/.test(x)) return 'v' + x.slice(0, -2);
  return /^v?[0-9]{1,18}$/.test(x) ? x : '';
}
function mapR211OpenNative(z, selectedRaw) {
  const all = Array.isArray(z?.ids) ? z.ids : [];
  const valid = all.map((raw, pos) => ({ id: mapR211MediaId(raw), raw: String(raw), pos })).filter(p => !!p.id);
  if (!valid.length || typeof window.MoaLocalAudio?.openNativeGallery !== 'function') return false;
  const wanted = selectedRaw == null ? 0 : Math.max(0, all.findIndex(x => String(x) === String(selectedRaw)));
  const nearest = valid.findIndex(p => p.pos >= wanted);
  const active = nearest < 0 ? valid.length - 1 : nearest;
  // Native gallery accepts up to 10,000 IDs, preserving selected index and order.
  const first = Math.max(0, Math.min(active - 4500, Math.max(0, valid.length - 10000)));
  const media = valid.slice(first, first + 10000).map(p => p.id);
  try { return !!window.MoaLocalAudio.openNativeGallery(JSON.stringify(media), active - first, ''); }
  catch (err) { console.warn('Map R211 native gallery fallback', err); return false; }
}
// ---- 장소 시트 + 사진 뷰어 ----
let placeZone = null, placeShown = 0, viewerIdx = 0;
const homeAsZone = () => ({ key: 'home', name: Z.home.name, flag: '', trips: 0, days: Z.home.days, n: Z.home.n, ids: Z.home.ids || [], stopIdx: Z.home.stopIdx || [], isHome: true });
function openPlace(z) {
  placeZone = z; placeShown = 0;
  // OFF: no Map photo list sheet at all, not merely hide it after Back.
  if (!mapR211SheetAllowed()) {
    $('#place-root').hidden = true;
    if (mapR211OpenNative(z, null)) return;
    // Demo/cloud/unavailable MediaStore: preserve the old FULL-SCREEN safe fallback,
    // never create the bottom-rising place sheet while OFF.
    if (Array.isArray(z?.ids) && z.ids.length) {
      document.body.style.overflow = 'hidden';
      openViewer(0);
    }
    return;
  }
  $('#place-title').innerHTML = `${z.isHome ? icon('home') : (z.icon ? icon(z.icon) : ccBadge(z.cc))} ${escH(z.name)}`;
  $('#place-meta').textContent = z.isSpot ? tr('이 자리에서 찍은 사진 {n}장', { n: fmtN(z.n) }) : z.isHome ? tr('집 · {d}일 · 사진 {n}장', { d: fmtN(z.days), n: fmtN(z.n) }) : tr('{v}번 방문 · {d}일 · 사진 {n}장 · 처음 {first}', { v: z.trips, d: z.days, n: fmtN(z.n), first: fmtYMD(parseLocal(z.first + 'T12:00:00')) });
  const badge = $('#place-badge'); badge.hidden = !(z.tier || z.isNew); badge.textContent = z.tier ? tr('제{n}의 고향', { n: ord(z.tier) }) : 'NEW';
  const visits = (z.stopIdx || []).map(i => DATA.stops[i]).slice(-12).reverse();
  $('#place-visits').innerHTML = visits.map(s => `<span class="chip">${fmtYMD(parseLocal(s.start))}${s.days > 1 ? ' ~ ' + fmtShort(parseLocal(s.end)) : ''} · ${tr('{n}장', { n: fmtN(s.n) })}</span>`).join('');
  $('#place-photos').innerHTML = ''; $('#place-note').textContent = z.ids.length ? (z.ids[0].startsWith('ph:') ? tr('샘플 여행이라 자리표시 그림이 보여요. 내 사진으로 만들면 실제 사진이 나와요.') : '') : tr('이 곳의 사진을 불러올 수 없어요. 사진을 다시 읽어 보세요.');
  $('#place-root').hidden = false; document.body.style.overflow = 'hidden';
  morePhotos();
}
async function morePhotos() {
  const z = placeZone; if (!z) return; const grid = $('#place-photos'); const ids = z.ids.slice(placeShown, placeShown + 30); const base = placeShown; placeShown += ids.length;
  const more = $('#place-more'); more.hidden = placeShown >= z.ids.length; more.textContent = tr('사진 더 보기 ({n}장 남음)', { n: fmtN(z.ids.length - placeShown) });
  const tiles = ids.map((id, i) => {
    const d = document.createElement('div'); d.className = 'tile';
    if (id.endsWith('|v')) d.innerHTML = '<span class="v">' + icon('play') + '</span>';
    d.addEventListener('click', () => {
      // R211: no separate Naver HTML viewer for normal Map photos/videos.
      // Keeps exact place/region/spot order, including MediaStore |v videos.
      if (mapR211OpenNative(z, id)) {
        if (!mapR211SheetAllowed()) $('#place-root').hidden = true;
        return;
      }
      // MediaStore unavailable/denied, demo or cloud: retain the old full-screen fallback.
      openViewer(base + i);
    });
    grid.appendChild(d); return d;
  });
  for (let c = 0; c < ids.length; c += 12) {   // 12장씩 받아 먼저 온 것부터 채운다
    const part = ids.slice(c, c + 12); const res = await getThumbs(part, 320);
    if (placeZone !== z) return;
    part.forEach((id, i) => { const d = res.get(id); if (d) { const img = new Image(); img.src = d; img.alt = ''; tiles[c + i].prepend(img); } else tiles[c + i].classList.add('fail'); });
  }
}
function closePlace() { $('#place-root').hidden = true; if (!mapOpen) document.body.style.overflow = ''; }
const viewerSize = () => clamp(Math.round(Math.max(innerWidth, innerHeight) * Math.min(window.devicePixelRatio || 1, 3)), 1080, 2600);   // 화면 해상도 그대로(예: 1080×2340 폰이면 긴 변 2340)
async function openViewer(i) {
  const z = placeZone; if (!z || !z.ids[i]) return; viewerIdx = i; const id = z.ids[i];
  $('#viewer-root').hidden = false; const img = $('#viewer-img'); viewerReset(); img.src = thumbCache.get('320:' + id) || thumbCache.get('160:' + id) || ''; $('#viewer-cap').textContent = `${z.name} · ${i + 1} / ${fmtN(z.ids.length)}`;
  $('#viewer-prev').hidden = i <= 0; $('#viewer-next').hidden = i >= z.ids.length - 1; $('#viewer-open').hidden = id.startsWith('ph:') || !(NATIVE || (window.CloudSources && window.CloudSources.isCloudId(id)));
  const res = await getThumbs([id], viewerSize()); if (viewerIdx === i && res.get(id)) img.src = res.get(id);   // 작은 썸네일 먼저, 화면 크기 이미지가 오면 교체
}
// 뷰어 핀치 확대·이동·두 번 탭 (CSS transform)
let vz = { s: 1, x: 0, y: 0 };
function viewerApply() { $('#viewer-img').style.transform = `translate(${vz.x}px, ${vz.y}px) scale(${vz.s})`; }
function viewerReset() { vz = { s: 1, x: 0, y: 0 }; viewerApply(); }
(() => {
  const img = $('#viewer-img'); const root = $('#viewer-root'); const ptrs = new Map(); let pinch = null, downAt = 0, moved = false, lastTap = 0, base = null;
  const rect = () => img.getBoundingClientRect();
  const zoomAt = (cx, cy, k) => { const r = rect(); const ns = clamp(vz.s * k, 1, 6); const kk = ns / vz.s; vz.x = cx - (cx - r.left) * kk + (r.left - vz.x) * 0; vz.y = cy - (cy - r.top) * kk; // 손가락 아래 점 고정
    vz.x = cx - (cx - r.left) * kk - (r.left - vz.x); vz.y = cy - (cy - r.top) * kk - (r.top - vz.y); vz.s = ns; if (ns === 1) { vz.x = 0; vz.y = 0; } viewerApply(); };
  root.addEventListener('pointerdown', (e) => { if (e.target.tagName === 'BUTTON') return; e.preventDefault(); ptrs.set(e.pointerId, [e.clientX, e.clientY]); if (ptrs.size === 1) { downAt = performance.now(); moved = false; base = [e.clientX, e.clientY]; } else if (ptrs.size === 2) { const [a, b] = [...ptrs.values()]; pinch = { d: Math.hypot(a[0] - b[0], a[1] - b[1]), m: [(a[0] + b[0]) / 2, (a[1] + b[1]) / 2] }; } });
  root.addEventListener('pointermove', (e) => { if (!ptrs.has(e.pointerId)) return; const prev = ptrs.get(e.pointerId); ptrs.set(e.pointerId, [e.clientX, e.clientY]);
    if (ptrs.size === 1) { if (Math.hypot(e.clientX - base[0], e.clientY - base[1]) > 8) moved = true; if (moved && vz.s > 1) { vz.x += e.clientX - prev[0]; vz.y += e.clientY - prev[1]; viewerApply(); } }
    else if (ptrs.size === 2 && pinch) { const [a, b] = [...ptrs.values()]; const d = Math.hypot(a[0] - b[0], a[1] - b[1]); const m = [(a[0] + b[0]) / 2, (a[1] + b[1]) / 2]; if (pinch.d > 0) zoomAt(m[0], m[1], d / pinch.d); vz.x += m[0] - pinch.m[0]; vz.y += m[1] - pinch.m[1]; viewerApply(); pinch = { d, m }; moved = true; } });
  const up = (e) => { if (!ptrs.has(e.pointerId)) return; ptrs.delete(e.pointerId); if (ptrs.size < 2) pinch = null;
    if (ptrs.size === 0 && !moved && performance.now() - downAt < 400) { const now = performance.now(); if (now - lastTap < 320) { lastTap = 0; if (vz.s > 1) viewerReset(); else zoomAt(e.clientX, e.clientY, 2.5); } else { lastTap = now; setTimeout(() => { if (lastTap === now && vz.s === 1) root.hidden = true; }, 330); } } };   // 한 번 탭 = 닫기(확대 중엔 유지), 두 번 탭 = 확대/복귀
  root.addEventListener('pointerup', up); root.addEventListener('pointercancel', up);
  root.addEventListener('wheel', (e) => { e.preventDefault(); zoomAt(e.clientX, e.clientY, Math.exp(-e.deltaY / 300)); }, { passive: false });
})();
$('#viewer-close').addEventListener('click', () => { $('#viewer-root').hidden = true; });
$('#viewer-open').addEventListener('click', async () => { const z = placeZone; const id = z && z.ids[viewerIdx]; if (!id) return; if (window.CloudSources && window.CloudSources.isCloudId(id)) { window.CloudSources.open(id); return; } const r = await askNative('openPhoto', { id }); if (r && r.message) $('#viewer-cap').textContent = r.message; });
$('#viewer-prev').addEventListener('click', () => openViewer(viewerIdx - 1)); $('#viewer-next').addEventListener('click', () => openViewer(viewerIdx + 1));
$('#place-more').addEventListener('click', morePhotos); $('#place-close').addEventListener('click', closePlace); $('#place-dim').addEventListener('click', closePlace);
$('#map-close').addEventListener('click', closeMap); $('#home-map-expand').addEventListener('click', openMap); $('#home-canvas').addEventListener('click', openMap);
function homeSetRegion(region) {
  homeRegion = region;
  $$('#home-region .chip').forEach(b => b.classList.toggle('active', b.dataset.v === region));
  const world = region === 'world';
  HE.S.aspect = world ? '1:1' : '4:5'; HE.rebuild();
  const pts = (world ? Z.zones : domestic()).map(z => z.ll); if (Z.home && (world || Z.home.cc === Z.homeCC)) pts.push(Z.home.ll);
  const c = HE.fitPoints(pts, world ? 0.2 : 0.24); c.z = Math.min(c.z, 7.6); HE.cam.lon = c.lon; HE.cam.lat = c.lat; HE.cam.z = c.z;
  homeDraw();
}
function renderHome() {
  const dom = domestic(), abr = abroad();
  if (!HE) {
    const cw = $('#home-canvas').getBoundingClientRect().width || 360;   // 글씨·마커를 화면 픽셀 기준으로 (캔버스 900px 이 화면 ~350px 에 그려짐)
    const hs = Object.assign({}, S, { selection: 'all', preset: 'all', from: '', to: '', includeShort: true, mapMode: 'flat', aspect: '4:5', shortEdge: 900, watermark: false, photoDots: false, camera: 'fixed', tiles: S.tiles === 'none' ? 'none' : S.tiles, pxRatio: 900 / cw * 0.85, ownLabels: OWN_LABELS });
    HE = PhotoMapEngine.create({ canvas: $('#home-canvas'), S: hs, DATA, platform: PLATFORM, onTileLoaded: () => { clearTimeout(homeTimer); homeTimer = setTimeout(homeDraw, 120); } });
    const rg = $('#home-region'); rg.innerHTML = '';
    if (dom.length && abr.length) {
      for (const [v, l] of [['home', (Z.home && Z.home.country) || tr('국내')], ['world', tr('전체|world')]]) { const b = document.createElement('button'); b.className = 'chip'; b.dataset.v = v; b.textContent = l; b.addEventListener('click', () => homeSetRegion(v)); rg.appendChild(b); }
      rg.hidden = false;
    }
    homeSetRegion(dom.length ? 'home' : 'world');
  } else if (!homeDrawn) homeDraw();
  homeDrawn = true;
  // 머리말
  const nCountries = Z.countries; const r = DATA.meta.range || ['', ''];
  const regTxt = (REG.total ? ' · ' + tr(REG.homeKR ? '시·군·구 {n}곳' : '지역 {n}곳', { n: REG.count }) : '') + (REG.abroad ? ' · ' + tr('해외 지역 {n}곳', { n: REG.abroad }) : '');
  $('#home-desc').textContent = tr('{since}{z}곳{reg} · {c}개국을 밝혔어요', { since: r[0] ? tr('{y}년부터', { y: r[0].slice(0, 4) }) + ' ' : '', z: Z.zones.length, reg: regTxt, c: nCountries }) + (recentNew.length ? ' · ' + tr('새로 {n}곳', { n: recentNew.length }) : '');
  // 고향 카드 (사진 배경)
  const ht = $('#home-ht'); const cards = [];
  const card = (cls, tier, name, meta, z, extra) => `<div class="ht-card ${cls}" ${z ? `data-zone="${z.key}"` : ''} ${z && z.rep ? `data-rep="${z.rep}"` : ''}><div class="tier">${tier}</div><div class="name">${name}</div><div class="meta">${meta}</div>${extra || ''}</div>`;
  if (Z.home) cards.push(card('t1', icon('home') + ' ' + tr('집'), escH(Z.home.name), tr('{d}일 · 사진 {n}장', { d: fmtN(Z.home.days), n: fmtN(Z.home.n) }), { key: 'home', rep: Z.home.rep }));
  for (let i = 0; i < 2; i++) {
    const z = Z.hometowns[i]; const tier = i + 2;
    if (z) cards.push(card('', tr('제{n}의 고향', { n: ord(tier) }), `${ccBadge(z.cc)} ${escH(z.name)}`, tr('{v}번 · {d}일', { v: z.trips, d: z.days }), z));
    else {
      const c = Z.candidates[i - Z.hometowns.length];
      if (c) { const need = Math.max((c.days >= 5 ? 2 : 3) - c.trips, 0), pct = Math.min(100, Math.round(Math.max(c.trips / 3, Math.min(c.trips / 2, c.days / 5)) * 100)); cards.push(card('empty', tr('제{n}의 고향 후보', { n: ord(tier) }), `${c.flag || ''} ${c.name}`, need ? tr('{n}번 더 가면 고향', { n: need }) : tr('조금만 더 머물면 고향'), c, `<div class="bar"><i style="width:${pct}%"></i></div>`)); }
      else cards.push(card('empty', tr('제{n}의 고향', { n: ord(tier) }), tr('아직 없어요'), tr('한 곳을 3번 이상 가면 돼요'), null));
    }
  }
  ht.innerHTML = cards.join('');
  $('#home-ht-note').textContent = tr('집 밖에서 3번 이상 갔거나, 2번 이상 가고 5일 넘게 머문 곳이 고향이 돼요. 카드를 누르면 사진이 나와요.');
  // 자주 간 곳: 사진 타일
  $('#home-rank').innerHTML = Z.ranked.slice(0, 6).map((z, i) => `<div class="place-tile" data-zone="${z.key}" ${z.rep ? `data-rep="${z.rep}"` : ''}><span class="num">${i + 1}</span>${z.tier ? `<span class="badge on-photo">${tr('제{n}의 고향', { n: ord(z.tier) })}</span>` : (z.isNew ? '<span class="badge on-photo">NEW</span>' : '')}<div class="name">${ccBadge(z.cc)} ${escH(z.name)}</div><div class="meta">${tr('{v}번 · {d}일 · 사진 {n}장', { v: z.trips, d: z.days, n: fmtN(z.n) })}</div></div>`).join('') || `<p class="caption">${tr('아직 집 밖 기록이 없어요')}</p>`;
  // 최근 밝힌 곳: 가로 카드
  const recent = Z.zones.slice().sort((a, b) => b.first.localeCompare(a.first)).slice(0, 10);
  $('#home-recent-title').textContent = recentNew.length ? tr('새로 밝힌 곳 {n} · 최근 밝힌 곳', { n: recentNew.length }) : tr('최근 밝힌 곳');
  $('#home-recent').innerHTML = recent.map(z => `<div class="hcard" data-zone="${z.key}" ${z.rep ? `data-rep="${z.rep}"` : ''}>${z.isNew ? '<span class="badge on-photo">NEW</span>' : ''}<div class="name">${ccBadge(z.cc)} ${escH(z.name)}</div><div class="meta">${tr('{date} 처음 · 사진 {n}장', { date: fmtShort(parseLocal(z.first + 'T12:00:00')), n: fmtN(z.n) })}</div></div>`).join('');
  // 밝힌 기록
  const tile = (v, l, i) => `<div class="stat c${i + 1}"><b>${v}</b><span>${l}</span></div>`;
  const days = r[0] && r[1] ? Math.round((parseLocal(r[1] + 'T00:00:00') - parseLocal(r[0] + 'T00:00:00')) / 864e5) + 1 : 0;
  const years = r[0] ? Math.max(1, new Date().getFullYear() - +r[0].slice(0, 4) + 1) : 0;
  const tiles = [];
  if (REG.total) tiles.push([`${REG.count} / ${REG.total}`, tr(REG.homeKR ? '시·군·구 · {p}%' : '지역 · {p}%', { p: (REG.count / REG.total * 100).toFixed(1) })]); else tiles.push([fmtN(Z.zones.length), tr('밝힌 곳', { n: Z.zones.length })]);
  tiles.push([nCountries, tr('개국', { n: nCountries })], [fmtN(DATA.stats.photos), tr('위치 있는 사진')], [years ? tr('{y}년째', { y: ord(years) }) : '-', tr('넓히는 중 · {d}일', { d: fmtN(days) })]);
  $('#stats-home').innerHTML = tiles.map(([v, l], i) => tile(v, l, i)).join('');
  // 카드 탭 → 장소 시트
  $$('#pages [data-zone]').forEach(el => el.addEventListener('click', () => { const k = el.dataset.zone; if (k === 'home') { if (Z.home) openPlace(homeAsZone()); return; } const z = Z.zones.find(x => x.key === k); if (z) openPlace(z); }));
  loadCardThumbs();
  loadMarkerThumbs();
  setTimeout(sendWidget, 1500);
}
$('#home-log').addEventListener('click', openLog);

// ---------- 홈 화면 위젯: 앱이 지도를 그린 뒤 정사각(800)·가로(1000×500) PNG 를 만들어 네이티브에 보낸다(내장 지도, 라벨 조금, 사진 마커 없음) ----------
let widgetSent = false;
function sendWidget() {
  if (!NATIVE || DEMO || widgetSent || !window.webkit || !window.webkit.messageHandlers) return; widgetSent = true;
  try {
    const dom = domestic(); const region = dom.length ? 'home' : 'world';
    const pts = (region === 'world' ? Z.zones : dom).map(z => z.ll); if (Z.home && (region === 'world' || Z.home.cc === Z.homeCC)) pts.push(Z.home.ll);
    const render = (w, h, labels) => {
      const cv = document.createElement('canvas'); cv.width = w; cv.height = h;
      const ws = Object.assign({}, S, { selection: 'all', preset: 'all', from: '', to: '', includeShort: true, mapMode: 'flat', tiles: 'none', watermark: false, photoDots: false, camera: 'fixed', stage: { w, h }, pxRatio: w / 400 });
      const WE = PhotoMapEngine.create({ canvas: cv, S: ws, DATA, platform: PLATFORM }); WE.rebuild();
      const c = WE.fitPoints(pts, region === 'world' ? 0.12 : 0.16); c.z = Math.min(c.z, 7.6); WE.cam.lon = c.lon; WE.cam.lat = c.lat; WE.cam.z = c.z;
      WE.draw(0, { territory: Object.assign(territoryOpts(labels), { thumbs: null, thumbKeys: null }) });
      return cv.toDataURL('image/png');
    };
    const square = render(800, 800, 5), wide = render(1000, 500, 6);
    window.webkit.messageHandlers.widget.postMessage({ square, wide, title: tr('나의 지도'), subtitle: $('#home-desc').textContent || '' });
  } catch (e) { nlog('widget error ' + (e && e.message)); }
}

// ---------- 설정 탭 ----------
function renderSettings() {
  const prem = $('#set-premium'); prem.hidden = !NATIVE; $('#set-premium-desc').textContent = premium ? tr('사용 중 · 광고 없이 저장, 모든 지도·카메라·해상도 옵션') : tr('광고 없이 저장하고 모든 지도·카메라·해상도 옵션을 써요');
  const acc = window.Account; const sec = $('#set-account-sec'); if (sec) { sec.hidden = !(acc && acc.base); if (acc && acc.base) { const on = acc.loggedIn; $('#set-account-desc').textContent = on ? (acc.session.name || '') + ' · ' + ({ google: 'Google', kakao: tr('카카오'), apple: 'Apple', dev: 'dev' }[acc.session.provider] || acc.session.provider) : tr('로그인 안 함 · 대결 탭에서 로그인해요'); $('#set-logout').hidden = !on; $('#set-delete').hidden = !on; } }
  $('#set-rescan').hidden = !NATIVE || DEMO; const at = I18N ? window.__photoMapCacheAt : null; const rd = $('#set-rescan .row-desc'); if (rd) rd.textContent = tr('새 사진을 찍었다면 다시 읽어 주세요. 새로 간 곳이 지도에 칠해져요.') + (at ? ' · ' + tr('마지막 읽기 {t}', { t: I18N.fmtShort(at) + ' ' + new Date(at).toTimeString().slice(0, 5) }) : '');
  $('#set-demo').hidden = !(NATIVE && window.PhotoMapDemo && !DEMO); $('#set-lang').hidden = !NATIVE; $('#set-ad-privacy').hidden = !NATIVE;
}
$('#set-premium').addEventListener('click', () => openPremium());
$('#set-account').addEventListener('click', () => showTab('battle'));
$('#set-logout').addEventListener('click', async () => { if (await askConfirm(tr('로그아웃할까요?'), tr('대결 기록은 서버에 남아 있고, 다시 로그인하면 이어서 볼 수 있어요.'), tr('로그아웃'))) { window.Account.logout(); BS.tried = false; BS.battles = null; BS.board = null; BS.rank = null; renderSettings(); } });
$('#set-delete').addEventListener('click', async () => { if (await askConfirm(tr('회원 탈퇴할까요?'), tr('계정과 지도 통계, 대결 기록이 서버에서 지워져요. 되돌릴 수 없어요.'), tr('탈퇴하기'), true)) { try { await window.Account.deleteAccount(); BS.tried = false; BS.battles = null; BS.board = null; BS.rank = null; renderSettings(); } catch (e) { $('#set-account-desc').textContent = errText(e); } } });
$('#set-rescan').addEventListener('click', () => postRescan());
$('#set-demo').addEventListener('click', () => { location.replace(location.pathname + '?demo=1'); });
$('#set-lang').addEventListener('click', () => { try { window.webkit.messageHandlers.openSettings.postMessage({}); } catch (e) { /* ignore */ } });
$('#set-tutorial').addEventListener('click', () => startTutorial(0));
$('#set-ad-privacy').addEventListener('click', async () => { const r = await askNative('adPrivacy'); if (r && r.message) alert(r.message); });
$$('[data-href]').forEach(el => el.addEventListener('click', () => { const a = document.createElement('a'); a.href = el.dataset.href; a.rel = 'noopener'; document.body.appendChild(a); a.click(); a.remove(); }));

// ---------- 추천 탭: 안 가본 여행지 (data/destinations.js 큐레이션 · 다녀온 곳 30km 이내 제외 · 계절·근접·인기 점수) ----------
const DEST = window.DESTINATIONS || [];
const WISH_KEY = 'photo-map-wish.v1'; const WISH = new Set((() => { try { return JSON.parse(localStorage.getItem(WISH_KEY) || '[]'); } catch (e) { return []; } })());
const saveWish = () => { try { localStorage.setItem(WISH_KEY, JSON.stringify([...WISH])); } catch (e) { /* ignore */ } };
let recoScope = (() => { try { return localStorage.getItem('photo-map-reco-scope') || 'domestic'; } catch (e) { return 'domestic'; } })();
let recoMode = (() => {
  try {
    const m = localStorage.getItem('photo-map-reco-mode');
    return m === 'repeat' || m === 'new' ? m : 'all';
  } catch (e) {
    return 'all';
  }
})();
let recoSeed = 1, mapFocus = null;
const nm = (o) => (o && (o[I18N ? I18N.lang : 'ko'] || o.ko)) || '';
let dispNames = null;
function countryName(cc) { const c = DATA.countries.find(x => x.cc === cc); if (c && c.name) return c.name; try { if (!dispNames) dispNames = new Intl.DisplayNames([I18N ? I18N.locale : 'ko-KR'], { type: 'region' }); return dispNames.of(cc) || cc; } catch (e) { return cc; } }
function nearestVisited(d) { const P = [d.lon, d.lat]; let best = 1e9, name = null; for (const z of Z.zones) { const km = hav(P, z.ll); if (km < best) { best = km; name = z.name; } } if (Z.home) { const km = hav(P, Z.home.ll); if (km < best) { best = km; name = Z.home.name; } } return { km: best, name }; }
function monthsText(ms) {   // [10,11,12,1,2] → '10~2', [4,5,10] → '4~5, 10'
  const set = new Set(ms); const runs = []; let start = null;
  for (let m = 1; m <= 24; m++) { const mm = ((m - 1) % 12) + 1; if (set.has(mm)) { if (start == null) start = m; } else if (start != null) { runs.push([start, m - 1]); start = null; } }
  const seen = new Set(); const out = [];
  for (const [a, b] of runs) { if (a > 12) continue; const A = ((a - 1) % 12) + 1, B = ((b - 1) % 12) + 1; if (seen.has(A)) continue; seen.add(A); out.push(A === B ? String(A) : `${A}~${B}`); }
  return out.join(', ');
}
function computeReco(scope, seed, mode = 'all') {
  const month = new Date().getMonth() + 1; const homeCC = Z.homeCC || 'KR'; const visitedCC = new Set(Z.zones.map(z => z.cc).concat([homeCC]));
  const rnd = (i) => { let a = (Math.imul(i + 1, 2654435761) + seed * 97) >>> 0; a ^= a >>> 13; a = Math.imul(a, 0x5bd1e995) >>> 0; return (a ^ (a >>> 15)) / 4294967296; };
  return DEST.filter(d => scope === 'all' || ((scope === 'domestic') === (d.cc === homeCC)))
    .map((d, i) => { const near = nearestVisited(d); const inSeason = d.months.includes(month); const score = d.pop * 2 + (inSeason ? 2 : 0) + (near.km < 200 ? 1 : 0) + (d.cc !== homeCC && !visitedCC.has(d.cc) ? 1 : 0) + rnd(i) * 2.5; return { d, near, inSeason, score, visited: near.km < 30 }; })
    .filter(r => mode === 'all' ? true : mode === 'repeat' ? r.visited : !r.visited).sort((a, b) => b.score - a.score);
}
const wishMarkers = () => { const list = [...WISH].map(id => DEST.find(d => d.id === id)).filter(Boolean); if (mapFocus && !WISH.has(mapFocus.id)) list.push(mapFocus); return list.map(d => ({ ll: [d.lon, d.lat], name: nm(d.name), focus: !!(mapFocus && mapFocus.id === d.id) })); };
// ---- 서버(account.js): 추천 탭은 부팅 중 먼저 열릴 수 있어 아래 대결 절의 const ACC 대신 window.Account 를 그때그때 본다 ----
const SRV = () => window.Account && window.Account.base ? window.Account : null;
function openExternal(url) {   // 외부 링크: 네이티브 브라우저(iOS Safari 뷰 / Android 기본 앱), 웹에선 새 탭
  if (!url) return;
  if (NATIVE) { try { window.webkit.messageHandlers.openUrl.postMessage({ url }); return; } catch (e) { /* fall through */ } }
  try { const w = window.open(url, '_blank', 'noopener'); if (!w) location.href = url; } catch (e) { location.href = url; }
}
const ymdLocal = () => { const d = new Date(); return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`; };
const ymdMs = (s) => new Date(+s.slice(0, 4), +s.slice(4, 6) - 1, +s.slice(6, 8)).getTime();
const fmtYmd = (s) => (s && s.length === 8 ? (I18N ? I18N.fmtShort(ymdMs(s)) : `${+s.slice(4, 6)}.${+s.slice(6, 8)}`) : '');
const fmtRange = (a, b) => (a && b && a !== b ? `${fmtYmd(a)} ~ ${fmtYmd(b)}` : fmtYmd(a || b));
const fmtYmdFull = (s) => { if (!s || s.length !== 8) return ''; const y = +s.slice(0, 4), m = +s.slice(4, 6), d = +s.slice(6, 8); if (I18N && I18N.lang === 'en') return `${I18N.fmtShort(ymdMs(s))}, ${y}`; return `${y}.${m}.${d}`; };
const monthName = (m) => { try { return new Intl.DateTimeFormat(I18N ? I18N.locale : 'ko-KR', { month: 'long' }).format(new Date(2026, m - 1, 1)); } catch (e) { return String(m); } };
const thisMonth = () => new Date().getMonth() + 1;

// ---- 축제·행사 (서버 /festivals — 한국관광공사 목록을 서버가 주기적으로 받아 둔 것) ----
let festivals = null, festMeta = null, festLoading = false, festTriedAt = 0;
async function loadFestivals() {   // 키가 없거나 실패하면 빈 목록 + 이유(추천 탭이 안내 카드로 보여줌). 네트워크 실패는 5분 뒤 다시 시도
  if (festLoading || !SRV()) return;
  if (festivals !== null && !(festMeta && festMeta.reason === 'network' && Date.now() - festTriedAt > 5 * 60e3)) return;
  festLoading = true; festTriedAt = Date.now();
  try { const r = await SRV().api('GET', '/festivals?lang=' + (I18N ? I18N.lang : 'ko')); festivals = (r && r.items) || []; festMeta = r || {}; }
  catch (e) { festivals = []; festMeta = { reason: 'network', message: e && e.message }; }
  finally { festLoading = false; }
  if (tab === 'reco') renderReco();
  if (!$('#fest-list').hidden) renderFestList();
}
function festStatus(f) {   // {kind: on|soon|later|end, label}
  const today = (festMeta && festMeta.today) || ymdLocal();
  if (f.end && f.end < today) return { kind: 'end', label: tr('종료') };
  if (!f.start || f.start <= today) return { kind: 'on', label: tr('진행 중') };
  const days = Math.round((ymdMs(f.start) - ymdMs(today)) / 864e5);
  return { kind: days <= 30 ? 'soon' : 'later', label: `D-${days}` };
}
const festNear = (f) => nearestVisited({ lat: f.lat, lon: f.lon });
const nearText = (near) => (near && near.name && near.km < 600 ? tr('다녀온 {name}에서 {km}km', { name: near.name, km: fmtN(near.km) }) : '');
const addrShort = (addr) => String(addr || '').split(/\s+/).slice(0, 2).join(' ');
const festDays = (f) => (f.start && f.end && f.start.length === 8 && f.end.length === 8 ? Math.round((ymdMs(f.end) - ymdMs(f.start)) / 864e5) + 1 : 0);
function activeFests() {   // 끝난 것 제외: 진행 중(끝나는 순) → 예정(시작 순) → 90일 넘게 계속되는 상설 공연·전시(끝나는 순)
  const rank = (x) => (x.st.kind === 'on' ? (festDays(x.f) > 90 ? 3 : 0) : x.st.kind === 'soon' ? 1 : 2);
  return (festivals || []).map(f => ({ f, st: festStatus(f) })).filter(x => x.st.kind !== 'end')
    .sort((a, b) => (rank(a) - rank(b)) || ((a.st.kind === 'on' ? a.f.end : a.f.start) || '').localeCompare((b.st.kind === 'on' ? b.f.end : b.f.start) || ''));
}
const httpsUrl = (u) => (u && u.startsWith('http://') ? 'https://' + u.slice(7) : u);   // 관광공사 사진은 http 도 섞여 있고 iOS 는 http 를 막는다
const imgDiv = (cls, url, none) => (url ? `<div class="${cls}" data-bg="${escH(httpsUrl(url))}" data-icon="${none || 'sparkles'}">` : `<div class="${cls} none">${icon(none || 'sparkles')}`);
const IMG_OK = new Map();   // url → true/false (한 번 실패한 주소는 다시 시도하지 않음)
function hydrateBg() {   // [data-bg] 요소: 사진을 먼저 받아 보고 성공하면 배경으로, 실패하면 자리표시 아이콘(회색 빈 상자 방지)
  document.querySelectorAll('[data-bg]').forEach(el => {
    const url = httpsUrl(el.dataset.bg || ''); const ic = el.dataset.icon || 'image'; el.removeAttribute('data-bg');
    const fail = () => { el.style.backgroundImage = ''; el.classList.add('none'); if (!el.querySelector('.ico')) el.insertAdjacentHTML('afterbegin', icon(ic)); };
    const ok = () => { el.classList.remove('none'); const i = el.querySelector('.ico'); if (i) i.remove(); el.style.backgroundImage = `url('${url}')`; };
    if (!url || IMG_OK.get(url) === false) { fail(); return; }
    if (IMG_OK.get(url) === true) { ok(); return; }
    const im = new Image(); im.onload = () => { IMG_OK.set(url, true); ok(); }; im.onerror = () => { IMG_OK.set(url, false); fail(); }; im.src = url;
  });
}
function renderFestivals() {
  const box = $('#reco-fest-list'); const note = $('#reco-fest-note'); if (!box) return;
  $('#reco-fest-title').textContent = tr('{m}월의 축제·행사', { m: thisMonth(), mon: monthName(thisMonth()) });
  if (festivals === null && !SRV()) { festivals = []; festMeta = { reason: 'independent_source_not_configured' }; }
  const list = activeFests();
  $$('#reco-fest-filter .chip').forEach(b => b.classList.toggle('active', b.dataset.v === festFilter));
  if (festivals === null) { box.innerHTML = [1, 2].map(() => '<div class="fest-card"><div class="fest-img none"></div><div class="fest-body"><div class="fest-title"></div></div></div>').join(''); note.textContent = ''; loadFestivals(); return; }
  if (!list.length) {
    const noKey = festMeta && festMeta.reason;
    box.innerHTML = `<div class="fest-empty"><b>${noKey ? tr('축제 정보를 준비하고 있어요') : tr('이번 달에 등록된 축제가 없어요')}</b>${noKey ? tr('한국관광공사 정보를 연결하면 이달의 축제가 여기에 보여요.') : tr('다음 달 일정이 등록되면 여기에 보여요.')}</div>`;
    note.textContent = ''; return;
  }
  // 세로 목록(전체 폭 카드): 진행 중 → 이번 달 시작 → 다음 달 이후 그룹, 필터 칩은 전체 목록 화면과 같은 festFilter
  const groups = festGroups(festFilter);
  box.innerHTML = groups.length ? groups.map(([title, items]) => `<div class="fest-group">${escH(title)}<small>${items.length}</small></div>` + items.map(({ f, st, near }) => `<button type="button" class="fest-card" data-id="${escH(f.id)}">${imgDiv('fest-img', f.image)}<span class="fest-badge ${st.kind}">${escH(st.label)}</span></div><div class="fest-body"><div class="fest-title">${escH(f.title)}</div><div class="fest-date">${escH(fmtRange(f.start, f.end))}</div><div class="fest-addr">${escH(addrShort(f.addr))}</div><div class="fest-near">${escH(nearText(near))}</div></div></button>`).join('')).join('')
    : `<p class="caption">${tr('해당하는 축제가 없어요.')}</p>`;
  note.textContent = tr('한국관광공사 관광정보 · 카드를 누르면 사진과 안내를 볼 수 있어요');
  hydrateBg();
  $$('#reco-fest-list .fest-card[data-id]').forEach(b => b.addEventListener('click', () => { const f = festivals.find(x => x.id === b.dataset.id); if (f) openFestDetail(f); }));
}
$$('#reco-fest-filter .chip').forEach(b => b.addEventListener('click', () => { festFilter = b.dataset.v; renderFestivals(); }));
// 축제 전체 목록 화면
let festFilter = 'all';
function openFestList() { $('#fest-list').hidden = false; $('#fest-list').scrollTop = 0; document.body.style.overflow = 'hidden'; renderFestList(); }
function closeFestList() { $('#fest-list').hidden = true; if ($('#place-detail').hidden) document.body.style.overflow = ''; }
// 필터(전체·진행 중·예정·다녀온 곳 근처)별 축제 그룹 [[제목, [{f, st, near}]]] — 추천 행사 세그먼트와 전체 목록 화면이 같이 쓴다
function festGroups(filter) {
  let list = activeFests().map(x => Object.assign(x, { near: festNear(x.f) }));
  const groups = [];
  if (filter === 'near') { list = list.filter(x => x.near.km <= 150).sort((a, b) => a.near.km - b.near.km); if (list.length) groups.push([tr('다녀온 곳 근처'), list]); }
  else {
    if (filter === 'on') list = list.filter(x => x.st.kind === 'on'); else if (filter === 'soon') list = list.filter(x => x.st.kind !== 'on');
    const m = String(thisMonth()).padStart(2, '0'); const y = String(new Date().getFullYear());
    const on = list.filter(x => x.st.kind === 'on'), soon = list.filter(x => x.st.kind !== 'on' && x.f.start.slice(0, 6) === y + m), later = list.filter(x => x.st.kind !== 'on' && x.f.start.slice(0, 6) !== y + m);
    if (on.length) groups.push([tr('진행 중'), on]); if (soon.length) groups.push([tr('이번 달 시작'), soon]); if (later.length) groups.push([tr('다음 달 이후'), later]);
  }
  return groups;
}
function renderFestList() {
  $('#fest-list-title').textContent = tr('{m}월의 축제·행사', { m: thisMonth(), mon: monthName(thisMonth()) });
  $$('#fest-filter .chip').forEach(b => b.classList.toggle('active', b.dataset.v === festFilter));
  const body = $('#fest-list-body');
  if (festivals === null) { body.innerHTML = `<div class="pd-loading"><i></i>${tr('불러오는 중…')}</div>`; loadFestivals(); return; }
  const groups = festGroups(festFilter);
  if (!groups.length) { body.innerHTML = `<p class="caption">${tr('해당하는 축제가 없어요.')}</p>`; return; }
  body.innerHTML = groups.map(([title, items]) => `<div class="fest-group">${escH(title)}<small>${items.length}</small></div>` + items.map(({ f, st, near }) => `<button type="button" class="fest-row" data-id="${escH(f.id)}">${imgDiv('fest-row-img', f.image)}</div><div class="fest-row-body"><div class="fest-row-title">${escH(f.title)}</div><div class="fest-row-meta"><span class="${st.kind}">${escH(st.label)}</span> · ${escH(fmtRange(f.start, f.end))}</div><div class="fest-row-meta">${escH([addrShort(f.addr), nearText(near)].filter(Boolean).join(' · '))}</div></div><span class="chev"></span></button>`).join('')).join('');
  $$('#fest-list-body .fest-row').forEach(b => b.addEventListener('click', () => { const f = festivals.find(x => x.id === b.dataset.id); if (f) openFestDetail(f); }));
  hydrateBg();
}
$('#fest-list-back').addEventListener('click', closeFestList);
$$('#fest-filter .chip').forEach(b => b.addEventListener('click', () => { festFilter = b.dataset.v; renderFestList(); }));

// ---- 여행지 대표 사진 (서버 /places/images: 국내는 관광공사 관광지 사진, 그 외 위키백과) — 7일 캐시 ----
const PIMG_KEY = 'photo-map-place-img.v2';   // v1 은 http 사진 주소가 섞여 있어 버림
const PLACE_IMG = (() => { try { const j = JSON.parse(localStorage.getItem(PIMG_KEY) || '{}'); if (j.ts && Date.now() - j.ts < 7 * 864e5 && j.map) return new Map(Object.entries(j.map)); } catch (e) { /* ignore */ } return new Map(); })();
const PIMG_FAIL = new Set(); let pimgTs = Date.now();
const savePlaceImgs = () => { try { localStorage.setItem(PIMG_KEY, JSON.stringify({ ts: pimgTs, map: Object.fromEntries(PLACE_IMG) })); } catch (e) { /* ignore */ } };
async function loadPlaceImages(list) {
  const need = list.filter(d => !PLACE_IMG.get(d.id) && !PIMG_FAIL.has(d.id));
  if (!need.length) return;
  for (const d of need) {
    PIMG_FAIL.add(d.id);
    const name = (d.name && d.name.ko) || d.id;
    const titles = [name, name + '시', name + ' (대한민국)'];
    let found = null;
    for (const title of titles) {
      try {
        const url = 'https://ko.wikipedia.org/w/api.php?action=query&format=json&origin=*&prop=pageimages&piprop=thumbnail&pithumbsize=800&titles=' + encodeURIComponent(title);
        const res = await fetch(url, { credentials: 'omit', cache: 'force-cache' });
        if (!res.ok) continue;
        const data = await res.json();
        const pages = Object.values((data.query && data.query.pages) || {});
        const page = pages.find(p => p.thumbnail && /^https:\/\/upload\.wikimedia\.org\//.test(p.thumbnail.source));
        if (page) { const im = page.thumbnail.source; found = { url: im, thumb: im, source: 'wikipedia', title: page.title, page: 'https://ko.wikipedia.org/wiki/' + encodeURIComponent(page.title) }; break; }
      } catch (e) { /* Wikimedia is optional; do not use original publisher. */ }
    }
    if (found) PLACE_IMG.set(d.id, found);
    PIMG_FAIL.delete(d.id);
  }
  pimgTs = Date.now(); savePlaceImgs();
  $$('#reco-list .reco-thumb[data-id], #reco-wish-list .reco-thumb[data-id]').forEach(el => {
    const im = PLACE_IMG.get(el.dataset.id);
    if (im && im.thumb) { el.dataset.bg = httpsUrl(im.thumb); el.dataset.icon = 'image'; }
  });
  hydrateBg();
  if (PD && PD.kind === 'dest' && need.some(d => d.id === PD.d.id)) renderPlaceDetail();
}
const RECO_HEADS = ['이번엔 어디로 가볼까요?', '{r} 어때요?', '아직 안 가본 {r}', '다음 여행은 {r} 어떠세요?', '{r}에서 새로운 기록을 만들어요', '가을엔 {r}?'];
function recoHeadline(list) {   // 위 제목: 추천 목록의 지역 이름을 넣은 문구를 무작위로
  const regions = [...new Set(list.map(({ d }) => (d.cc === Z.homeCC ? nm(d.region) : countryName(d.cc))).filter(Boolean))];
  const pool = RECO_HEADS.filter(h => regions.length || !h.includes('{r}')).filter(h => !h.startsWith('가을엔') || [9, 10, 11].includes(thisMonth()));
  const rnd = (n) => Math.abs(Math.imul(recoSeed * 2654435761 + n * 97, 1597334677) >>> 0) / 4294967296;
  const head = pool[Math.floor(rnd(1) * pool.length)] || RECO_HEADS[0]; const r = regions[Math.floor(rnd(2) * regions.length)] || '';
  return tr(head, { r });
}
// 추천 탭 상단 세그먼트: 추천 행사 · 여행지 추천 · 즐겨찾기(별 누른 곳)
let recoSeg = (() => { try { return localStorage.getItem('photo-map-reco-seg') || 'fest'; } catch (e) { return 'fest'; } })();
function recoCard({ d, near, inSeason }) {
  const sub = d.cc === Z.homeCC ? (nm(d.region) || countryName(d.cc)) : countryName(d.cc);
  const nearTxt = near.name && near.km < 600 ? tr('다녀온 {name}에서 {km}km', { name: near.name, km: fmtN(near.km) }) : (d.cc !== Z.homeCC ? tr('처음 가는 나라') : '');
  const season = inSeason ? `<span class="ok">${icon('check-circle', 'ok')} ${tr('지금이 좋은 계절')}</span>` : (d.months.length ? `<span>${icon('calendar')} ${tr('{m}월이 좋아요', { m: monthsText(d.months) })}</span>` : '');
  const fest = activeFests().filter(x => hav([x.f.lon, x.f.lat], [d.lon, d.lat]) <= 40).length; const festTxt = fest ? `<span class="fest">${icon('sparkle')} ${tr('축제 {n}개', { n: fest })}</span>` : '';
  const im = PLACE_IMG.get(d.id);
  return { sub, nearTxt, season, festTxt, im };
}
function bindRecoCards(box) {
  const q = (sel) => Array.from(box.querySelectorAll(sel));
  q('.reco-star').forEach(b => b.addEventListener('click', (e) => { e.stopPropagation(); toggleWish(b.dataset.id); }));
  q('.reco-map').forEach(b => b.addEventListener('click', (e) => { e.stopPropagation(); const d = DEST.find(x => x.id === b.dataset.id); if (d) focusMapOn(d); }));
  q('.reco-card').forEach(c => c.addEventListener('click', () => { const d = DEST.find(x => x.id === c.dataset.id); if (d) openDestDetail(d); }));
}
function renderReco() {
  $$('#reco-seg button').forEach(b => b.classList.toggle('on', b.dataset.v === recoSeg));
  $('#reco-fest').hidden = recoSeg !== 'fest'; $('#reco-dest-sec').hidden = recoSeg !== 'dest'; $('#reco-wish-sec').hidden = recoSeg !== 'wish';
  renderFestivals();
  $$('#reco-scope .chip').forEach(b => b.classList.toggle('active', b.dataset.v === recoScope));
  $$('#reco-mode .chip').forEach(b => b.classList.toggle('active', b.dataset.v === recoMode));
  const list = computeReco(recoScope, recoSeed, recoMode).slice(0, 8); const box = $('#reco-list');
  $('#reco-dest-title').textContent = list.length ? (recoMode === 'all' ? recoHeadline(list) : recoMode === 'repeat' ? tr('다시 갈 만한 곳') : tr('안 가본 여행지')) : tr('이 범위에서는 추천할 곳이 없어요. 다른 범위를 골라 보세요.');
  if (!list.length) box.innerHTML = `<p class="caption">${tr('이 범위에서는 추천할 곳이 없어요. 다른 범위를 골라 보세요.')}</p>`;
  const cardHTML = (item) => { const { d, inSeason } = item; const { sub, nearTxt, season, festTxt, im } = recoCard(item);
    return `<div class="reco-card${inSeason ? ' now' : ''}" data-id="${d.id}" role="button" tabindex="0">${im && im.thumb ? `<div class="reco-thumb none" data-id="${d.id}" data-bg="${escH(httpsUrl(im.thumb))}" data-icon="image">${icon('image')}` : `<div class="reco-thumb none" data-id="${d.id}">${icon('image')}`}${ccBadge(d.cc)}</div><div class="reco-main"><div class="reco-head"><div class="reco-title"><div class="reco-name">${escH(nm(d.name))}</div><div class="reco-sub">${escH(sub)}</div></div><button type="button" class="reco-star${WISH.has(d.id) ? ' on' : ''}" data-id="${d.id}" aria-label="${tr('가고 싶어요')}">${WISH.has(d.id) ? icon('star') : icon('star-line')}</button></div><p class="reco-tag">${escH(nm(d.tag))}</p><div class="reco-foot"><div class="reco-meta">${season}${nearTxt ? `<span>${icon('pin')} ${escH(nearTxt)}</span>` : ''}${festTxt}</div><button type="button" class="reco-map" data-id="${d.id}" aria-label="${tr('지도에서 보기')}">${icon('map')}</button></div></div></div>`;
  };
  if (list.length) box.innerHTML = list.map(cardHTML).join('');
  bindRecoCards(box);
  // 즐겨찾기(별 누른 곳): 같은 카드 형식
  const month = new Date().getMonth() + 1;
  const wish = [...WISH].map(id => DEST.find(d => d.id === id)).filter(Boolean).map(d => ({ d, near: nearestVisited(d), inSeason: d.months.includes(month) }));
  const wbox = $('#reco-wish-list'); wbox.innerHTML = wish.map(cardHTML).join(''); bindRecoCards(wbox);
  $('#reco-wish-title').textContent = wish.length ? tr('가고 싶은 곳 {n}곳', { n: wish.length }) : tr('가고 싶은 곳');
  $('#reco-wish-note').hidden = wish.length > 0;
  hydrateBg(); loadPlaceImages(list.map(x => x.d).concat(wish.map(x => x.d)));
}
$$('#reco-seg button').forEach(b => b.addEventListener('click', () => { recoSeg = b.dataset.v; try { localStorage.setItem('photo-map-reco-seg', recoSeg); } catch (e) { /* ignore */ } renderReco(); window.scrollTo(0, 0); }));
function toggleWish(id) { if (WISH.has(id)) WISH.delete(id); else WISH.add(id); saveWish(); if (tab === 'reco') renderReco(); homeDraw(); mapRedraw(); if (PD && PD.kind === 'dest' && PD.d.id === id) renderPlaceDetail(); }
function focusMapOn(d) { mapFocus = d; openMap(); ME.cam.lon = d.lon; ME.cam.lat = d.lat; ME.cam.z = Math.max(ME.cam.z, 6.2); mapRegion = null; $$('#map-region .chip').forEach(b => b.classList.remove('active')); mapRedraw(); }
$$('#reco-scope .chip').forEach(b => b.addEventListener('click', () => { recoScope = b.dataset.v; try { localStorage.setItem('photo-map-reco-scope', recoScope); } catch (e) { /* ignore */ } renderReco(); }));
$$('#reco-mode .chip').forEach(b => b.addEventListener('click', () => { recoMode = b.dataset.v; try { localStorage.setItem('photo-map-reco-mode', recoMode); } catch (e) { /* ignore */ } renderReco(); }));
$('#reco-shuffle').addEventListener('click', () => { recoSeed = 1 + Math.floor(Math.random() * 1e6); renderReco(); scrollToRecoList(); });
async function refreshReco() {   // 당겨서 새로고침: 축제 목록 다시 받고 여행지도 새로 섞기
  festivals = null; festMeta = null; festTriedAt = 0; recoSeed = 1 + Math.floor(Math.random() * 1e6);
  await loadFestivals(); renderReco();
  if (recoSeg === 'dest') scrollToRecoList();   // 새로 섞인 여행지가 맨 위에 오게
}
// 여행지 목록의 첫 카드가 화면 맨 위에 오도록 스크롤(새로고침·다른 곳 보기 뒤)
function scrollToRecoList() { const el = $('#reco-list'); if (!el) return; const y = el.getBoundingClientRect().top + window.scrollY - 8; window.scrollTo({ top: Math.max(0, y), behavior: 'smooth' }); }
(() => {   // 추천 탭 맨 위에서 아래로 당기면 새로고침
  const page = document.querySelector('.page[data-page="reco"]'); if (!page) return;
  const ind = document.createElement('div'); ind.className = 'ptr'; ind.innerHTML = '<i></i><span></span>'; page.prepend(ind); const label = ind.querySelector('span');
  let y0 = null, pulled = 0, busy = false; const THRESH = 110;
  const setH = (px) => { ind.style.height = px + 'px'; };
  document.addEventListener('touchstart', (e) => { if (busy || tab !== 'reco' || page.hidden || window.scrollY > 0 || !$('#place-detail').hidden || !$('#fest-list').hidden) { y0 = null; return; } y0 = e.touches[0].clientY; pulled = 0; }, { passive: true });
  document.addEventListener('touchmove', (e) => { if (y0 == null) return; pulled = Math.max(0, e.touches[0].clientY - y0); if (window.scrollY > 0) pulled = 0; setH(Math.min(pulled * 0.45, 56)); label.textContent = pulled >= THRESH ? tr('놓으면 새로고침') : tr('당겨서 새로고침'); ind.classList.toggle('ready', pulled >= THRESH); }, { passive: true });
  document.addEventListener('touchend', () => { if (y0 == null) return; const go = pulled >= THRESH; y0 = null; if (!go) { ind.classList.remove('ready'); setH(0); return; } busy = true; ind.classList.add('busy'); label.textContent = tr('새로 고치는 중…'); setH(44); refreshReco().catch(() => {}).finally(() => { busy = false; ind.classList.remove('busy', 'ready'); setH(0); }); }, { passive: true });
})();

// ---- 장소 상세 화면: 축제(서버 /festivals/{id} 사진·공고·소개) 또는 여행지(대표 사진·가볼 만한 곳·근처 축제) + 네이버 블로그 후기(/blogs) ----
let PD = null; const pdStack = [];
const pdEl = () => $('#place-detail');
function openPlaceDetail(pd) {
  if (PD) pdStack.push(PD); PD = pd;
  const el = pdEl(); el.hidden = false; el.scrollTop = 0; el.classList.remove('scrolled'); document.body.style.overflow = 'hidden';
  renderPlaceDetail(); loadPlaceDetail(pd);
}
function pdBack() { PD = pdStack.pop() || null; if (PD) { pdEl().scrollTop = 0; renderPlaceDetail(); loadPlaceDetail(PD); } else { pdEl().hidden = true; if ($('#fest-list').hidden) document.body.style.overflow = ''; } }
$('#pd-back').addEventListener('click', pdBack);
pdEl().addEventListener('scroll', () => pdEl().classList.toggle('scrolled', pdEl().scrollTop > 140), { passive: true });
function openFestDetail(f) { openPlaceDetail({ kind: 'fest', f, detail: null, blogs: null, loading: true }); }
function openDestDetail(d) { openPlaceDetail({ kind: 'dest', d, spots: null, blogs: null, loading: true }); }
async function loadPlaceDetail(pd) {
  const srv = SRV(); const lang = I18N ? I18N.lang : 'ko';
  const alive = () => PD === pd;
  if (pd.kind === 'fest') {
    if (srv && !pd.detail) { try { pd.detail = await srv.api('GET', `/festivals/${encodeURIComponent(pd.f.id)}?lang=${lang}`); const d = pd.detail; if (d && !d.error && !pd.f.title) Object.assign(pd.f, { title: d.title, addr: d.addr, start: d.start, end: d.end, image: d.image, lat: d.lat || 0, lon: d.lon || 0, url: d.url }); } catch (e) { pd.detail = { error: (e && e.code) || 'error' }; } }
    pd.loading = false; if (alive()) renderPlaceDetail();
    if (lang === 'ko' && srv && !pd.blogs) { try { pd.blogs = await srv.api('GET', '/blogs?q=' + encodeURIComponent(pd.f.title)); } catch (e) { pd.blogs = { items: [], reason: 'network' }; } if (alive()) renderPlaceDetail(); }
  } else {
    const d = pd.d;
    if (srv && !pd.spots && d.cc === 'KR') { try { pd.spots = await srv.api('GET', `/places/spots?lang=${lang}&cc=KR&q=` + encodeURIComponent(d.name.ko) + '&hint=' + encodeURIComponent((d.tag && d.tag.ko) || '')); } catch (e) { pd.spots = { items: [] }; } }
    if (!PLACE_IMG.has(d.id)) await loadPlaceImages([d]);
    pd.loading = false; if (alive()) renderPlaceDetail();
    if (lang === 'ko' && srv && !pd.blogs) { try { pd.blogs = await srv.api('GET', '/blogs?q=' + encodeURIComponent(d.name.ko + ' 여행')); } catch (e) { pd.blogs = { items: [], reason: 'network' }; } if (alive()) renderPlaceDetail(); }
  }
}
const naverSearchUrl = (q) => 'https://m.search.naver.com/search.naver?ssc=tab.m_blog.all&query=' + encodeURIComponent(q);
const webSearchUrl = (q) => 'https://www.google.com/search?q=' + encodeURIComponent(q);
function renderGallery(images, credit) {
  const g = $('#pd-gallery');
  if (!images.length) { g.innerHTML = `<div class="pd-gallery-scroll"><div class="pd-img none">${icon('image')}</div></div>`; return; }
  g.innerHTML = `<div class="pd-gallery-scroll">${images.map(im => `<div class="pd-img" data-bg="${escH(httpsUrl(im.url))}" data-icon="image" role="img" aria-label="${escH(im.name || '')}"></div>`).join('')}</div>${images.length > 1 ? `<span class="pd-count">1/${images.length}</span>` : ''}${credit ? `<span class="pd-credit">${escH(credit)}</span>` : ''}`;
  const sc = g.querySelector('.pd-gallery-scroll'); const cnt = g.querySelector('.pd-count');
  if (cnt) sc.addEventListener('scroll', () => { cnt.textContent = `${Math.round(sc.scrollLeft / sc.clientWidth) + 1}/${images.length}`; }, { passive: true });
  hydrateBg();
}
const pdRow = (k, v, html) => (v ? `<div class="pd-row"><div class="pd-k">${escH(k)}</div><div class="pd-v">${html ? v : escH(v)}</div></div>` : '');
const actBtn = (id, ic, label, cls) => `<button type="button" id="${id}" class="${cls || ''}">${icon(ic)}<span>${escH(label)}</span></button>`;
function renderBlogs(pd, q) {
  const sec = $('#pd-blogs-sec'); const lang = I18N ? I18N.lang : 'ko';
  if (lang !== 'ko') { sec.hidden = true; return; }
  sec.hidden = false; const box = $('#pd-blogs'); let b = pd.blogs;
  $('#pd-blogs-more').onclick = () => openExternal((b && b.searchUrl) || naverSearchUrl(q));
  if (!b && !SRV()) { b = pd.blogs = { items: [], reason: 'independent', searchUrl: naverSearchUrl(q) }; }
  const reviews = pd.blogs;
  if (!reviews) { box.innerHTML = `<div class="pd-loading"><i></i>${tr('후기를 찾는 중…')}</div>`; return; }
  if (!b.items || !b.items.length) { box.innerHTML = `<p class="blog-empty">${b.reason ? tr('후기를 아직 불러올 수 없어요. 블로그에서 직접 찾아볼 수 있어요.') : tr('아직 후기가 없어요.')}</p>`; return; }
  box.innerHTML = b.items.slice(0, 6).map((it, i) => `<button type="button" class="blog-row" data-i="${i}">${imgDiv('blog-img', it.image, 'tag')}</div><div class="blog-body"><div class="blog-title">${escH(it.title)}</div><div class="blog-desc">${escH(it.desc)}</div><div class="blog-meta">${escH([it.blogger, fmtYmdFull(it.date)].filter(Boolean).join(' · '))}</div></div></button>`).join('');
  $$('#pd-blogs .blog-row').forEach(el => el.addEventListener('click', () => openExternal(b.items[+el.dataset.i].link)));
  hydrateBg();
}
function renderPlaceDetail() {
  const pd = PD; if (!pd) return; const lang = I18N ? I18N.lang : 'ko';
  const star = $('#pd-star'); const actions = $('#pd-actions'); const info = $('#pd-info'); const badges = $('#pd-badges');
  $('#pd-overview-sec').hidden = true; $('#pd-spots-sec').hidden = true; $('#pd-fests-sec').hidden = true; star.hidden = true;
  if (pd.kind === 'fest') {
    const f = pd.f, d = pd.detail && !pd.detail.error ? pd.detail : null; const st = festStatus(f);
    const title = (d && d.title) || f.title; $('#pd-top-title').textContent = title; $('#pd-title').textContent = title;
    badges.innerHTML = `<span class="badge ${st.kind}">${escH(st.label)}</span>${d && d.grade ? `<span class="badge grey">${escH(d.grade)}</span>` : ''}`;
    $('#pd-sub').textContent = [fmtRange(f.start, f.end), addrShort((d && d.addr) || f.addr)].filter(Boolean).join(' · ');
    const images = d && d.images && d.images.length ? d.images : (f.imageLarge || f.image ? [{ url: f.imageLarge || f.image }] : []);
    renderGallery(images, tr('사진: {credit}', { credit: tr('한국관광공사') }));
    const home = d && d.homepage; const tel = ((d && d.tel) || f.tel || '').replace(/[^\d+\-]/g, '');
    actions.innerHTML = actBtn('pd-act-map', 'map', tr('지도에서 보기')) + actBtn('pd-act-share', 'share', tr('공유'), 'grey') + (home ? actBtn('pd-act-home', 'link', tr('홈페이지'), 'grey') : '') + (tel ? actBtn('pd-act-tel', 'phone', tr('전화'), 'grey') : '') + (lang !== 'ko' ? actBtn('pd-act-web', 'search', tr('웹에서 검색'), 'grey') : '');
    $('#pd-act-share').onclick = () => { const base = SRV() ? SRV().base : ''; shareText(`${title} · ${fmtRange(f.start, f.end)}${f.addr ? ' · ' + addrShort(f.addr) : ''}`, base ? `${base}/p/fest/${encodeURIComponent(f.id)}?lang=${lang}` : (f.url || ''), title); };
    $('#pd-act-map').onclick = () => { closeAllDetail(); focusMapOn({ id: 'fest:' + f.id, name: { ko: title }, lon: f.lon, lat: f.lat }); };
    if (home) $('#pd-act-home').onclick = () => openExternal(home);
    if (tel) $('#pd-act-tel').onclick = () => openExternal('tel:' + tel);
    if (lang !== 'ko') $('#pd-act-web').onclick = () => openExternal(webSearchUrl(title));
    if (pd.loading && !d) info.innerHTML = `<div class="pd-loading"><i></i>${tr('불러오는 중…')}</div>`;
    else info.innerHTML = pdRow(tr('기간'), fmtRange(f.start, f.end)) + pdRow(tr('장소'), (d && d.place) || (d && d.addr) || f.addr) + pdRow(tr('시간'), d && d.playtime) + pdRow(tr('요금'), d && d.fee) + pdRow(tr('주최'), d && [d.sponsor, d.sponsor2].filter(Boolean).join(' · ')) + pdRow(tr('문의'), (d && d.tel) || f.tel) + pdRow(tr('프로그램'), d && d.program) + pdRow(tr('연령'), d && d.agelimit) + (pd.detail && pd.detail.error && pd.detail.error !== 'no_key' ? `<div class="pd-row"><div class="pd-v">${tr('자세한 정보를 불러오지 못했어요.')}</div></div>` : '');
    if (d && d.overview) { $('#pd-overview-sec').hidden = false; const ov = $('#pd-overview'); ov.textContent = d.overview; ov.classList.remove('open'); const more = $('#pd-overview-more'); more.hidden = d.overview.length < 160; more.textContent = tr('더 보기'); more.onclick = () => { const open = ov.classList.toggle('open'); more.textContent = open ? tr('접기') : tr('더 보기'); }; }
    renderBlogs(pd, title);
    $('#pd-source').innerHTML = `${tr('한국관광공사 관광정보 · 일정은 변경될 수 있으니 방문 전에 확인해 주세요')}${f.url ? ` · <button type="button" class="link-btn" id="pd-src-link">${tr('관광공사에서 보기')}</button>` : ''}`;
    const sl = $('#pd-src-link'); if (sl) sl.onclick = () => openExternal(f.url);
  } else {
    const d = pd.d; const name = nm(d.name); const month = thisMonth(); const inSeason = d.months.includes(month); const near = nearestVisited(d);
    $('#pd-top-title').textContent = name; $('#pd-title').textContent = name;
    star.hidden = false; star.classList.toggle('on', WISH.has(d.id)); star.innerHTML = WISH.has(d.id) ? icon('star') : icon('star-line'); star.onclick = () => toggleWish(d.id);
    badges.innerHTML = (inSeason ? `<span class="badge on">${tr('지금이 좋은 계절')}</span>` : (d.months.length ? `<span class="badge grey">${tr('{m}월이 좋아요', { m: monthsText(d.months) })}</span>` : '')) + (d.cc !== Z.homeCC && !Z.zones.some(z => z.cc === d.cc) ? `<span class="badge grey">${tr('처음 가는 나라')}</span>` : '');
    $('#pd-sub').textContent = [ccBadge(d.cc) ? (d.cc === Z.homeCC ? nm(d.region) : [nm(d.region), countryName(d.cc)].filter(Boolean).join(', ')) : '', nm(d.tag)].filter(Boolean).join(' · ');
    const im = PLACE_IMG.get(d.id); const spots = (pd.spots && pd.spots.items) || [];
    const images = []; if (im && im.url) images.push({ url: im.url, name: im.title || name }); for (const s of spots.slice(0, 6)) if (s.image && !images.some(x => x.url === s.image)) images.push({ url: s.image, name: s.title });
    renderGallery(images, im ? tr('사진: {credit}', { credit: im.source === 'wikipedia' ? 'Wikimedia Commons' : tr('한국관광공사') }) : '');
    actions.innerHTML = actBtn('pd-act-map', 'map', tr('지도에서 보기')) + actBtn('pd-act-wish', WISH.has(d.id) ? 'star' : 'star-line', tr('가고 싶어요'), WISH.has(d.id) ? 'on' : 'grey') + actBtn('pd-act-share', 'share', tr('공유'), 'grey') + (lang !== 'ko' ? actBtn('pd-act-web', 'search', tr('웹에서 검색'), 'grey') : '');
    $('#pd-act-share').onclick = () => { const base = SRV() ? SRV().base : ''; const qs = new URLSearchParams({ lang, name: d.name.ko, en: d.name.en || '', sub: d.cc === Z.homeCC ? nm(d.region) : [nm(d.region), countryName(d.cc)].filter(Boolean).join(', '), tag: d.tag.ko || '', cc: d.cc, months: d.months.length ? tr('{m}월이 좋아요', { m: monthsText(d.months) }) : '', lat: d.lat, lon: d.lon }); shareText(`${name} · ${nm(d.tag)}`, base ? `${base}/p/place/${encodeURIComponent(d.id)}?${qs}` : '', name); };
    $('#pd-act-map').onclick = () => { closeAllDetail(); focusMapOn(d); };
    $('#pd-act-wish').onclick = () => toggleWish(d.id);
    if (lang !== 'ko') $('#pd-act-web').onclick = () => openExternal(webSearchUrl(`${name} ${lang === 'ja' ? '旅行' : 'travel'}`));
    info.innerHTML = pdRow(tr('좋은 시기'), d.months.length ? tr('{m}월이 좋아요', { m: monthsText(d.months) }) : '') + pdRow(tr('지역'), d.cc === Z.homeCC ? nm(d.region) : [nm(d.region), countryName(d.cc)].filter(Boolean).join(', ')) + pdRow(tr('다녀온 곳'), near.name && near.km < 600 ? tr('{name} · {km}km', { name: near.name, km: fmtN(near.km) }) : '');
    if (spots.length) { $('#pd-spots-sec').hidden = false; $('#pd-spots').innerHTML = spots.slice(0, 12).map((s, i) => `<button type="button" class="spot-card" data-i="${i}"><div class="spot-img" data-bg="${escH(httpsUrl(s.thumb || s.image))}" data-icon="image"></div><div class="spot-name">${escH(s.title)}</div><div class="spot-addr">${escH(addrShort(s.addr))}</div></button>`).join(''); $$('#pd-spots .spot-card').forEach(el => el.addEventListener('click', () => { const s = spots[+el.dataset.i]; if (s.url) openExternal(s.url); })); }
    else if (pd.loading && d.cc === 'KR') { $('#pd-spots-sec').hidden = false; $('#pd-spots').innerHTML = `<div class="pd-loading"><i></i>${tr('불러오는 중…')}</div>`; }
    const fests = activeFests().map(x => Object.assign({}, x, { km: hav([x.f.lon, x.f.lat], [d.lon, d.lat]) })).filter(x => x.km <= 60).sort((a, b) => a.km - b.km).slice(0, 5);
    if (fests.length) { $('#pd-fests-sec').hidden = false; $('#pd-fests').innerHTML = fests.map(({ f, st, km }) => `<button type="button" class="fest-row" data-id="${escH(f.id)}">${imgDiv('fest-row-img', f.image)}</div><div class="fest-row-body"><div class="fest-row-title">${escH(f.title)}</div><div class="fest-row-meta"><span class="${st.kind}">${escH(st.label)}</span> · ${escH(fmtRange(f.start, f.end))}</div><div class="fest-row-meta">${escH(addrShort(f.addr))} · ${fmtN(km)}km</div></div><span class="chev"></span></button>`).join(''); $$('#pd-fests .fest-row').forEach(el => el.addEventListener('click', () => { const f = festivals.find(x => x.id === el.dataset.id); if (f) openFestDetail(f); })); }
    renderBlogs(pd, d.name.ko + ' 여행');
    $('#pd-source').innerHTML = im ? (im.source === 'wikipedia' ? `${tr('사진: {credit}', { credit: 'Wikimedia Commons' })}${im.page ? ` · <button type="button" class="link-btn" id="pd-src-link">${tr('출처 보기')}</button>` : ''}` : tr('사진·명소 정보: 한국관광공사')) : '';
    const sl = $('#pd-src-link'); if (sl) sl.onclick = () => openExternal(im.page);
  }
  hydrateBg();
}
function closeAllDetail() { pdStack.length = 0; PD = null; pdEl().hidden = true; $('#fest-list').hidden = true; document.body.style.overflow = ''; }


// ---------- 기록 탭: 여권(다녀온 시·군·구·해외 지역·나라마다 도장) + 영상 만들기 ----------
const PASSPORT_INKS = ['#1B64DA', '#C0392B', '#1E8E3E', '#7A4FE0', '#B26A00', '#0F7C8C'];
const hash32 = (str) => { let h = 2166136261; for (let i = 0; i < str.length; i++) { h ^= str.charCodeAt(i); h = Math.imul(h, 16777619) >>> 0; } return h; };
function buildStamps() {   // 도장 목록: 지역(REG.byCode) + 해외 나라, 처음 간 날짜순
  const lang = I18N ? I18N.lang : 'ko'; const byKey = new Map(Z.zones.map(z => [z.key, z])); const out = [];
  const firstOf = (keys) => { let best = null; for (const k of keys) { const z = byKey.get(k); if (z && z.first && (!best || z.first < best)) best = z.first; } return best; };
  const range0 = (DATA.meta && DATA.meta.range && DATA.meta.range[0]) || '';
  for (const r of REG.byCode.values()) {
    const pr = (r.f && r.f.properties) || {}; const name = (lang === 'ko' ? pr.ko : lang === 'ja' ? pr.ja : null) || r.name || '';
    const tripKeys = [...r.zones].filter(k => k !== 'home'); if (!name || !tripKeys.length) continue;   // 집 동네(집 사진으로만 칠해진 구역)는 여행 도장이 아님
    out.push({ kind: 'region', key: 'r:' + r.code, name, cc: r.cc, date: firstOf(tripKeys) || range0, n: r.n });
  }
  const ccFirst = new Map();
  for (const z of Z.zones) { if (!z.cc || z.cc === Z.homeCC) continue; const cur = ccFirst.get(z.cc); if (!cur || z.first < cur) ccFirst.set(z.cc, z.first); }
  for (const [cc, first] of ccFirst) out.push({ kind: 'country', key: 'c:' + cc, name: countryName(cc), cc, date: first });
  out.sort((a, b) => String(a.date).localeCompare(String(b.date)) || a.name.localeCompare(b.name));
  return out;
}
const PASSPORT_PER_PAGE = 24;   // 여권 한 페이지 = 도장 24개(4×6, 빽빽하게). 넘치면 다음 페이지, 적으면 페이지가 짧아진다
function passportBookStamps(book) { const all = buildStamps(); return book === 'all' ? all : all.filter(st => String(st.date || '').slice(0, 4) === String(book)); }
function drawPassportPage(canvas, W, stamps, o) {   // o: { story, book, page, pages, total }. story=true 면 1080×1920 고정(위아래 12% 안전 영역), 아니면 도장 줄 수만큼의 높이
  const u = W / 1080; const cols = stamps.length <= 6 ? 3 : 4; const pad = 36 * u; const areaW = W - pad * 2; const rows = Math.max(1, Math.ceil(stamps.length / cols));
  const HEAD = 300 * u, FOOT = 110 * u;
  const H = o.story ? Math.round(W * 16 / 9) : Math.round(HEAD + rows * (areaW / cols) + FOOT);
  const cell = o.story ? Math.min(areaW / cols, (H * 0.76 - HEAD - FOOT) / rows) : areaW / cols;   // 스토리는 안전 영역 안에 맞춰 줄임
  canvas.width = W; canvas.height = H; const ctx = canvas.getContext('2d');
  const font = (w, px) => `${w} ${Math.round(px)}px ${PhotoMapEngine.FONT || '-apple-system, "Apple SD Gothic Neo", "Noto Sans KR", sans-serif'}`;
  ctx.fillStyle = '#FBF7EE'; ctx.fillRect(0, 0, W, H);
  ctx.save(); ctx.globalAlpha = 0.5; ctx.fillStyle = '#F3EBD9'; for (let i = 0; i < 30; i++) { const x = (hash32('x' + i + o.page) % W), y = (hash32('y' + i + o.page) % H); ctx.beginPath(); ctx.arc(x, y, 60 * u, 0, Math.PI * 2); ctx.fill(); } ctx.restore();   // 종이 질감 느낌
  const top = o.story ? H * 0.12 : 0, bottom = o.story ? H * 0.88 : H;
  ctx.strokeStyle = '#E2D7BF'; ctx.lineWidth = 2 * u; ctx.beginPath(); ctx.roundRect(pad * 0.7, top + pad * 0.7, W - pad * 1.4, (bottom - top) - pad * 1.4, 34 * u); ctx.stroke();
  ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
  const spaced = (text, x, y, sp) => { const w = [...text].reduce((acc, ch) => acc + ctx.measureText(ch).width + sp, -sp); let cx = x - w / 2; ctx.textAlign = 'left'; for (const ch of text) { ctx.fillText(ch, cx, y); cx += ctx.measureText(ch).width + sp; } ctx.textAlign = 'center'; };
  ctx.fillStyle = '#8B7E66'; ctx.font = font(600, 22 * u); spaced('TRAVEL PASSPORT', W / 2, top + 78 * u, 7 * u);
  ctx.fillStyle = '#191F28'; ctx.font = font(800, 60 * u); ctx.fillText(tr('우리 가족 여행'), W / 2, top + 138 * u);
  ctx.fillStyle = '#6B7684'; ctx.font = font(500, 25 * u); ctx.fillText(o.book !== 'all' ? tr('{y}년의 여행', { y: o.book }) : tr('사진으로 기록하는 나의 여행일기'), W / 2, top + 188 * u);
  const all = o.all || stamps; const regions = all.filter(x => x.kind === 'region').length; const countries = o.book === 'all' ? (Z.countries || 0) : new Set(all.map(x => x.cc).filter(Boolean)).size; const since = ((DATA.meta && DATA.meta.range && DATA.meta.range[0]) || '').slice(0, 4);
  ctx.fillStyle = '#3182F6'; ctx.font = font(700, 28 * u); ctx.fillText(o.book !== 'all' ? tr('{a}개국 · 지역 {b}곳', { a: countries, b: regions }) : tr('{a}개국 · 지역 {b}곳 · since {y}', { a: countries, b: regions, y: since || '—' }), W / 2, top + 236 * u);
  ctx.save(); ctx.setLineDash([8 * u, 8 * u]); ctx.strokeStyle = '#D9CDB3'; ctx.beginPath(); ctx.moveTo(pad * 1.6, top + 274 * u); ctx.lineTo(W - pad * 1.6, top + 274 * u); ctx.stroke(); ctx.restore();
  const footerY = bottom - 56 * u;
  ctx.fillStyle = '#8B95A1'; ctx.font = font(500, 22 * u); ctx.fillText(`${tr('도장 {n}개', { n: all.length })} · ${tr('우리 가족 여행')}`, W / 2, footerY);
  if (o.pages > 1) { ctx.textAlign = 'right'; ctx.fillText(`${o.page + 1} / ${o.pages}`, W - pad * 1.2, footerY); ctx.textAlign = 'center'; }
  if (!stamps.length) { ctx.fillStyle = '#8B95A1'; ctx.font = font(500, 30 * u); ctx.fillText(tr('아직 도장이 없어요. 여행을 다녀오면 여기에 찍혀요.'), W / 2, (top + 340 * u + footerY) / 2); return; }
  const areaTop = top + HEAD, areaH = footerY - 30 * u - areaTop; const gridH = rows * cell; const gx = (W - cols * cell) / 2; const y0 = areaTop + (o.story ? Math.max(0, (areaH - gridH) / 2) : 0);
  stamps.forEach((st, i) => {   // 실제 여권처럼 살짝 겹치고 비뚤게: 칸보다 조금 큰 도장 + 칸 안에서 무작위로 조금 밀림
    const hsh = hash32(st.key); const jx = ((hsh >> 4) % 17 - 8) / 100 * cell, jy = ((hsh >> 12) % 17 - 8) / 100 * cell;
    const cx = gx + (i % cols) * cell + cell / 2 + jx, cy = y0 + Math.floor(i / cols) * cell + cell / 2 + jy; const ink = PASSPORT_INKS[hsh % PASSPORT_INKS.length]; const rot = ((hsh >> 8) % 25 - 12) * Math.PI / 180; const r = cell * 0.5;
    ctx.save(); ctx.translate(cx, cy); ctx.rotate(rot); ctx.globalAlpha = 0.88; ctx.strokeStyle = ink; ctx.fillStyle = ink; ctx.lineJoin = 'round';
    if (st.kind === 'country') { ctx.lineWidth = 4 * u; ctx.beginPath(); ctx.arc(0, 0, r, 0, Math.PI * 2); ctx.stroke(); ctx.lineWidth = 1.5 * u; ctx.setLineDash([5 * u, 4 * u]); ctx.beginPath(); ctx.arc(0, 0, r * 0.86, 0, Math.PI * 2); ctx.stroke(); ctx.setLineDash([]); }
    else { const w = r * 1.9, hh = r * 1.55; ctx.lineWidth = 3.5 * u; ctx.beginPath(); ctx.roundRect(-w / 2, -hh / 2, w, hh, 14 * u); ctx.stroke(); ctx.lineWidth = 1.4 * u; ctx.setLineDash([5 * u, 4 * u]); ctx.beginPath(); ctx.roundRect(-w / 2 + 7 * u, -hh / 2 + 7 * u, w - 14 * u, hh - 14 * u, 10 * u); ctx.stroke(); ctx.setLineDash([]); }
    ctx.font = font(700, 16 * u); ctx.fillText((st.kind === 'country' ? 'VISITED' : (st.cc || '').toUpperCase()), 0, -r * (st.kind === 'country' ? 0.52 : 0.48));
    let size = r * (st.kind === 'country' ? 0.34 : 0.3); ctx.font = font(800, size); const maxW = (st.kind === 'country' ? r * 1.6 : r * 1.65); while (ctx.measureText(st.name).width > maxW && size > 9 * u) { size *= 0.92; ctx.font = font(800, size); }
    ctx.fillText(st.name, 0, r * 0.02);
    const d = String(st.date || ''); const dt = d.length >= 7 ? `${d.slice(0, 4)}.${d.slice(5, 7)}` : d.slice(0, 4);
    ctx.font = font(600, r * 0.2); ctx.fillText(dt, 0, r * (st.kind === 'country' ? 0.42 : 0.4));
    ctx.restore();
  });
}
let passportBook = 'all', passportPages = [], passportIdx = 0, passportAll = [];
function renderRecord() {   // 책: 전체 또는 연도(칩), 페이지: 12개씩(옆으로 넘김). 보이는 페이지만 그린다
  $$('#record-seg button').forEach(b => b.classList.toggle('on', b.dataset.v === 'passport'));
  const stamps = buildStamps(); const years = [...new Set(stamps.map(st => String(st.date || '').slice(0, 4)).filter(y => /^\d{4}$/.test(y)))].sort().reverse();
  if (passportBook !== 'all' && !years.includes(passportBook)) passportBook = 'all';
  const books = ['all'].concat(years);
  $('#passport-years').innerHTML = books.map(y => `<button type="button" class="chip${y === passportBook ? ' active' : ''}" data-y="${y}">${y === 'all' ? tr('전체 보기|passport') : tr('{y}년', { y })}</button>`).join('');
  $('#passport-years').hidden = books.length <= 1;
  $$('#passport-years .chip').forEach(b => b.addEventListener('click', () => { passportBook = b.dataset.y; passportIdx = 0; renderRecord(); }));
  passportAll = passportBookStamps(passportBook); passportPages = []; for (let i = 0; i < passportAll.length; i += PASSPORT_PER_PAGE) passportPages.push(passportAll.slice(i, i + PASSPORT_PER_PAGE)); if (!passportPages.length) passportPages.push([]);
  passportIdx = Math.min(passportIdx, passportPages.length - 1);
  const wrap = $('#passport-pages'); wrap.innerHTML = passportPages.map((_, i) => `<div class="passport-page" data-i="${i}"><canvas width="720" height="720"></canvas></div>`).join('');
  const dots = $('#passport-dots'); dots.innerHTML = passportPages.length > 1 ? passportPages.map((_, i) => `<i class="${i === passportIdx ? 'on' : ''}"></i>`).join('') : '';
  const drawn = new Set(); const drawPage = (i) => { if (drawn.has(i) || i < 0 || i >= passportPages.length) return; const cv = wrap.children[i].querySelector('canvas'); drawPassportPage(cv, 720, passportPages[i], { story: false, book: passportBook, page: i, pages: passportPages.length, all: passportAll }); drawn.add(i); };
  drawPage(passportIdx); drawPage(passportIdx + 1);
  wrap.onscroll = () => { const w = wrap.clientWidth || 1; const i = Math.round(wrap.scrollLeft / w); if (i !== passportIdx) { passportIdx = i; $$('#passport-dots i').forEach((d, k) => d.classList.toggle('on', k === i)); } drawPage(i); drawPage(i + 1); };
  if (passportIdx > 0) { const el = wrap.children[passportIdx]; if (el) wrap.scrollLeft = el.offsetLeft - wrap.offsetLeft - 20; }
  $('#passport-status').textContent = stamps.length ? (passportPages.length > 1 ? tr('옆으로 넘기면 다음 페이지가 나와요.') : '') : tr('아직 도장이 없어요. 여행을 다녀오면 여기에 찍혀요.');
}
$$('#record-seg button').forEach(b => b.addEventListener('click', () => { if (b.dataset.v === 'video') goStep(2); else renderRecord(); }));
$('#passport-share').addEventListener('click', async () => {
  const st = $('#passport-status'); st.textContent = tr('이미지를 만들고 있어요…');
  try {
    const hidden = document.createElement('canvas'); drawPassportPage(hidden, 1080, passportPages[passportIdx] || [], { story: true, book: passportBook, page: passportIdx, pages: passportPages.length, all: passportAll });   // 지금 펼친 페이지를 스토리 크기로
    const blob = await new Promise((res) => hidden.toBlob(res, 'image/png')); const name = `travel-passport-${passportBook}-${passportIdx + 1}-${isoToday()}.png`;
    if (window.__onVideoReady) { st.textContent = tr('공유 창에서 "이미지 저장"을 누르면 사진 앱에 저장돼요.'); window.__onVideoReady(blob, name); }
    else { const a = document.createElement('a'); a.href = URL.createObjectURL(blob); a.download = name; document.body.appendChild(a); a.click(); a.remove(); st.textContent = tr('이미지가 준비됐어요'); }
  } catch (e) { st.textContent = tr('이미지를 만들지 못했어요: {msg}', { msg: e.message }); }
});

// ---------- 시작 ----------
if (!window.__workerURL) { try { window.__workerURL = new URL('render-worker.js', location.href).href; } catch (e) { window.__workerURL = null; } }
if (qp.has('norender')) window.__norender = true;
if (qp.has('premium')) setTimeout(() => { if (typeof openPremium === 'function') openPremium(); }, 800);
const QMAP = { trip: 'selection', map: 'mapMode', aspect: 'aspect', camera: 'camera', theme: 'theme', duration: 'duration', short: 'includeShort', tiles: 'tiles', title: 'title' };
for (const [q, key] of Object.entries(QMAP)) if (qp.has(q)) S[key] = key === 'includeShort' ? qp.get(q) === '1' : qp.get(q);
if (S.tiles !== 'none' && !(S.tiles in TILE_STYLES)) S.tiles = 'esri';   // '내장 지도(오프라인)' 선택이 재실행 때 esri 로 되돌아가던 버그
enforceFree(); syncUI(); renderTrips(); rebuild();
(() => { const d = $('#wm-desc'); if (d) d.textContent = tr('영상·이미지 우측 하단 "{wm}"', { wm: E.watermarkText }); })();
nlog('settings ' + JSON.stringify({ tiles: S.tiles, map: S.mapMode, theme: S.theme, aspect: S.aspect, premium, lang: S.lang, home: DATA.home && DATA.home.name, trip0: DATA.trips[0] && DATA.trips[0].title }));   // 기기 로그로 언어·지명 언어 확인용
if (NATIVE) { const pill = $('#btn-premium'); pill.hidden = false; pill.textContent = premium ? tr('프리미엄 사용 중') : tr('프리미엄'); pill.classList.toggle('on', premium); try { window.webkit.messageHandlers.premiumInfo.postMessage({}); } catch (e) { /* ignore */ } }
/* R117: Cold starts always open diary; explicit ?tab= and ?step= routes remain supported. */
goStep(qp.has('step') ? +qp.get('step') : qp.has('tab') ? (tab = qp.get('tab'), 0) : (() => { const h = parseInt((location.hash || '').slice(1), 10); return Number.isFinite(h) && h >= 2 ? h : homeStep(); })());   // 해시는 2~5단계만 복원, 그 외엔 홈(두 번째 실행부터) 또는 소개
if (qp.has('t')) seekTo(+qp.get('t') || 0, true);
// 첫 실행 안내: 아직 안 봤고 홈 화면이면(사진 없음 화면·특정 단계 지정이 아닐 때) 잠시 뒤 튜토리얼
(() => { let seen = false; try { seen = localStorage.getItem('photo-map-tutorial.v1') === '1'; } catch (e) { /* ignore */ }   // TUT_KEY 상수는 아래에서 선언되므로(TDZ) 여기선 문자열 그대로
  if (seen || qp.has('notut') || qp.has('step') || qp.has('t') || step !== 0 || tab !== 'home') return;
  setTimeout(() => { if (step === 0 && tab === 'home' && $('#empty-root').hidden && !mapOpen) { nlog('tutorial auto-show (kv restored ' + (window.__kvRestored == null ? 'n/a' : window.__kvRestored) + ')'); try { localStorage.setItem('photo-map-tutorial.v1', '1'); } catch (e) { /* ignore */ } startTutorial(0); } }, 900); })();   // 뜨는 순간 '본 적 있음' 기록: 중간에 앱을 꺼도 다시 안 뜬다(설정에서 다시 볼 수 있음)
if (qp.get('autoplay') === '1') setPlaying(true);
if (qp.has('render')) { window.__renderDone = (bytes, ms) => { document.title = `render ok bytes=${bytes} ms=${Math.round(ms)} total=${E.TL.total.toFixed(1)}s`; }; setTimeout(() => { if (!canRender()) document.title = 'render unsupported'; else renderVideo().catch(e => { document.title = 'render error ' + e.message; }); }, 300); }
if (qp.has('bench')) { const N = 60; const t0 = performance.now(); for (let i = 0; i < N; i++) { T = (i / N) * E.TL.total; E.snapCamera(E.stateAt(T)); E.draw(T); } const ms1 = (performance.now() - t0) / N; const t1 = performance.now(); for (let i = 0; i < N; i++) E.draw(T); document.title = `bench moving=${ms1.toFixed(1)}ms static=${((performance.now() - t1) / N).toFixed(1)}ms seq=${E.SEQ.length} total=${E.TL.total.toFixed(1)}s`; T = 0; E.snapCamera(E.stateAt(0)); dirty = true; }
if (qp.has('check')) setTimeout(() => { const cs = (sel) => getComputedStyle($(sel)).display; document.title = `check sw=${document.documentElement.scrollWidth} iw=${innerWidth} bodyW=${document.body.scrollWidth} sheet=${cs('#sheet-root')} player=${cs('#player')} step=${step} pageW=${$('.page:not([hidden])').getBoundingClientRect().width}`; }, 1500);
// ---------- 대결 탭: 지도 대결 (account.js + server/). 밝힌 지역 코드·나라·여행 수만 서버에 올리고 친구와 항목별로 비교한다 ----------
const ACC = window.Account || null;
const BATTLE_CATS = [['homeRegions', '국내 지역'], ['abroadRegions', '해외 지역'], ['countries', '나라'], ['zones', '밝힌 곳|cat'], ['trips', '여행']];
const battleScore = (p) => (p.homeRegions || 0) + (p.abroadRegions || 0) * 2 + (p.countries || 0) * 3;
function statsPayload() {   // 서버에 올리는 내 통계(사진 없음): 지역 코드·나라·여행·밝힌 곳 수
  const r = DATA.meta.range || ['', '']; const kr = [], adm = []; const ccs = new Set();
  for (const x of REG.byCode.values()) { (x.cc === 'KR' ? kr : adm).push(x.code); if (x.cc) ccs.add(x.cc); }
  for (const z of Z.zones) if (z.cc) ccs.add(z.cc); if (Z.homeCC) ccs.add(Z.homeCC);
  return { v: 1, homeCC: Z.homeCC || '', since: r[0] ? r[0].slice(0, 4) : '', zones: Z.zones.length, trips: DATA.trips.length, days: Z.zones.reduce((a, z) => a + (z.days || 0), 0), countries: Z.countries || 0, homeRegions: REG.count, homeTotal: REG.total, abroadRegions: REG.abroad, ccs: [...ccs].sort(), codes: { kr: kr.sort(), adm: adm.sort() } };
}
const BS = { rank: null, board: null, boardScope: 'all', battles: null, busy: false, tried: false, pendingCode: null };
try { BS.pendingCode = localStorage.getItem('photo-map-battle-pending') || null; } catch (e) { /* ignore */ }
const setPendingCode = (c) => { BS.pendingCode = c; try { if (c) localStorage.setItem('photo-map-battle-pending', c); else localStorage.removeItem('photo-map-battle-pending'); } catch (e) { /* ignore */ } };
const battleMsg = (t) => { const el = $('#battle-msg'); if (el) el.textContent = t || ''; };
const errText = (e) => { const c = e && e.code; if (c === 'network') return tr('서버에 연결할 수 없어요. 인터넷 연결을 확인해 주세요.'); if (c === 'no_server') return tr('대결 서버 주소가 설정되지 않았어요.'); if (c === 'unauthorized') return tr('로그인이 풀렸어요. 다시 로그인해 주세요.'); if (c === 'not_found') return tr('그 코드의 대결을 찾을 수 없어요.'); if (c === 'self_battle') return tr('내가 만든 대결은 내가 수락할 수 없어요.'); if (c === 'already_accepted') return tr('이미 다른 사람이 수락한 대결이에요.'); if (c === 'no_stats') return tr('지도 통계가 아직 없어요. 사진을 먼저 읽어 주세요.'); return (e && e.message) || tr('문제가 생겼어요.'); };
// 확인 시트(WebView 는 confirm() 창을 못 띄움)
function askConfirm(title, desc, ok, danger) {
  return new Promise((resolve) => {
    const root = $('#confirm-root'); $('#confirm-title').textContent = title; $('#confirm-desc').textContent = desc || ''; const b = $('#confirm-ok'); b.textContent = ok || tr('확인'); b.classList.toggle('danger', !!danger); b.classList.toggle('primary', !danger);
    root.hidden = false; document.body.style.overflow = 'hidden';
    const done = (v) => { root.hidden = true; document.body.style.overflow = ''; b.onclick = null; $('#confirm-cancel').onclick = null; $('#confirm-dim').onclick = null; resolve(v); };
    b.onclick = () => done(true); $('#confirm-cancel').onclick = () => done(false); $('#confirm-dim').onclick = () => done(false);
  });
}
function shareText(text, url, title) {
  if (NATIVE) { try { window.webkit.messageHandlers.share.postMessage({ text, url, title }); return; } catch (e) { /* fall through */ } }
  if (navigator.share) { navigator.share({ text, url, title }).catch(() => {}); return; }
  try { navigator.clipboard.writeText(text); battleMsg(tr('링크를 복사했어요.')); } catch (e) { /* ignore */ }
}
function renderBattle() {
  const ready = !!(ACC && ACC.base); $('#battle-noserver').hidden = ready;
  const inn = $('#battle-in'), out = $('#battle-out');
  if (!ACC || !ACC.loggedIn) { out.hidden = !ready; inn.hidden = true; $('#battle-login-msg').textContent = BS.pendingCode ? tr('로그인하면 받은 대결({code})을 바로 수락해요.', { code: BS.pendingCode }) : ''; return; }
  out.hidden = true; inn.hidden = false;
  const p = statsPayload();
  $('#battle-name').textContent = ACC.session.name || tr('이름 없음');
  $('#battle-score').textContent = fmtN(battleScore(p));
  $('#battle-cats').innerHTML = BATTLE_CATS.map(([k, l]) => `<div class="bc"><b>${fmtN(p[k] || 0)}</b><span>${escH(tr(l))}</span></div>`).join('');
  $('#battle-rank').textContent = BS.rank && BS.rank.rank ? tr('전체 {r}위 · {n}명 중', { r: fmtN(BS.rank.rank), n: fmtN(BS.rank.total) }) : (BS.rank ? tr('아직 순위가 없어요') : '');
  const list = $('#battle-list'); list.innerHTML = '';
  const bs = BS.battles || []; $('#battle-list-empty').hidden = bs.length > 0;
  for (const b of bs) {
    const mine = battleSide(b); const li = document.createElement('li'); li.className = 'row tap'; li.dataset.code = b.code;
    const other = mine.other; const oname = (other ? (other.deleted ? tr('탈퇴한 사용자') : other.name) : tr('아직 수락 전')) + (b.kind === 'random' ? ' · ' + tr('무작위 상대') : '');
    let res = tr('대기 중'), cls = 'wait';
    if (b.result) { const w = b.result.winner; const meWin = w === mine.side; const tie = w === 'tie'; res = tie ? tr('무승부') : (meWin ? tr('승리') : tr('패배')); cls = tie ? 'tie' : (meWin ? 'win' : 'lose'); }
    const sc = b.result ? `${fmtN(mine.side === 'a' ? b.result.winsA : b.result.winsB)} : ${fmtN(mine.side === 'a' ? b.result.winsB : b.result.winsA)}` : b.code;
    li.innerHTML = `<div class="row-body"><div class="row-title">${escH(oname)}</div><div class="row-desc">${escH(b.result ? tr('항목 {s}', { s: sc }) : tr('코드 {code} · 링크를 친구에게 보내 주세요', { code: b.code }))}</div></div><span class="battle-res ${cls}">${escH(res)}</span><button type="button" class="row-x" aria-label="${escH(tr('삭제'))}"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M6 6l12 12M18 6L6 18"/></svg></button>`;
    li.addEventListener('click', () => { if (b.result) openBattleResult(b); else showCodeSheet(b); });
    li.querySelector('.row-x').addEventListener('click', (e) => { e.stopPropagation(); battleDelete(b); });
    list.appendChild(li);
  }
  $$('#board-scope .chip').forEach(c => c.classList.toggle('active', c.dataset.v === BS.boardScope));
  const bl = $('#board-list'); bl.innerHTML = '';
  const entries = (BS.board && BS.board.entries) || [];
  $('#board-empty').hidden = entries.length > 0;
  for (const e of entries) { const li = document.createElement('li'); li.className = 'row compact' + (ACC.session && e.uid === ACC.session.uid ? ' me' : ''); li.innerHTML = `<span class="board-rank">${fmtN(e.rank)}</span><div class="row-body"><div class="row-title">${escH(e.name)}</div><div class="row-desc">${escH(tr('지역 {a} · 해외 {b} · {c}개국', { a: fmtN(e.homeRegions), b: fmtN(e.abroadRegions), c: fmtN(e.countries) }))}</div></div><span class="row-value"><b>${fmtN(e.score)}</b>${escH(tr('점'))}</span>`; bl.appendChild(li); }
  if (!BS.tried) loadBattle();
}
// 대결 기록 삭제: 서버 DELETE /battles/{code} — 수락 전 초대는 코드까지 무효, 수락된 대결은 내 목록에서만 사라진다
async function battleDelete(b) {
  if (BS.busy) return;
  const ok = await askConfirm(tr('이 대결 기록을 지울까요?'), b.result ? tr('내 목록에서만 사라지고, 상대의 기록은 남아요.') : tr('아직 수락 전인 대결이에요. 지우면 보낸 링크도 더 이상 쓸 수 없어요.'), tr('삭제'), true);
  if (!ok) return;
  BS.busy = true;
  try { await ACC.deleteBattle(b.code); BS.afterMsg = tr('대결 기록을 지웠어요.'); battleMsg(BS.afterMsg); }   // 목록을 다시 불러오더라도 안내는 남긴다
  catch (e) { if (e.code !== 'not_found') { BS.busy = false; battleMsg(errText(e)); return; } }
  BS.busy = false;
  BS.battles = (BS.battles || []).filter(x => x.code !== b.code);
  if (curBattle && curBattle.code === b.code && !$('#battle-result').hidden) closeBattleResult();
  renderBattle();
}
const battleSide = (b) => { const uid = ACC.session ? ACC.session.uid : null; const meA = b.from && b.from.uid != null && b.from.uid === uid; return { side: meA ? 'a' : 'b', me: meA ? b.from : b.to, other: meA ? b.to : b.from }; };
async function loadBattle() {
  if (!ACC || !ACC.loggedIn || BS.busy) return; BS.busy = true; BS.tried = true; battleMsg(tr('불러오는 중…'));
  try {
    await ACC.syncStats(statsPayload());
    const me = await ACC.me(); BS.rank = me.rank; if (me.user && me.user.name && me.user.name !== ACC.session.name) ACC.setLocalName(me.user.name);
    const [b, lb] = await Promise.all([ACC.myBattles(), ACC.leaderboard(BS.boardScope)]); BS.battles = b.battles || []; BS.board = lb; battleMsg(BS.afterMsg || ''); BS.afterMsg = null;
  } catch (e) { battleMsg(errText(e)); }
  BS.busy = false; renderBattle();
  if (BS.pendingCode && ACC.loggedIn) { const c = BS.pendingCode; setPendingCode(null); battleAcceptFlow(c, true); }
}
async function battleLogin(provider) {
  const msg = $('#battle-login-msg'); msg.textContent = tr('로그인 창을 여는 중…');
  const r = await ACC.login(provider);
  if (!r.ok) { msg.textContent = r.error || tr('로그인에 실패했어요.'); return; }
  msg.textContent = ''; BS.tried = false; BS.battles = null; BS.board = null; renderBattle(); renderSettings();
  if (r.isNew) askNickname();   // 방금 가입: 닉네임 정하기(비우면 기본 닉네임)
}
// 가입 직후 닉네임 시트: 저장하면 서버 이름 변경, 비우거나 건너뛰면 기본 닉네임(제공자 이름)
function askNickname() {
  const root = $('#nick-root'), inp = $('#nick-input'), msg = $('#nick-msg'); const def = (ACC.session && ACC.session.name) || tr('사용자');
  inp.value = ''; inp.placeholder = def; msg.textContent = ''; $('#nick-skip').textContent = tr("기본 닉네임 '{name}'(으)로", { name: def });
  root.hidden = false; document.body.style.overflow = 'hidden'; setTimeout(() => { try { inp.focus(); } catch (e) { /* ignore */ } }, 50);
  const close = () => { root.hidden = true; document.body.style.overflow = ''; $('#nick-save').onclick = null; $('#nick-skip').onclick = null; $('#nick-dim').onclick = null; inp.onkeydown = null; };
  const save = async () => { const v = inp.value.trim(); if (!v) { close(); return; } msg.textContent = tr('저장하는 중…'); try { await ACC.setName(v); close(); BS.tried = false; renderBattle(); renderSettings(); } catch (e) { msg.textContent = errText(e); } };
  $('#nick-save').onclick = save; inp.onkeydown = (e) => { if (e.key === 'Enter') save(); };
  $('#nick-skip').onclick = close; $('#nick-dim').onclick = close;
}
async function battleChallenge() {
  if (BS.busy) return; BS.busy = true; battleMsg(tr('대결 링크를 만드는 중…'));
  try { await ACC.syncStats(statsPayload()); const b = await ACC.createBattle(); battleMsg(''); BS.tried = false; showCodeSheet(b); }
  catch (e) { battleMsg(errText(e)); }
  BS.busy = false;
}
async function battleRandom() {   // 모르는 사람과 대결: 서버가 점수 비슷한 상대를 골라 바로 결과까지
  if (BS.busy) return; BS.busy = true; battleMsg(tr('상대를 찾는 중…'));
  try { await ACC.syncStats(statsPayload()); const b = await ACC.api('POST', '/battles/random'); battleMsg(''); BS.tried = false; openBattleResult(b); }
  catch (e) { battleMsg(e && e.code === 'no_opponent' ? tr('아직 대결할 상대가 없어요. 친구에게 링크를 보내 보세요.') : errText(e)); }
  BS.busy = false;
}
function showCodeSheet(b) {
  $('#bcode-code').textContent = b.code; $('#bcode-url').textContent = b.url || ''; $('#bcode-root').hidden = false; document.body.style.overflow = 'hidden';
  const p = statsPayload(); const url = b.url ? b.url + (b.url.includes('?') ? '&' : '?') + 'lang=' + (I18N ? I18N.lang : 'ko') : '';   // 링크 미리보기(OG)도 내 언어로
  const text = tr('🗺️ {name}님의 지도 대결 도전장!\n국내 {a}곳 · 해외 {b}곳 · {c}개국 · {s}점\n누가 더 많은 곳을 다녔을까? 지금 비교해 봐 👇', { name: ACC.session.name || tr('친구'), a: fmtN(p.homeRegions || 0), b: fmtN(p.abroadRegions || 0), c: fmtN(p.countries || 0), s: fmtN(battleScore(p)) }) + (url ? '\n' + url : '') + '\n' + tr('코드 {code}', { code: b.code });
  $('#bcode-url').textContent = url;
  $('#bcode-share').onclick = () => shareText(text, url, tr('지도 대결'));
  $('#bcode-copy').onclick = () => { try { navigator.clipboard.writeText(text); $('#bcode-msg').textContent = tr('복사했어요.'); } catch (e) { $('#bcode-msg').textContent = tr('복사할 수 없어요.'); } };
}
const closeCodeSheet = () => { $('#bcode-root').hidden = true; document.body.style.overflow = ''; $('#bcode-msg').textContent = ''; };
async function battleAcceptFlow(code, confirmFirst) {
  code = String(code || '').trim().toUpperCase(); if (!code) return;
  if (!ACC.loggedIn) { setPendingCode(code); showTab('battle'); return; }
  try {
    battleMsg(tr('대결 확인 중…'));
    if (confirmFirst) {
      const info = await ACC.getBattle(code); const from = info.from || {};
      if (info.accepted && !(info.to && info.to.uid === ACC.session.uid)) { battleMsg(tr('이미 다른 사람이 수락한 대결이에요.')); return; }
      const ok = await askConfirm(tr('{name}님의 대결 신청', { name: from.deleted ? tr('탈퇴한 사용자') : (from.name || '') }), tr('지역 {a}곳 · 해외 {b}곳 · {c}개국 · {s}점. 지금 내 지도와 비교할까요?', { a: fmtN((from.stats || {}).homeRegions || 0), b: fmtN((from.stats || {}).abroadRegions || 0), c: fmtN((from.stats || {}).countries || 0), s: fmtN(battleScore(from.stats || {})) }), tr('대결 수락'));
      if (!ok) { battleMsg(''); return; }
    }
    await ACC.syncStats(statsPayload());
    const b = await ACC.acceptBattle(code); battleMsg(''); BS.tried = false; $('#battle-code').value = ''; openBattleResult(b);
  } catch (e) { battleMsg(errText(e)); }
}
// 결과 화면: 항목별 비교 + 두 사람의 구역을 겹친 지도(파랑 나 · 주황 상대 · 보라 둘 다)
let BE = null, beTimer = null, curBattle = null;
const admCC = (() => { let m = null; return (code) => { if (!m) { m = new Map(); try { for (const g of window.WORLD_ADMIN1.objects.admin1.geometries) m.set(g.properties.code, g.properties.cc); } catch (e) { /* ignore */ } } return m.get(code); }; })();
const sigByCode = (() => { let m = null; return (code) => { if (!m) { m = new Map(); for (const f of SIG) m.set(f.properties.code, f); } return m.get(code); }; })();
function featByCode(code) { const f = sigByCode(code); if (f) return f; const cc = admCC(code); if (!cc) return null; return ADM.byCC(cc).find(x => x.properties.code === code) || null; }
function openBattleResult(b) {
  curBattle = b; const mine = battleSide(b); const me = mine.me || {}, other = mine.other || {}; const r = b.result;
  const oname = other.deleted ? tr('탈퇴한 사용자') : (other.name || '');
  const myWins = mine.side === 'a' ? r.winsA : r.winsB, theirWins = mine.side === 'a' ? r.winsB : r.winsA;
  const tie = r.winner === 'tie', meWin = r.winner === mine.side;
  $('#br-banner').innerHTML = tie ? escH(tr('무승부예요')) : (meWin ? icon('trophy') + ' ' + escH(tr('내가 이겼어요!')) : escH(tr('{name}님이 이겼어요', { name: oname })));
  $('#br-banner').className = 'br-banner ' + (tie ? 'tie' : (meWin ? 'win' : 'lose'));
  $('#br-score').textContent = `${fmtN(myWins)} : ${fmtN(theirWins)}`;
  $('#br-me').textContent = tr('나'); $('#br-other').textContent = oname;
  const ms = me.stats || {}, os = other.stats || {};
  $('#br-cats').innerHTML = r.cats.map(c => { const a = mine.side === 'a' ? c.a : c.b, bb = mine.side === 'a' ? c.b : c.a; const w = c.win === 'tie' ? 'tie' : (c.win === mine.side ? 'me' : 'other'); const mx = Math.max(a, bb, 1); const label = (BATTLE_CATS.find(x => x[0] === c.key) || [c.key, c.key])[1]; return `<div class="br-cat ${w}"><div class="br-cat-label">${escH(tr(label))}</div><div class="br-bars"><span class="br-num me">${fmtN(a)}</span><i class="me" style="width:${(a / mx * 100).toFixed(0)}%"></i><i class="other" style="width:${(bb / mx * 100).toFixed(0)}%"></i><span class="br-num other">${fmtN(bb)}</span></div></div>`; }).join('');
  $('#br-total').textContent = tr('점수 {a} : {b}', { a: fmtN(mine.side === 'a' ? r.scoreA : r.scoreB), b: fmtN(mine.side === 'a' ? r.scoreB : r.scoreA) });
  $('#br-delete').onclick = () => battleDelete(b);
  $('#br-share').onclick = () => shareText(tr('지도 대결 결과: 나 {a} : {b} {name} — {res}', { a: fmtN(myWins), b: fmtN(theirWins), name: oname, res: tie ? tr('무승부') : (meWin ? tr('승리!') : tr('패배…')) }) + ' ' + tr('우리 가족 여행'), null, tr('지도 대결'));
  $('#battle-result').hidden = false; document.body.style.overflow = 'hidden';
  requestAnimationFrame(() => drawBattleMap(ms, os));
}
function closeBattleResult() { $('#battle-result').hidden = true; document.body.style.overflow = ''; }
function drawBattleMap(ms, os) {
  const codesOf = (s) => ((s && s.codes) ? [].concat(s.codes.kr || [], s.codes.adm || []) : []);
  const A = new Set(codesOf(ms)), B = new Set(codesOf(os));
  const feats = (codes) => codes.map(featByCode).filter(Boolean);
  const mineOnly = feats([...A].filter(c => !B.has(c))), theirsOnly = feats([...B].filter(c => !A.has(c))), both = feats([...A].filter(c => B.has(c)));
  const all = mineOnly.concat(theirsOnly, both); const canvas = $('#battle-canvas');
  const ccs = [...new Set([].concat((ms && ms.ccs) || [], (os && os.ccs) || []))];
  if (!BE) {
    const cw = canvas.getBoundingClientRect().width || 350;
    const hs = Object.assign({}, S, { selection: 'all', preset: 'all', from: '', to: '', includeShort: true, mapMode: 'flat', aspect: '1:1', shortEdge: 900, watermark: false, photoDots: false, camera: 'fixed', tiles: S.tiles === 'none' ? 'none' : S.tiles, pxRatio: 900 / cw * 0.85, ownLabels: OWN_LABELS });
    BE = PhotoMapEngine.create({ canvas, S: hs, DATA, platform: PLATFORM, onTileLoaded: () => { clearTimeout(beTimer); beTimer = setTimeout(() => BE.draw(0, { territory: BE.__terr }), 120); } }); BE.rebuild();   // rebuild: 캔버스 크기·투영 준비
    attachMapGestures(canvas, BE, () => { if (BE.__terr) BE.draw(0, { territory: BE.__terr }); }, () => {});   // 손가락 확대·이동·두 번 탭 (전체화면 지도와 같은 제스처)
  }
  const center = (f) => [(f.bb[0][0] + f.bb[1][0]) / 2, (f.bb[0][1] + f.bb[1][1]) / 2];
  const homeCodes = new Set([...A, ...B].filter(cd => /^\d+$/.test(String(cd))));   // 시·군·구 코드(숫자) = 내 나라
  const homePts = all.filter(f => homeCodes.has(f.properties && f.properties.code)).map(center), allPts = all.map(center);
  BE.__fit = { home: homePts, world: allPts };   // 전 세계에 흩어진 지역을 다 맞추면 내 나라가 점처럼 작아져 안 보임 → 기본은 내 나라, 칩으로 전체
  const rg = $('#br-region'); rg.innerHTML = '';
  const fitTo = (which) => { const pts = BE.__fit[which]; $$('#br-region .chip').forEach(b => b.classList.toggle('active', b.dataset.v === which)); if (pts && pts.length) { const c = BE.fitPoints(pts, which === 'home' ? 0.14 : 0.22); c.z = Math.min(c.z, 7.2); BE.cam.lon = c.lon; BE.cam.lat = c.lat; BE.cam.z = c.z; } else { BE.cam.lon = 127.5; BE.cam.lat = 36.5; BE.cam.z = 5.2; } if (BE.__terr) BE.draw(0, { territory: BE.__terr }); };
  if (homePts.length && allPts.length > homePts.length) { for (const [v, l] of [['home', (Z.home && Z.home.country) || tr('국내')], ['world', tr('전체|world')]]) { const b = document.createElement('button'); b.type = 'button'; b.className = 'chip'; b.dataset.v = v; b.textContent = l; b.addEventListener('click', () => fitTo(v)); rg.appendChild(b); } }
  fitTo(homePts.length ? 'home' : 'world');
  const mk = (fs, a) => fs.map(f => ({ f, a })); BE.__terr = { zones: [], home: null, homeCC: Z.homeCC, pts: [], fill: mk(mineOnly, 0.6), fill2: mk(theirsOnly, 0.6), fillBoth: mk(both, 0.62), outline: SIG, fog: false, countries: ccs, noLabels: false, labels: 0, baseLabels: OWN_LABELS ? getBaseLabels() : null };
  BE.draw(0, { territory: BE.__terr });
}
window.__photoMapBattle = { statsPayload, renderBattle, loadBattle, battleAcceptFlow, openBattleResult, askNickname, get state() { return BS; } };
if (ACC) {
  $$('#battle-out .login').forEach(b => b.addEventListener('click', () => battleLogin(b.dataset.provider)));
  $('#battle-challenge').addEventListener('click', battleChallenge);
  $('#battle-random').addEventListener('click', battleRandom);
  $('#battle-accept').addEventListener('click', () => battleAcceptFlow($('#battle-code').value, false));
  $('#battle-code').addEventListener('keydown', (e) => { if (e.key === 'Enter') battleAcceptFlow($('#battle-code').value, false); });
  $('#battle-retry').addEventListener('click', () => { BS.tried = false; renderBattle(); });
  $$('#board-scope .chip').forEach(c => c.addEventListener('click', async () => { BS.boardScope = c.dataset.v; $$('#board-scope .chip').forEach(x => x.classList.toggle('active', x === c)); try { BS.board = await ACC.leaderboard(BS.boardScope); } catch (e) { battleMsg(errText(e)); } renderBattle(); }));
  $('#bcode-close').addEventListener('click', closeCodeSheet); $('#bcode-dim').addEventListener('click', closeCodeSheet);
  $('#br-back').addEventListener('click', closeBattleResult);
  $('#battle-name-edit').addEventListener('click', () => { const w = $('#battle-name-wrap'); w.hidden = false; $('#battle-name-input').value = ACC.session.name || ''; $('#battle-name-input').focus(); });
  $('#battle-name-save').addEventListener('click', async () => { const v = $('#battle-name-input').value.trim(); if (!v) return; try { await ACC.setName(v); $('#battle-name-wrap').hidden = true; BS.tried = false; renderBattle(); renderSettings(); } catch (e) { battleMsg(errText(e)); } });
  // 딥링크: phototravelmap://battle/<code> (앱 밖 링크 → 네이티브 → __openUrl). 부팅 전에 온 것은 큐에서 꺼낸다
  const handleOpenUrl = (u) => {
    const str = String(u || '');
    const pf = str.match(/^phototravelmap:\/\/fest\/(\d{1,12})/i);   // 공유 링크: 축제 상세
    if (pf) { showTab('reco'); const id = pf[1]; const f = (festivals || []).find(x => x.id === id) || { id, title: '', addr: '', start: '', end: '', image: '', lat: 0, lon: 0, url: '' }; openFestDetail(f); return; }
    const pp = str.match(/^phototravelmap:\/\/place\/([A-Za-z0-9_\-]{1,40})/i);   // 공유 링크: 여행지 상세
    if (pp) { const d = DEST.find(x => x.id === pp[1]); showTab('reco'); if (d) openDestDetail(d); return; }
    const m = str.match(/^phototravelmap:\/\/battle\/([A-Za-z0-9]{4,10})/i); if (!m) return; const code = m[1].toUpperCase(); showTab('battle'); if (ACC.loggedIn) battleAcceptFlow(code, true); else { setPendingCode(code); renderBattle(); } };
  window.__openUrl = handleOpenUrl; (window.__openUrlQueue || []).splice(0).forEach(handleOpenUrl);
  ACC.onChange(() => { if (tab === 'battle') renderBattle(); });
}

// 튜토리얼(첫 실행 안내): 소개 화면 대신 탭 홈 위에 스포트라이트 + 카드로 단계별 안내. 한 번 보면 localStorage 에 기록, 설정 '사용법 다시 보기'로 재실행. ?notut=1 은 자동 표시만 막는다(테스트)
const TUT_KEY = 'photo-map-tutorial.v1';
const TUT_STEPS = [
  { title: '우리 가족 여행에 오신 걸 환영해요', desc: '사진 속 위치 정보만 읽어서 다녀온 곳을 지도에 칠하고, 여권 도장과 영상으로 남겨요. 사진은 기기 밖으로 나가지 않아요.' },
  { sel: '.home-map', title: '나의 지도', desc: '색이 칠해진 곳이 다녀온 시·군이에요. 지도를 누르면 확대하고, 장소를 누르면 그곳 사진이 나와요.' },
  { sel: '#tabbar [data-tab="reco"]', title: '추천', desc: '이달의 축제·행사와 아직 안 가본 여행지를 골라 보여줘요.' },
  { sel: '#tabbar [data-tab="battle"]', title: '지도 대결', desc: '친구와 지도를 비교하고 랭킹을 확인해요. 로그인은 대결할 때만 필요해요.' },
  { sel: '#tabbar [data-tab="record"]', title: '기록', desc: '여권 도장을 모으고, 여행 지도 영상을 만들어 공유해요.' },
  { sel: '#tabbar [data-tab="settings"]', title: '설정', desc: "새 사진을 찍었다면 '사진 다시 읽기', 클라우드 사진 출처 연결, 프리미엄은 여기서요. 이 안내는 설정에서 다시 볼 수 있어요." },
];
let tutIdx = -1;
const tutOpen = () => tutIdx >= 0;
function tutLayout() {
  if (!tutOpen()) return;
  const st = TUT_STEPS[tutIdx]; const root = $('#tut-root'), spot = $('#tut-spot'), card = $('#tut-card');
  const el = st.sel ? document.querySelector(st.sel) : null;
  const r = el && !el.hidden ? el.getBoundingClientRect() : null;
  if (r && r.width > 0 && r.height > 0) {
    const pad = st.sel.startsWith('#tabbar') ? 2 : 8;
    spot.hidden = false; spot.style.left = (r.left - pad) + 'px'; spot.style.top = (r.top - pad) + 'px'; spot.style.width = (r.width + pad * 2) + 'px'; spot.style.height = (r.height + pad * 2) + 'px';
    root.classList.remove('center');
    const below = r.bottom + pad + 12, ch = card.offsetHeight, vh = window.innerHeight, tb = $('#tabbar');
    const tbH = tb && !tb.hidden ? tb.getBoundingClientRect().height : 0;
    if (below + ch + 16 <= vh - tbH) { card.style.top = below + 'px'; card.style.bottom = 'auto'; }   // 대상 아래
    else if (r.top - pad - 12 - ch >= 16) { card.style.top = 'auto'; card.style.bottom = (vh - (r.top - pad) + 12) + 'px'; }   // 대상 위
    else { card.style.top = 'auto'; card.style.bottom = (tbH + 12) + 'px'; }   // 대상이 화면을 거의 다 차지(지도): 탭바 위에 겹쳐 놓기
  } else { spot.hidden = true; card.style.top = ''; card.style.bottom = ''; root.classList.add('center'); }
}
function tutShow(i) {
  tutIdx = i; const st = TUT_STEPS[i]; const last = i === TUT_STEPS.length - 1;
  $('#tut-step').textContent = tr('{a} / {b}', { a: fmtN(i + 1), b: fmtN(TUT_STEPS.length) });
  $('#tut-title').textContent = tr(st.title); $('#tut-desc').textContent = tr(st.desc);
  $('#tut-dots').innerHTML = TUT_STEPS.map((_, k) => `<i class="${k === i ? 'on' : ''}"></i>`).join('');
  $('#tut-skip').textContent = tr('건너뛰기'); $('#tut-skip').hidden = last;
  $('#tut-next').textContent = last ? tr('시작하기') : tr('다음');
  if (st.sel && !st.sel.startsWith('#tabbar')) { const el = document.querySelector(st.sel); if (el) { try { el.scrollIntoView({ block: 'start' }); } catch (e) { /* ignore */ } } }
  else if (!st.sel) window.scrollTo(0, 0);
  $('#tut-root').hidden = false; document.body.style.overflow = 'hidden';
  tutLayout(); requestAnimationFrame(tutLayout);
}
function startTutorial(i) { if (recording) return; if (step !== 0 || tab !== 'home') showTab('home'); tutShow(i || 0); }
function endTutorial() { if (!tutOpen()) return; tutIdx = -1; $('#tut-root').hidden = true; document.body.style.overflow = ''; try { localStorage.setItem(TUT_KEY, '1'); } catch (e) { /* ignore */ } }
$('#tut-next').addEventListener('click', () => { if (tutIdx + 1 >= TUT_STEPS.length) endTutorial(); else tutShow(tutIdx + 1); });
$('#tut-skip').addEventListener('click', endTutorial);
window.addEventListener('resize', tutLayout);
window.__photoMap = { openFestList, tutorial: startTutorial, endTutorial, get tutorialStep() { return tutIdx; }, E, get HE() { return HE; }, get ME() { return ME; }, Z, openMap, openPlace, closePlace, closeMap, showTab, regionAt, openRegion, mapRedraw, get tab() { return tab; }, get state() { return { S, T, cam: E.cam, step, seq: E.SEQ.length, total: E.TL.total, demo: DEMO, trips: DATA.trips.length, platform: PLATFORM, wm: E.watermarkText, returning: RETURNING, zones: Z.zones.length, newZones: recentNew.length, hometowns: Z.hometowns.map(z => z.name) }; }, seek: (t) => seekTo(t, true), goStep, play: () => setPlaying(true), pause: () => setPlaying(false) };
window.__photoMapBack = () => {   // Android 시스템 뒤로가기(MainActivity): 열린 화면(상세·목록·지도·시트) 먼저 닫고, 그다음 단계 이동. 처리했으면 true
  if (tutOpen()) { endTutorial(); return true; }
  if (!$('#place-detail').hidden) { pdBack(); return true; }
  if (!$('#fest-list').hidden) { closeFestList(); return true; }
  if (!$('#viewer-root').hidden) { try { $('#viewer-close').click(); } catch (e) { /* ignore */ } return true; }
  if (!$('#sheet-root').hidden) { try { $('#sheet-close').click(); } catch (e) { /* ignore */ } return true; }
  if (!$('#nick-root').hidden) { $('#nick-skip').click(); return true; }
  if (!$('#source-detail').hidden) { closeSourceDetail(true); return true; }
  if (mapOpen) { closeMap(); return true; }
  if (step > homeStep()) { goStep(prevStep(step)); return true; }
  return false;
};
requestAnimationFrame(loop);
} // boot

window.__bootPhotoMap = boot;
if (window.TRIP_DATA) boot(window.TRIP_DATA);
else if (!NATIVE) document.body.innerHTML = '<p style="padding:2rem;font-family:sans-serif">데이터 파일이 없습니다. 먼저 <code>./run.sh</code> 를 실행하세요.</p>';
})();
