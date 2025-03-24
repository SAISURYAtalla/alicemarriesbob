

// screens/payment_gateway_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentGatewayScreen extends StatefulWidget {
  @override
  _PaymentGatewayScreenState createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  final List<TextEditingController> _pinControllers = 
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = 
      List.generate(6, (index) => FocusNode());

  void _onPinChanged(int index, String value) {
    if (value.length == 1) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  void _verifyPayment() {
    String pin = _pinControllers.map((controller) => controller.text).join();
    if (pin.length == 6) {
      // Get the payment details passed from previous screen
      final Map<String, dynamic>? args = 
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Payment Successful'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type: ${args['type']}'),
                  Text('Amount: ₹${args['amount']}'),
                  if (args['type'] == 'Bus Ticket')
                    Text('Seats: ${args['seats']}'),
                  if (args['type'] == 'Recharge')
                    Text('Number: ${args['number']}'),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter complete 6-digit PIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the payment details passed from previous screen
    final Map<String, dynamic>? args = 
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Gateway'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (args != null) 
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Details',
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Type: ${args['type']}'),
                      Text('Amount: ₹${args['amount']}'),
                      if (args['type'] == 'Bus Ticket')
                        Text('Seats: ${args['seats']}'),
                      if (args['type'] == 'Recharge')
                        Text('Number: ${args['number']}'),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),
            Text(
              'Enter 6-Digit PIN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: TextField(
                    controller: _pinControllers[index],
                    focusNode: _focusNodes[index],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => _onPinChanged(index, value),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Verify Payment'),
              onPressed: _verifyPayment,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}