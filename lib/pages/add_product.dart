import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stcmng/tempscan.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late String nameValue, barcodeValue = "Barcode Value";
  late int qtyValue, priceValue;

  Color nextPhoneColor = Colors.white;
  Color nextTextColor = const Color.fromARGB(82, 61, 61, 61);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add product')),
      body: Column(
        children: [
          // add name
          Text(
            'product name',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 224, 224, 224),
                ), // Specify your desired color
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 0, 0, 0),
                ), // Specify your desired color
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            style: const TextStyle(fontSize: 15),
            onChanged: (name) {
              if (name.isNotEmpty) {
                setState(() {
                  nameValue = name;
                  nextPhoneColor = Colors.black;
                  nextTextColor = Colors.white;
                });
              } else {
                setState(() {
                  nextPhoneColor = Colors.white;
                  nextTextColor = const Color.fromARGB(82, 61, 61, 61);
                });
              }
            },
          ),

          // add qantity
          Text(
            'Quantity',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 224, 224, 224),
                ), // Specify your desired color
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 0, 0, 0),
                ), // Specify your desired color
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            style: const TextStyle(fontSize: 15),
            onChanged: (qty) {
              if (qty.isNotEmpty) {
                setState(() {
                  qtyValue = int.tryParse(qty) ?? 106;
                  nextPhoneColor = Colors.black;
                  nextTextColor = Colors.white;
                });
              } else {
                setState(() {
                  nextPhoneColor = Colors.white;
                  nextTextColor = const Color.fromARGB(82, 61, 61, 61);
                });
              }
            },
          ),
          // add price
          Text(
            'Price',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 224, 224, 224),
                ), // Specify your desired color
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 0, 0, 0),
                ), // Specify your desired color
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            style: const TextStyle(fontSize: 15),
            onChanged: (price) {
              if (price.isNotEmpty) {
                setState(() {
                  priceValue = int.tryParse(price) ?? 106;
                  nextPhoneColor = Colors.black;
                  nextTextColor = Colors.white;
                });
              } else {
                setState(() {
                  nextPhoneColor = Colors.white;
                  nextTextColor = const Color.fromARGB(82, 61, 61, 61);
                });
              }
            },
          ),

          // add barcode
          Text(
            'Add Barcode',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
          InkWell(
            onTap: scanDef,
            child: Text(barcodeValue, style: TextStyle(fontSize: 30)),
          ),
          SizedBox(height: 30),
          //save btn
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 73, 0, 170),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> scanDef() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScannerScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        barcodeValue = result;
      });
    }
  }
}
