/* R28 owner-written diary location addon. Does not contain bundled third-party app code or private GPS/photo data. */
(function (w, d) {
  'use strict';
  if (w.FamilyJourneyDiaryGeo && w.FamilyJourneyDiaryGeo.version >= 28) return;
  var seq = 0;
  var geoPending = new Map(), addressPending = new Map(), geoCache = new Map();
  function native(name, payload) {
    if (!w.NativeHost || typeof w.NativeHost.post !== 'function') return false;
    w.NativeHost.post(name, JSON.stringify(payload)); return true;
  }
  function safeMediaId(value) {
    var id = String(value == null ? '' : value).trim();
    return /^(?:v)?[0-9]{1,18}$/.test(id) ? id : '';
  }
  function safeTitle(value) {
    if (typeof value === 'string') return value.trim() || '가족 사진';
    if (value && typeof value === 'object') {
      var name = value.name || value.title || value.label || value.city || value.region || value.address;
      return (typeof name === 'string' && name.trim()) ? name.trim() : '가족 사진';
    }
    return '가족 사진';
  }
  function coordinates(obj) {
    var a = Number(obj.lat), b = Number(obj.lon);
    if (!Number.isFinite(a) || !Number.isFinite(b) || a < -90 || a > 90 || b < -180 || b > 180) return '';
    return a.toFixed(5) + ', ' + b.toFixed(5);
  }
  function button(text, fn, className) {
    var b = d.createElement('button');
    b.type = 'button';
    b.className = 'fj-r28-action ' + (className || '');
    b.textContent = text;
    b.addEventListener('click', function (event) { event.stopPropagation(); fn(); });
    return b;
  }
  function requestLocation(id, cb) {
    if (geoCache.has(id)) { cb(geoCache.get(id)); return; }
    var req = ++seq;
    geoPending.set(req, function (record) { geoCache.set(id, record); cb(record); });
    if (!native('diaryMediaLocation', { request: req, id: id })) {
      geoPending.delete(req); cb({ id: id, hasGps: false, error: 'bridge_unavailable' });
    }
  }
  w.__fjDiaryMediaLocationResult = function (request, value) {
    var done = geoPending.get(Number(request));
    if (!done) return;
    geoPending.delete(Number(request));
    done(value && typeof value === 'object' ? value : { hasGps: false });
  };
  w.__fjDiaryAddressResult = function (request, value) {
    var done = addressPending.get(Number(request));
    if (!done) return;
    addressPending.delete(Number(request));
    done(value && typeof value === 'object' ? value : { error: 'no_result' });
  };
  function render(slot, info) {
    slot.replaceChildren();
    var coords = coordinates(info);
    if (!info.hasGps || !coords) {
      slot.textContent = '촬영 위치 정보 없음';
      slot.classList.add('fj-r28-muted');
      return;
    }
    slot.classList.remove('fj-r28-muted');
    var label = d.createElement('span');
    label.className = 'fj-r28-coordinates';
    label.textContent = '촬영 좌표 · ' + coords;
    slot.appendChild(label);
    if (info.lat >= 31.43 && info.lat <= 44.35 && info.lon >= 122.37 && info.lon <= 132.00) {
      slot.appendChild(button('네이버지도', function () {
        native('diaryOpenNaverPlace', {lat:info.lat,lon:info.lon,name:'촬영 위치'});
      }));
    }
    var addressButton = button('상세 주소 조회', function () {
      addressButton.disabled = true;
      addressButton.textContent = '조회 중…';
      var req = ++seq;
      addressPending.set(req, function (result) {
        if (result && typeof result.address === 'string' && result.address.trim()) {
          label.textContent = result.address.trim() + ' · ' + coords;
          addressButton.textContent = '주소 확인됨';
        } else {
          addressButton.textContent = '주소 미확인';
        }
        addressButton.disabled = false;
      });
      if (!native('diaryReverseAddress', { request:req,lat:info.lat,lon:info.lon })) {
        addressPending.delete(req);
        addressButton.textContent = '주소 조회 불가'; addressButton.disabled = false;
      }
    });
    slot.appendChild(addressButton);
  }
  function attach(container, mediaId) {
    var id = safeMediaId(mediaId);
    if (!id || !container || !container.appendChild) return null;
    if (container.querySelector('[data-fj-r28-geo="' + id + '"]')) return null;
    var slot = d.createElement('div');
    slot.className = 'fj-r28-location fj-r28-muted';
    slot.dataset.fjR28Geo = id;
    slot.textContent = '촬영 좌표 확인 중…';
    container.appendChild(slot);
    requestLocation(id, function (value) { if (slot.isConnected) render(slot, value); });
    return slot;
  }
  if (d && !d.getElementById('fj-r28-geo-style')) {
    var style = d.createElement('style');
    style.id = 'fj-r28-geo-style';
    style.textContent = '.fj-r28-location{display:flex;align-items:center;flex-wrap:wrap;gap:7px;font:500 12px/1.6 system-ui,Arial,sans-serif;color:#43546b;margin:8px 0 14px}.fj-r28-muted{color:#98a1ae}.fj-r28-action{border:1px solid #dae3ef;border-radius:999px;color:#2669b8;background:#f2f7ff;font:600 12px system-ui,Arial,sans-serif;padding:5px 10px;cursor:pointer}.fj-r28-action:disabled{opacity:.6}';
    (d.head || d.documentElement).appendChild(style);
  }
  w.FamilyJourneyDiaryGeo = Object.freeze({ version:28, attach:attach, safeTitle:safeTitle, safeMediaId:safeMediaId });
})(window, document);
