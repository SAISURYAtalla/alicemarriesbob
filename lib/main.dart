import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/recharge_screen.dart';
import 'screens/bus_ticket_screen.dart';
import 'screens/payment_gateway_screen.dart';
import 'screens/money_transfer_screen.dart';
import 'screens/login_screen.dart';
import 'screens/pdf_viewer_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Services App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/home',
      routes: {
        '/': (context) => AppLockScreen(),
        '/home': (context) => HomeScreen(),
        '/recharge': (context) => RechargeScreen(),
        '/bus-tickets': (context) => BusTicketScreen(),
        '/payment-gateway': (context) => PaymentGatewayScreen(),
        '/money-transfer': (context) => MoneyTransferScreen(), // New route
        '/pdf-viewer': (context) => PDFViewerScreen(
          pdfPath: ModalRoute.of(context)!.settings.arguments as String,
        ),
      },
    );
  }
}
