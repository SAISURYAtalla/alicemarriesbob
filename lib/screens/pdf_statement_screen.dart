import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; 
import '../utils/native.dart';

class PdfStatementScreen extends StatefulWidget {
  @override
  _PdfStatementScreenState createState() => _PdfStatementScreenState();
}

class _PdfStatementScreenState extends State<PdfStatementScreen> {
  bool? isTrustTokenDetected;
  String? pdfFilePath; // Path of the downloaded PDF

  @override
  void initState() {
    super.initState();
    _checkTrustToken();
  }

  /// Check TrustToken connection
  Future<void> _checkTrustToken() async {
    UsbManager usbManager = UsbManager();
    var smartCard = await usbManager.detectSmartCard();
    bool detected = smartCard != null;

    setState(() {
      isTrustTokenDetected = detected;
    });

    if (detected) {
      _fetchAndSavePdf(); // Fetch and save the PDF if TrustToken is detected
    } else {
      _showSnackbar('No TrustToken detected. Unable to display the PDF.');
    }
  }

  /// Fetch the PDF from the API and save it locally
  Future<void> _fetchAndSavePdf() async {
    const String apiUrl = 'http://localhost:3000/api/v1/account/transactions/pdf';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Get a temporary directory
        final Directory tempDir = await getTemporaryDirectory();
        final String filePath = '${tempDir.path}/statement.pdf';

        // Save the PDF locally
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          pdfFilePath = filePath;
        });

        _showSnackbar('PDF fetched and saved successfully.');
      } else {
        _showSnackbar('Failed to fetch PDF. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackbar('Error fetching PDF: $e');
    }
  }

  /// Show Snackbar for notifications
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
    if (isTrustTokenDetected == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('PDF Statement'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Statement'),
      ),
      body: Center(
        child: isTrustTokenDetected == true
            ? (pdfFilePath != null
                ? PDFView(
                    filePath: pdfFilePath,
                  )
                : const CircularProgressIndicator())
            : const Text(
                'No TrustToken detected. Unable to display PDF.',
                style: TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkTrustToken,
        child: Icon(
          isTrustTokenDetected == true ? Icons.usb : Icons.usb_off,
        ),
      ),
    );
  }
}
