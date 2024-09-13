// MyFragmentActivity.kt
package com.deu.hackton.all_life

import android.os.Bundle
import androidx.fragment.app.FragmentActivity
import com.deu.hackton.all_life_app.R

class MyFragmentActivity : FragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.fragment_ar_gps)

        showARGPSFragment()
    }

    private fun showARGPSFragment() {
        val fragmentManager = supportFragmentManager
        val fragmentTransaction = fragmentManager.beginTransaction()

        fragmentTransaction.commit()
    }
}
