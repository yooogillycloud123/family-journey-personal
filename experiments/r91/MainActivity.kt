package com.headless.example

import android.os.Bundle
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.headless.android.HeadlessAutomation
import com.headless.android.HeadlessRuntime
import com.headless.android.HeadlessSession
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** MOA R91: read-only Samsung hidden-display feasibility probe.
 * Separate test harness ONLY; the signed R89 Golden app is not modified.
 * No taps, text entry, bookmarks, screenshots, photos or user login access.
 * The phone's real display is never an automation target.
 */
class MainActivity : AppCompatActivity() {
    private lateinit var output: TextView
    private lateinit var settingsButton: Button
    private lateinit var naverButton: Button
    private var active = false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val layout = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(30, 60, 30, 30)
        }
        val intro = TextView(this).apply {
            text = "MOA R91 | 숨김 화면 실험 (읽기 전용)\n기존 R89 모아 앱은 변경하지 않습니다.\nShizuku 승인 후 순서대로 시험하세요. 실제 화면에 다른 앱이 열리는지 관찰하세요."
            textSize = 17f
        }
        output = TextView(this).apply {
            text = "대기 중: 가상 화면이 생성되지 않았습니다."
            textSize = 15f
        }
        settingsButton = Button(this).apply {
            text = "1. 설정 앱 숨김 실행 시험"
            setOnClickListener { probe("com.android.settings") }
        }
        naverButton = Button(this).apply {
            text = "2. 네이버지도 숨김 실행 시험 (저장하지 않음)"
            setOnClickListener { probe("com.nhn.android.nmap") }
        }
        layout.addView(intro)
        layout.addView(settingsButton)
        layout.addView(naverButton)
        layout.addView(output)
        setContentView(layout)
        val prefs = getSharedPreferences("r91_probe", MODE_PRIVATE)
        val last = prefs.getString("last", "")
        if (!last.isNullOrBlank()) output.text = "이전 결과: $last"
    }

    private fun log(message: String) {
        getSharedPreferences("r91_probe", MODE_PRIVATE).edit().putString("last", message).apply()
        output.text = message
    }

    private fun probe(target: String) {
        if (active) return
        active = true
        settingsButton.isEnabled = false
        naverButton.isEnabled = false
        log("진행 중: Shizuku 확인 → 가상 디스플레이 → 앱 실행. 원래 화면은 건드리지 않음.")
        lifecycleScope.launch {
            var runtime: HeadlessRuntime? = null
            var session: HeadlessSession? = null
            try {
                runtime = HeadlessAutomation.start(applicationContext)
                if (!runtime.isAuthorized()) {
                    val ok = runtime.requestAuthorization()
                    if (!ok) {
                        log("결과: SHIZUKU_NOT_AUTHORIZED — 권한이 승인되지 않았습니다.")
                        return@launch
                    }
                }
                session = withContext(Dispatchers.IO) { runtime.createSession() }
                val id = session.displayId
                if (id <= 0) {
                    log("결과: DISPLAY_ZERO_REFUSED — 안전 중단")
                    return@launch
                }
                withContext(Dispatchers.IO) { session.launch(target) }
                delay(2200L)
                val placed = withContext(Dispatchers.IO) { session.isAppOnDisplay(target) }
                val zero = withContext(Dispatchers.IO) { session.checkDisplayZero() }
                if (!placed || zero.isContaminated) {
                    log("결과: ISOLATION_FAIL display=$id hidden=$placed zeroSafe=${!zero.isContaminated}; 작업 중단")
                    return@launch
                }
                val treeReadable = withContext(Dispatchers.IO) { session.compactUi() != null }
                log("결과: HIDDEN_DISPLAY_PASS target=$target display=$id zeroSafe=true treeReadable=$treeReadable\n즐겨찾기 저장은 실행하지 않았습니다.")
            } catch (e: Throwable) {
                log("결과: FAIL_${e.javaClass.simpleName}: ${(e.message ?: "").take(220)}")
            } finally {
                withContext(Dispatchers.IO) {
                    try { session?.close() } catch (_: Throwable) {}
                    try { runtime?.close() } catch (_: Throwable) {}
                }
                active = false
                settingsButton.isEnabled = true
                naverButton.isEnabled = true
            }
        }
    }
}
