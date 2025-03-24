import 'package:flutter/material.dart';

class RechargeScreen extends StatefulWidget {
  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  
  // Dummy saved numbers
  final List<String> savedNumbers = [
    '9876543210',
    '8765432109',
    '7654321098'
  ];

  String? _selectedSavedNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Recharge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Recharge Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('Saved Numbers:', style: TextStyle(fontSize: 16)),
            Wrap(
              spacing: 10,
              children: savedNumbers.map((number) {
                return ChoiceChip(
                  label: Text(number),
                  selected: _selectedSavedNumber == number,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedSavedNumber = selected ? number : null;
                      _numberController.text = selected ? number : '';
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Proceed to Payment'),
              onPressed: () {
                if (_numberController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                  Navigator.pushNamed(
                    context, 
                    '/payment-gateway', 
                    arguments: {
                      'type': 'Recharge',
                      'number': _numberController.text,
                      'amount': _amountController.text
                    }
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter mobile number and amount')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
