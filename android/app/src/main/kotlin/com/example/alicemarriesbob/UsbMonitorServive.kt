package com.example.temp

import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.os.IBinder
import android.util.Log
import kotlinx.coroutines.*
import java.io.ByteArrayInputStream
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate
import kotlin.system.exitProcess


class UsbMonitorService : Service() {
    private val scope = CoroutineScope(Dispatchers.IO + Job())
    private val ACTION_USB_PERMISSION = "com.example.temp.USB_PERMISSION"
    private var isUsbDisconnected = false
    private var cert1: X509Certificate? = null
    private var isCertSame = false

    companion object {
        private var isLogin = false
        init {
            System.loadLibrary("native-lib") // Replace 'native-lib' with your library name
        }
        fun setLoginStatus(status: Boolean) {
            isLogin = status
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        scope.launch {
            while (true) {
                val isConnected = isUsbTokenConnected()
                if (!isConnected && !isUsbDisconnected) {
                    isUsbDisconnected = true
                    val intents = Intent("com.example.temp.USB_DISCONNECTED")
                    sendBroadcast(intents)
                } else if (isConnected && isUsbDisconnected) {
                    val intents = Intent("com.example.temp.USB_CONNECTED")
                    sendBroadcast(intents)
                    isUsbDisconnected = false
                }
//                else if(isConnected && isLogin && cert1 == null){
//                    val res = readCertificate()
//                    cert1 = decodeCertificate(res)
//                }
//                else if(isConnected && isLogin){
//                    val res = readCertificate()
//                    isCertSame = areCertificatesIdentical(res)
//                    if(!isCertSame){
//                        val intents = Intent("com.example.temp.CERTIFICATE_CHANGED")
//                        sendBroadcast(intents)
//                    }
//                }
                delay(500) // Check every second
            }
        }
        return START_STICKY
    }

    private fun isUsbTokenConnected(): Boolean {
        val usbManager = getSystemService(Context.USB_SERVICE) as UsbManager
        usbManager.deviceList.values.forEach { device ->
            if (isSmartCardReader(device)) {
                return true
            }
        }
        return false
    }

    private fun isSmartCardReader(device: UsbDevice): Boolean {
        val vendorId = 10381
        val productId = 64
        requestUsbPermission(device)
//        println("Device Name: ${device.deviceName}")
//        println("Device ID: ${device.deviceId}")
//        println("Device Protocol: ${device.deviceProtocol}")
//        println("Device Subclass: ${device.deviceSubclass}")
//        println("Device Class: ${device.deviceClass}")
//        println("Manufacturer Name: ${device.manufacturerName}")
//        println("Product Name: ${device.productName}")
//        println("Serial Number: ${device.serialNumber}")
//        println("Version: ${device.version}")

        return device.getVendorId() === vendorId && device.getProductId() === productId
    }

    private fun requestUsbPermission(device: UsbDevice) {

        val usbManager = getSystemService(Context.USB_SERVICE) as UsbManager
        val permissionIntent = PendingIntent.getBroadcast(this, 0, Intent(ACTION_USB_PERMISSION), PendingIntent.FLAG_IMMUTABLE)
        usbManager.requestPermission(device, permissionIntent)
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

    fun areCertificatesIdentical(cert2Hex: String): Boolean {
        val cert2 = decodeCertificate(cert2Hex)

        if (cert1 == null || cert2 == null) {
            return false
        }

        return cert1!!.serialNumber == cert2.serialNumber &&
                cert1!!.issuerDN == cert2.issuerDN &&
                cert1!!.subjectDN == cert2.subjectDN &&
                cert1!!.publicKey == cert2.publicKey &&
                cert1!!.notBefore == cert2.notBefore &&
                cert1!!.notAfter == cert2.notAfter &&
                cert1!!.sigAlgName == cert2.sigAlgName &&
                cert1!!.signature.contentEquals(cert2.signature)
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        scope.cancel()
    }
}