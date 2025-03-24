package com.example.temp

import io.flutter.embedding.android.FlutterActivity
import android.annotation.SuppressLint
import android.app.AlertDialog
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlin.coroutines.CoroutineContext
import java.io.ByteArrayInputStream
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate
//import UsbMonitorService

class MainActivity: FlutterActivity(), CoroutineScope {
    private  val job = Job()

    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main + job

    companion object {
        // Load the native library on application startup.
        init {
            System.loadLibrary("native-lib")
        }
    }
    val ACTION_USB_PERMISSION = "com.example.alicemarriesbob.USB_PERMISSION"
    var fileDescriptor: Int = 0
    private val CHANNEL = "com.example.alicemarriesbob/usb"
    private var dialog: AlertDialog? = null
    private var certificate1: X509Certificate? = null


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "login") {

                val pin = call.argument<String>("pin") ?: ""
                if (pin.length ==0)
                    result.error("Invalid PIN", "Please enter a valid PIN", null)
                launch {
                    fileDescriptor = detectSmartCard()
                    if (fileDescriptor == 1) {
                        result.error("Permission Denied", "Give permission to Usb Token", null)
                        return@launch
                    }
                    if (fileDescriptor == -1) {
                        result.error("UNAVAILABLE", "No smart card reader found", null)
                        return@launch
                    }
                    val resp = libint(fileDescriptor)
                    if (resp != 0) {
                        result.error("Connection Error", "Unable to connect to USB", null)
                        return@launch
                    }
                    println("connect usb $resp")
                    val res = login(pin)
                    println("login" + res)
                    if(res =="Login Success") {
//                        UsbMonitorService.setLoginStatus(true)
                        val hexData = readCertificate()
                        if(!Regex("^[0-9A-Fa-f]+\$").matches(hexData)){
                            result.error("Error Occured", "Try again by restarting the app", null)
                            return@launch
                        }
                        val cert = getCertificateDetails(hexData)
//                        val status = logout()
//                        println(status)
                        result.success(res)
//                        val log_out = logout()
//                        println(log_out)
                    }
                    else
                        result.error("Error Occured", res, null)
                }

            }
            else if(call.method == "getFileDescriptor") {
                fileDescriptor = detectSmartCard()
                if (fileDescriptor == 1)
                    result.error("Permission Denied", "Give permission to Usb Token", null)
                result.success(fileDescriptor)
            }
            else if (call.method == "logout") {
                val res = logout()
                result.success(res)
            }
            else {
                result.notImplemented()
            }
        }
    }


    @SuppressLint("WrongConstant")
    fun detectSmartCard(): Int {
        val usbManager = getSystemService(Context.USB_SERVICE) as UsbManager?
        if (usbManager != null) {
            for (device in usbManager.deviceList.values) {
                if (isSmartCardReader(device)) {
                    val permissionIntent: PendingIntent = if (Build.VERSION.SDK_INT >= 33) {
                        PendingIntent.getBroadcast(
                            this,
                            0,
                            Intent(ACTION_USB_PERMISSION),
                            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                        )
                    } else {
                        PendingIntent.getBroadcast(
                            this,
                            0,
                            Intent(ACTION_USB_PERMISSION),
                            PendingIntent.FLAG_UPDATE_CURRENT
                        )
                    }

                    usbManager.requestPermission(device, permissionIntent)
                    if (usbManager.hasPermission(device)) {
                        // Handle the USB device connection
                        return getFileDescriptor(usbManager, device)
                    }
                }
            }
        }
        return 1
    }

    private fun isSmartCardReader(device: UsbDevice): Boolean {
        val vendorId = 10381
        val productId = 64
        return device.vendorId == vendorId && device.productId == productId
    }

    private fun getFileDescriptor(manager: UsbManager, device: UsbDevice): Int {
        val connection = manager.openDevice(device)
        if (connection != null) {
            return connection.fileDescriptor
        }
        return -1
    }

    private fun showDialog() {
        dialog = AlertDialog.Builder(this)
            .setTitle("USB Token Disconnected")
            .setMessage("The USB token is not connected. Restart the app.")
            .setPositiveButton("OK") { _, _ -> finishAffinity() }
            .setCancelable(false)
            .show()
    }
    private fun dismissDialog() {
        dialog?.dismiss()
        dialog = null
    }

    private fun showDialogCertChanged() {
        dialog = AlertDialog.Builder(this)
            .setTitle("Token Changed")
            .setMessage("Token change detected. Restart the app.")
            .setPositiveButton("OK") { _, _ -> finishAffinity() }
            .setCancelable(false)
            .show()
    }

    private fun decodeCertificate(hexString: String): X509Certificate? {
        return try {
            val bytes = hexString.chunked(2).map { it.toInt(16).toByte() }.toByteArray()
            val certificateFactory = CertificateFactory.getInstance("X.509")
            certificateFactory.generateCertificate(ByteArrayInputStream(bytes)) as X509Certificate
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun getCertificateDetails(hexString: String):Map<String, String> {

        try {
            // Convert hex string to byte array
            val bytes = hexString.chunked(2).map { it.toInt(16).toByte() }.toByteArray()
            // Parse the certificate
            val certificateFactory = CertificateFactory.getInstance("X.509")
            val certificate = certificateFactory.generateCertificate(ByteArrayInputStream(bytes)) as X509Certificate

            val details = mutableMapOf<String, String>()

            details["Serial Number"] = certificate.serialNumber.toString()
            details["Issuer"] = certificate.issuerDN.toString()
            details["Subject"] = certificate.subjectDN.toString()

            return details
        } catch (e: Exception) {
            e.printStackTrace()
            return emptyMap()
        }
    }
    private fun areCertificatesIdentical(cert1: X509Certificate?, cert2Hex: String): Boolean {
//        val cert1 = decodeCertificate(cert1Hex)
        val cert2 = decodeCertificate(cert2Hex)

        if (cert1 == null || cert2 == null) {
            return false
        }

        return cert1.serialNumber == cert2.serialNumber &&
                cert1.issuerDN == cert2.issuerDN &&
                cert1.subjectDN == cert2.subjectDN &&
                cert1.publicKey == cert2.publicKey &&
                cert1.notBefore == cert2.notBefore &&
                cert1.notAfter == cert2.notAfter &&
                cert1.sigAlgName == cert2.sigAlgName &&
                cert1.signature.contentEquals(cert2.signature)
    }


    private val usbDisconnectedReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action == "com.example.alicemarriesbob.USB_DISCONNECTED") {
                showDialog()
            }
        }
    }

    private val usbConnectedReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action == "com.example.alicemarriesbob.USB_CONNECTED") {
                dismissDialog()
            }
        }
    }

    private  val certificateChangedReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action == "com.example.alicemarriesbob.CERTIFICATE_CHANGED") {
                showDialogCertChanged()
            }
        }
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val serviceIntent = Intent(this, UsbMonitorService::class.java)
        startService(serviceIntent)
        registerReceiver(usbDisconnectedReceiver, IntentFilter("com.example.alicemarriesbob.USB_DISCONNECTED"), Context.RECEIVER_EXPORTED)
        registerReceiver(usbConnectedReceiver, IntentFilter("com.example.alicemarriesbob.USB_CONNECTED"), Context.RECEIVER_EXPORTED)

    }

    override fun onDestroy() {
        super.onDestroy()
        job.cancel()
        val serviceIntent = Intent(this, UsbMonitorService::class.java)
        stopService(serviceIntent)
        unregisterReceiver(usbDisconnectedReceiver)
        unregisterReceiver(usbConnectedReceiver)
    }


    // Declare the native method
    external fun login(jstr: String): String
    external fun libint(fileDescriptor: Int): Int
    external fun readCertificate(): String
    external fun logout(): String
}