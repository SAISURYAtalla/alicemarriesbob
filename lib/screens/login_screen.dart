import 'package:flutter/material.dart';
import '../utils/native.dart';

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
    var k2 = await usbManager.detectSmartCard();
    bool detected = true?k2!=null:false;
    setState(() {
      isSmartCardDetected = detected;
    });
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
              const Text("No Smart Card detected. Please check your connection."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkSmartCard,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    return const MyHomePage(title: 'Play with TrustToken');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Click to login in the application'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                UsbManager s = new UsbManager();
                var k2 = await s.loginTrustToken(_textcontroller.text);
                print(k2);
                Navigator.pushNamed(
                  context, 
                  '/home'
                );
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}