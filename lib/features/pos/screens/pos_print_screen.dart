// import 'dart:async';
// // import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';

// class PosPrintScreen extends StatefulWidget {
//   const PosPrintScreen({super.key});

//   @override
//   PosPrintScreenState createState() => PosPrintScreenState();
// }

// class PosPrintScreenState extends State<PosPrintScreen> {

//   @override
//   void initState() {
//     super.initState();
//   }

//   bool connected = false;
//   List availableBluetoothDevices = [];

//   Future<List<int>> getGraphicsTicket() async {
//     List<int> bytes = [];

//     CapabilityProfile profile = await CapabilityProfile.load();
//     final generator = Generator(PaperSize.mm80, profile);

//     /// Print QR Code using native function
//     bytes += generator.qrcode('example.com');

//     bytes += generator.hr();

//     /// Print Barcode using native function
//     final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
//     bytes += generator.barcode(Barcode.upcA(barData));

//     bytes += generator.cut();

//     return bytes;
//   }

//   Future<List<int>> getTicket() async {

//     List<int> bytes = [];
//     CapabilityProfile profile = await CapabilityProfile.load();
//     final generator = Generator(PaperSize.mm80, profile);

//     bytes += generator.text(
//       "Demo Shop",
//       styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2),
//       linesAfter: 1,
//     );

//     bytes += generator.text(
//       "18th Main Road, 2nd Phase, J. P. Nagar, Bengaluru, Karnataka 560078",
//       styles: const PosStyles(align: PosAlign.center),
//     );

//     bytes += generator.text(
//       'Tel: +919591708470',
//       styles: const PosStyles(align: PosAlign.center),
//     );

//     bytes += generator.hr();
//     bytes += generator.row([

//       PosColumn(
//         text: 'No',
//         width: 1,
//         styles: const PosStyles(align: PosAlign.left, bold: true),
//       ),

//       PosColumn(
//         text: 'Item',
//         width: 5,
//         styles: const PosStyles(align: PosAlign.left, bold: true),
//       ),

//       PosColumn(
//         text: 'Price',
//         width: 2,
//         styles: const PosStyles(align: PosAlign.center, bold: true),
//       ),

//       PosColumn(
//         text: 'Qty',
//         width: 2,
//         styles: const PosStyles(align: PosAlign.center, bold: true),
//       ),

//       PosColumn(
//         text: 'Total',
//         width: 2,
//         styles: const PosStyles(align: PosAlign.right, bold: true),
//       ),

//     ]);

//     bytes += generator.row([

//       PosColumn(text: "1", width: 1),

//       PosColumn(
//         text: "Tea",
//         width: 5,
//         styles: const PosStyles(align: PosAlign.left),
//       ),

//       PosColumn(
//         text: "10",
//         width: 2,
//         styles: const PosStyles(align: PosAlign.center),
//       ),

//       PosColumn(text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),

//       PosColumn(text: "10", width: 2, styles: const PosStyles(align: PosAlign.right)),

//     ]);

//     bytes += generator.row([

//       PosColumn(text: "2", width: 1),

//       PosColumn(
//         text: "Sada Dosa",
//         width: 5,
//         styles: const PosStyles(align: PosAlign.left),
//       ),

//       PosColumn(
//         text: "30",
//         width: 2,
//         styles: const PosStyles(align: PosAlign.center),
//       ),

//       PosColumn(text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),

//       PosColumn(text: "30", width: 2, styles: const PosStyles(align: PosAlign.right)),

//     ]);

//     bytes += generator.row([

//       PosColumn(text: "3", width: 1),

//       PosColumn(
//         text: "Masala Dosa",
//         width: 5,
//         styles: const PosStyles(align: PosAlign.left),
//       ),

//       PosColumn(
//         text: "50",
//         width: 2,
//         styles: const PosStyles(align: PosAlign.center),
//       ),

//       PosColumn(text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),

//       PosColumn(text: "50", width: 2, styles: const PosStyles(align: PosAlign.right)),

//     ]);

//     bytes += generator.row([

//       PosColumn(text: "4", width: 1),

//       PosColumn(
//         text: "Rova Dosa",
//         width: 5,
//         styles: const PosStyles(align: PosAlign.left),
//       ),

//       PosColumn(
//         text: "70",
//         width: 2,
//         styles: const PosStyles(align: PosAlign.center),
//       ),

//       PosColumn(text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),

//       PosColumn(text: "70", width: 2, styles: const PosStyles(align: PosAlign.right)),

//     ]);

//     bytes += generator.hr();

//     bytes += generator.row([

//       PosColumn(
//         text: 'TOTAL',
//         width: 6,
//         styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size4, width: PosTextSize.size4),
//       ),

//       PosColumn(
//         text: "160",
//         width: 6,
//         styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size4, width: PosTextSize.size4),
//       ),

//     ]);

//     bytes += generator.hr(ch: '=', linesAfter: 1);

//     bytes += generator.text(
//       'Thank you!',
//       styles: const PosStyles(align: PosAlign.center, bold: true),
//     );

//     bytes += generator.text(
//       "26-11-2020 15:22:45",
//       styles: const PosStyles(align: PosAlign.center),
//       linesAfter: 1,
//     );

//     bytes += generator.text(
//       'Note: Goods once sold will not be taken back or exchanged.',
//       styles: const PosStyles(align: PosAlign.center, bold: false),
//     );

//     bytes += generator.cut();
//     return bytes;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bluetooth Thermal Printer Demo'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         child: Container(),
//       ),
//     );
//   }
// }