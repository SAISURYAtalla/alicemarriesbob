import 'package:flutter/material.dart';
import '../utils/native.dart'; // For UsbManager

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  bool? isSmartCardDetected;

  @override
  void initState() {
    super.initState();
    _checkSmartCard();
  }

  Future<void> _checkSmartCard() async {
    UsbManager usbManager = UsbManager();
    var smartCard = await usbManager.detectSmartCard();
    bool detected = smartCard != null;
    setState(() {
      isSmartCardDetected = detected;
    });

    // Show snackbar for the detection status
    if (!detected) {
      _showSnackbar('No TrustToken detected. Please check your connection.');
    } else {
      _showSnackbar('TrustToken detected. You can now log in.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSmartCardDetected == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isSmartCardDetected == false) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No TrustToken detected. Please check your connection."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkSmartCard,
                child: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const LoginPage(title: 'Login');
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _pinController = TextEditingController();

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _attemptLogin() async {
    if (_pinController.text == '123456') {
      UsbManager usbManager = UsbManager();
      var loginResult = await usbManager.loginTrustToken(_pinController.text);
      bool loginResult2 = true; // For testing purposes

      if (loginResult2) {
        _showSnackbar('Login successful!');
        Navigator.pushNamed(context, '/home');
      } else {
        _showSnackbar('Failed to log in. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Enter your PIN to log in:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              controller: _pinController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'PIN',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _attemptLogin,
              child: const Text("Login"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
