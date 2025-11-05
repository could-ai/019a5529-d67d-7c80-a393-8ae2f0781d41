package com.example.couldai_user_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent

class MainActivity: FlutterActivity() {
    private val CHANNEL = "device_control"
    private lateinit var devicePolicyManager: DevicePolicyManager
    private lateinit var compName: ComponentName

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        compName = ComponentName(this, DeviceAdminReceiver::class.java)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "lockPhone" -> {
                    if (devicePolicyManager.isAdminActive(compName)) {
                        devicePolicyManager.lockNow()
                        result.success("Phone locked")
                    } else {
                        // Request device admin permission
                        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN)
                        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, compName)
                        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, 
                            "Enable device admin to lock your phone via voice command")
                        startActivityForResult(intent, 1)
                        result.success("Requesting device admin permission")
                    }
                }
                "isDeviceAdminActive" -> {
                    result.success(devicePolicyManager.isAdminActive(compName))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}