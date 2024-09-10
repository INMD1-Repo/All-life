package com.deu.hackton.all_life

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentManager
import com.deu.hackton.all_life_app.R

class MyFragmentActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.fragment_ar_gps)  // 방금 수정한 레이아웃 파일을 사용

        if (savedInstanceState == null) {
            // ARGPSFragment를 fragment_container에 삽입
            val fragmentManager: FragmentManager = supportFragmentManager
            val transaction = fragmentManager.beginTransaction()
            transaction.replace(R.id.fragment_container, ARGPSFragment())
            transaction.commit()
        }
    }
}
