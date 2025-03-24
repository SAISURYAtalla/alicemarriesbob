import 'package:flutter/material.dart';

class MoneyTransferScreen extends StatefulWidget {
  @override
  _MoneyTransferScreenState createState() => _MoneyTransferScreenState();
}

class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  
  // Dummy saved contacts
  final List<Map<String, String>> savedContacts = [
    {'name': 'John Doe', 'number': '9876543210'},
    {'name': 'Jane Smith', 'number': '8765432109'},
    {'name': 'Alice Johnson', 'number': '7654321098'}
  ];

  String? _selectedContact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Transfer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _mobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Recipient Mobile Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount to Transfer',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            SizedBox(height: 20),
            Text('Saved Contacts:', style: TextStyle(fontSize: 16)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: savedContacts.map((contact) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text('${contact['name']} (${contact['number']})'),
                      selected: _selectedContact == contact['number'],
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedContact = selected ? contact['number'] : null;
                          _mobileNumberController.text = selected ? contact['number']! : '';
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Proceed to Payment'),
              onPressed: () {
                if (_mobileNumberController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                  Navigator.pushNamed(
                    context, 
                    '/payment-gateway', 
                    arguments: {
                      'type': 'Money Transfer',
                      'number': _mobileNumberController.text,
                      'amount': _amountController.text
                    }
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter recipient number and amount')),
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