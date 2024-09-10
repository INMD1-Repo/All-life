// ar_gps.kt
package com.deu.hackton.all_life

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.deu.hackton.all_life_app.HelloGeoRenderer
import com.deu.hackton.all_life_app.R
import com.deu.hackton.all_life_app.helpers.ARCoreSessionLifecycleHelper
import com.deu.hackton.all_life_app.helpers.GeoPermissionsHelper
import com.deu.hackton.all_life_app.helpers.HelloGeoView
import com.google.ar.core.Config
import com.google.ar.core.Session
import com.google.ar.core.exceptions.CameraNotAvailableException
import com.google.ar.core.exceptions.UnavailableApkTooOldException
import com.google.ar.core.exceptions.UnavailableDeviceNotCompatibleException
import com.google.ar.core.exceptions.UnavailableSdkTooOldException
import com.google.ar.core.exceptions.UnavailableUserDeclinedInstallationException
import com.deu.hackton.all_life_app.java.samplerender.SampleRender

class ARGPSFragment : Fragment() {

    companion object {
        private const val TAG = "ar_gps"
    }

    lateinit var arCoreSessionHelper: ARCoreSessionLifecycleHelper
    lateinit var view: HelloGeoView
    lateinit var renderer: HelloGeoRenderer

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Setup the fragment layout
        val rootView = inflater.inflate(R.layout.fragment_ar_gps, container, false)

        // Setup ARCore session lifecycle helper and configuration
        arCoreSessionHelper = ARCoreSessionLifecycleHelper(requireActivity())

        // If Session creation or Session.resume() fails, display a message and log detailed information
        arCoreSessionHelper.exceptionCallback = { exception ->
            val message = when (exception) {
                is UnavailableUserDeclinedInstallationException -> "Please install Google Play Services for AR"
                is UnavailableApkTooOldException -> "Please update ARCore"
                is UnavailableSdkTooOldException -> "Please update this app"
                is UnavailableDeviceNotCompatibleException -> "This device does not support AR"
                is CameraNotAvailableException -> "Camera not available. Try restarting the app."
                else -> "Failed to create AR session: $exception"
            }
            Log.e(TAG, "ARCore threw an exception", exception)
            // Display error message
            view.snackbarHelper.showError(requireActivity(), message)
        }

        // Configure session features
        arCoreSessionHelper.beforeSessionResume = ::configureSession
        lifecycle.addObserver(arCoreSessionHelper)

        // Set up the Hello AR renderer
        renderer = HelloGeoRenderer(requireActivity())
        lifecycle.addObserver(renderer)

        // Set up Hello AR UI
        view = HelloGeoView(requireActivity())
        lifecycle.addObserver(view)

        // Sets up an example renderer using our HelloGeoRenderer
        SampleRender(view.surfaceView, renderer, requireActivity().assets)

        return rootView
    }

    // Configure the session, setting the desired options according to your use case
    fun configureSession(session: Session) {
        session.configure(
            session.config.apply {
                geospatialMode = Config.GeospatialMode.ENABLED
            }
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        results: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, results)
        if (!GeoPermissionsHelper.hasGeoPermissions(requireActivity())) {
            Toast.makeText(requireActivity(), "Camera and location permissions are needed to run this application", Toast.LENGTH_LONG).show()
            if (!GeoPermissionsHelper.shouldShowRequestPermissionRationale(requireActivity())) {
                GeoPermissionsHelper.launchPermissionSettings(requireActivity())
            }
            requireActivity().finish()
        }
    }
}