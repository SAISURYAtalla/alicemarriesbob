import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

// class PDFViewerScreen extends StatelessWidget {
//   final String pdfPath;

//   const PDFViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: SfPdfViewer.file(
//         File(pdfPath),
//         canShowPageLoadingIndicator: true,
//         canShowScrollHead: true,
//       ),
//     );
//   }
// }


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _openLocalPDF(BuildContext context) async {
    try {
      // Load PDF from assets
      final byteData = await rootBundle.load('assets/sample.pdf');
      
      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/sample.pdf';

      // Save PDF to file
      final File file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Navigate to PDF Viewer Screen
      Navigator.pushNamed(
        context, 
        '/pdf-viewer', 
        arguments: filePath
      );
    } catch (e) {
      // Show error
      _showErrorDialog(context, 'Error: ${e.toString()}');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Services'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
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
            SizedBox(height: 20),
            _buildServiceButton(
              context,
              icon: Icons.picture_as_pdf,
              label: 'Transactions PDF',
              onPressed: () => _openLocalPDF(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? route,
    VoidCallback? onPressed,
  }) {
    return OutlinedButton(
      onPressed: route != null
          ? () => Navigator.pushNamed(context, route)
          : onPressed,
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
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
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
//             SizedBox(height: 20),
//             _buildServiceButton(
//               context,
//               icon: Icons.picture_as_pdf,
//               label: 'Transactions PDF',
//               onPressed: () => _downloadAndOpenPDF(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _downloadAndOpenPDF(BuildContext context) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );

//     try {
      
//       // final response = await http.get(
//       //   Uri.parse('http://your-api-url:3000/api/v1/transactions/pdf'),
//       //   headers: {
//       //     'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // Add your auth token
//       //   },
//       // );
     
//       final response = await http.get(
//   Uri.parse('https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf')
// );

//       // Dismiss loading indicator
//       Navigator.of(context).pop();

//       if (response.statusCode == 200) {
//         // Get temporary directory
//         final directory = await getTemporaryDirectory();
//         final filePath = '${directory.path}/transactions.pdf';

//         // Save PDF to file
//         final File file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         // Navigate to PDF View Screen
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PDFViewerScreen(pdfPath: filePath),
//           ),
//         );
//       } else {
//         // Show error
//         _showErrorDialog(context, 'Failed to download PDF');
//       }
//     } catch (e) {
//       // Dismiss loading indicator
//       Navigator.of(context).pop();
      
//       // Show error
//       _showErrorDialog(context, 'Error: ${e.toString()}');
//     }
//   }

//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Okay'),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildServiceButton(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     String? route,
//     VoidCallback? onPressed,
//   }) {
//     return OutlinedButton(
//       onPressed: route != null
//           ? () => Navigator.pushNamed(context, route)
//           : onPressed,
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
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PDFViewerScreen extends StatelessWidget {
//   final String pdfPath;

//   const PDFViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Transactions PDF'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: PDFView(
//         filePath: pdfPath,
//         enableSwipe: true,
//         swipeHorizontal: true,
//         autoSpacing: false,
//         pageFling: false,
//         onError: (error) {
//           print(error.toString());
//         },
//         onPageError: (page, error) {
//           print('$page: ${error.toString()}');
//         },
//       ),
//     );
//   }
// }


////////////////////////////////////////////////////////////////////////


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // For MethodChannel
// import 'login_screen.dart'; // For LoginScreen
// import '../utils/native.dart'; // For UsbManager

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool _isConnected = false;
//   // static const platform = MethodChannel('ucb_connection_channel');

//   @override
//   void initState() {
//     super.initState();
//     // _checkUcbConnection();
//     _checkSmartCard();
//   }

//   // Future<void> _checkUcbConnection() async {
//   //   try {
//   //     // Assuming a native method that returns a boolean
//   //     final bool result = await platform.invokeMethod('checkUcbConnection');
      
//   //     setState(() {
//   //       _isConnected = result;
//   //     });
//   //   } on PlatformException catch (e) {
//   //     // Handle any errors from the platform method
//   //     print('Failed to check UCB connection: ${e.message}');
//   //     setState(() {
//   //       _isConnected = false;
//   //     });
//   //   }
//   // }

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