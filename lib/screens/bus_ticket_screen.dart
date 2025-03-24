import 'package:flutter/material.dart';

class BusTicketScreen extends StatefulWidget {
  @override
  _BusTicketScreenState createState() => _BusTicketScreenState();
}

class _BusTicketScreenState extends State<BusTicketScreen> {
  List<bool> _seatSelection = List.generate(20, (index) => false);
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Seat Selection'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _seatSelection[index] ? Colors.green : Colors.blue,
                    ),
                    child: Text('${index + 1}'),
                    onPressed: () {
                      setState(() {
                        _seatSelection[index] = !_seatSelection[index];
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ticket Price',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text('Proceed to Payment'),
              onPressed: () {
                if (_seatSelection.contains(true) && _amountController.text.isNotEmpty) {
                  Navigator.pushNamed(
                    context, 
                    '/payment-gateway', 
                    arguments: {
                      'type': 'Bus Ticket',
                      'seats': _seatSelection.where((seat) => seat).length,
                      'amount': _amountController.text
                    }
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select seats and enter ticket price')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class BusTicketScreen extends StatefulWidget {
//   @override
//   _BusTicketScreenState createState() => _BusTicketScreenState();
// }

// class _BusTicketScreenState extends State<BusTicketScreen> {
//   List<bool> _seatSelection = List.generate(20, (index) => false);
//   final TextEditingController _amountController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bus Seat Selection'),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           Text(
//             'Select Your Seat',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: Center(
//               child: Container(
//                 padding: EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black, width: 2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.directions_bus, size: 50, color: Colors.blue),
//                     SizedBox(height: 10),
//                     GridView.builder(
//                       shrinkWrap: true,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 4,
//                         childAspectRatio: 1,
//                       ),
//                       itemCount: 20,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _seatSelection[index] = !_seatSelection[index];
//                               });
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: _seatSelection[index] ? Colors.green : Colors.blue,
//                                 borderRadius: BorderRadius.circular(5),
//                                 border: Border.all(color: Colors.black),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   '${index + 1}',
//                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _amountController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Ticket Price',
//                 prefixText: '₹ ',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//               ),
//               child: Text('Proceed to Payment'),
//               onPressed: () {
//                 if (_seatSelection.contains(true) && _amountController.text.isNotEmpty) {
//                   Navigator.pushNamed(
//                     context, 
//                     '/payment-gateway', 
//                     arguments: {
//                       'type': 'Bus Ticket',
//                       'seats': _seatSelection.where((seat) => seat).length,
//                       'amount': _amountController.text
//                     }
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Please select seats and enter ticket price')),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }