import 'package:flutter/material.dart';
import '../utils/native.dart'; // For UsbManager

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkSmartCard();
  }

  //Trust Token detection
  Future<void> _checkSmartCard() async {
    UsbManager usbManager = UsbManager();
    var k2 = await usbManager.detectSmartCard();
    bool detected = k2 != null;
    setState(() {
      _isConnected = detected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AliceMarriesBob'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _isConnected ? _buildServiceOptions(context) : _buildConnectionPrompt(),
    );
  }

  Widget _buildConnectionPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.usb_off,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            'Connect the TrustToken to have all the functionalities.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkSmartCard,
            child: Text('Retry Connection'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildServiceButton(
            context,
            icon: Icons.payment,
            label: 'Recharge',
            route: '/recharge',
          ),
          SizedBox(height: 20),
          _buildServiceButton(
            context,
            icon: Icons.directions_bus,
            label: 'Bus Tickets',
            route: '/bus-tickets',
          ),
          SizedBox(height: 20),
          _buildServiceButton(
            context,
            icon: Icons.monetization_on,
            label: 'Money Transfer',
            route: '/money-transfer',
          ),
          const SizedBox(height: 20),
          _buildServiceButton(
            context,
            icon: Icons.monetization_on,
            label: 'Download Statement',
            route: '/pdf-statement',
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(BuildContext context, {
    required IconData icon, 
    required String label, 
    required String route
  }) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Colors.blueAccent, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blueAccent.withOpacity(0.2),
            ),
            child: Icon(icon, color: Colors.blueAccent),
          ),
          SizedBox(width: 15),
          Text(
            label,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: Colors.black87
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mobile Services'),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildServiceButton(
//               context,
//               icon: Icons.payment,
//               label: 'Recharge',
//               route: '/recharge',
//             ),
//             SizedBox(height: 20),
//             _buildServiceButton(
//               context,
//               icon: Icons.directions_bus,
//               label: 'Bus Tickets',
//               route: '/bus-tickets',
//             ),
//             SizedBox(height: 20),
//             _buildServiceButton(
//               context,
//               icon: Icons.monetization_on,
//               label: 'Money Transfer',
//               route: '/money-transfer',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceButton(BuildContext context, {required IconData icon, required String label, required String route}) {
//     return OutlinedButton(
//       onPressed: () {
//         Navigator.pushNamed(context, route);
//       },
//       style: OutlinedButton.styleFrom(
//         padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         side: BorderSide(color: Colors.blueAccent, width: 2),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: Colors.blueAccent.withOpacity(0.2),
//             ),
//             child: Icon(icon, color: Colors.blueAccent),
//           ),
//           SizedBox(width: 15),
//           Text(
//             label,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // For MethodChannel
// import 'login_screen.dart'; // For LoginScreen
// import '../utils/native.dart'; // For UsbManager

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
  // bool _isConnected = false;
  // // static const platform = MethodChannel('ucb_connection_channel');

  // @override
  // void initState() {
  //   super.initState();
  //   // _checkUcbConnection();
  //   _checkSmartCard();
  // }

  // Future<void> _checkUcbConnection() async {
  //   try {
  //     // Assuming a native method that returns a boolean
  //     final bool result = await platform.invokeMethod('checkUcbConnection');
      
  //     setState(() {
  //       _isConnected = result;
  //     });
  //   } on PlatformException catch (e) {
  //     // Handle any errors from the platform method
  //     print('Failed to check UCB connection: ${e.message}');
  //     setState(() {
  //       _isConnected = false;
  //     });
  //   }
  // }

//   Future<void> _checkSmartCard() async {
//     UsbManager usbManager = UsbManager();
//     var k2 = await usbManager.detectSmartCard();
//     bool detected = true?k2!=null:false;
//     setState(() {
//       _isConnected = detected;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // If not connected, show the "connect" message
//     if (!_isConnected) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Mobile Services'),
//           centerTitle: true,
//           backgroundColor: Colors.blueAccent,
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.signal_wifi_off,
//                 size: 100,
//                 color: Colors.grey,
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Connect TrustToken to use the app',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black54,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _checkSmartCard,
//                 child: Text('Retry Connection'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     // If connected, show the original service buttons
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mobile Services'),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildServiceButton(
//               context,
//               icon: Icons.payment,
//               label: 'Recharge',
//               route: '/recharge',
//             ),
//             SizedBox(height: 20),
//             _buildServiceButton(
//               context,
//               icon: Icons.directions_bus,
//               label: 'Bus Tickets',
//               route: '/bus-tickets',
//             ),
//             SizedBox(height: 20),
//             _buildServiceButton(
//               context,
//               icon: Icons.monetization_on,
//               label: 'Money Transfer',
//               route: '/money-transfer',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceButton(BuildContext context, {
//     required IconData icon, 
//     required String label, 
//     required String route
//   }) {
//     return OutlinedButton(
//       onPressed: () {
//         Navigator.pushNamed(context, route);
//       },
//       style: OutlinedButton.styleFrom(
//         padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         side: BorderSide(color: Colors.blueAccent, width: 2),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: Colors.blueAccent.withOpacity(0.2),
//             ),
//             child: Icon(icon, color: Colors.blueAccent),
//           ),
//           SizedBox(width: 15),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 18, 
//               fontWeight: FontWeight.bold, 
//               color: Colors.black87
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }