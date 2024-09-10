package com.deu.hackton.all_life_app.helpers

import android.opengl.GLSurfaceView
import android.view.View
import android.widget.TextView
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.google.ar.core.Earth
import com.google.ar.core.GeospatialPose
import com.deu.hackton.all_life_app.R
import com.deu.hackton.all_life_app.java.samplerender.SnackbarHelper
import com.google.android.gms.maps.MapView

/** Contains UI elements for Hello Geo. */
class HelloGeoView(val activity: FragmentActivity) : DefaultLifecycleObserver {
    val root = View.inflate(activity, R.layout.fragment_ar_gps, null)
    val surfaceView = root.findViewById<GLSurfaceView>(R.id.surfaceview)

    val session
        get() = activity.arCoreSessionHelper.session

    val snackbarHelper = SnackbarHelper()

    var mapView: MapView? = null


    val statusText = root.findViewById<TextView>(R.id.statusText)
    fun updateStatusText(earth: Earth, cameraGeospatialPose: GeospatialPose?) {
        activity.runOnUiThread {
            val poseText = if (cameraGeospatialPose == null) "" else
                activity.getString(R.string.geospatial_pose,
                    cameraGeospatialPose.latitude,
                    cameraGeospatialPose.longitude,
                    cameraGeospatialPose.horizontalAccuracy,
                    cameraGeospatialPose.altitude,
                    cameraGeospatialPose.verticalAccuracy,
                    cameraGeospatialPose.heading,
                    cameraGeospatialPose.headingAccuracy)
            statusText.text = activity.resources.getString(R.string.earth_state,
                earth.earthState.toString(),
                earth.trackingState.toString(),
                poseText)
        }
    }

    override fun onResume(owner: LifecycleOwner) {
        surfaceView.onResume()
    }

    override fun onPause(owner: LifecycleOwner) {
        surfaceView.onPause()
    }
}
