import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stcmng/pages/DBhandling/DataBaseHelper.dart';
import 'package:stcmng/pages/DBhandling/produck_model.dart';
import 'package:stcmng/tempscan.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String nameValue = "", barcodeValue = "click to scan";
  int qtyValue = 0, priceValue = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Color nextPhoneColor = Colors.white;
  // Color nextTextColor = const Color.fromARGB(82, 61, 61, 61);
  Color fieldRequired = Colors.red,
      borderColor = Color.fromARGB(255, 224, 224, 224);

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
            controller: nameController,
            decoration: InputDecoration(
              labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor,
                ), // Specify your desired color
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 0, 0, 0),
                ), // Specify your desired color
              ),
            ),
            style: const TextStyle(fontSize: 15),
            onChanged: (name) {
              if (name.isNotEmpty) {
                setState(() {
                  nameValue = name;
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
            controller: qtyController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor,
                ), // Specify your desired color
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 0, 0, 0),
                ), // Specify your desired color
              ),
            ),
            style: const TextStyle(fontSize: 15),
            onChanged: (qty) {
              if (qty.isNotEmpty) {
                setState(() {
                  qtyValue = int.tryParse(qty) ?? 106;
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
            controller: priceController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor,
                ), // Specify your desired color
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 0, 0, 0),
                ), // Specify your desired color
              ),
            ),
            style: const TextStyle(fontSize: 15),
            onChanged: (price) {
              if (price.isNotEmpty) {
                setState(() {
                  priceValue = int.tryParse(price) ?? 106;
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
              onPressed: saveProduct,
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
      // Check if barcode already exists
      bool exists = await DatabaseHelper.instance.barcodeExists(result);
      if (exists) {
        setState(() {
          barcodeValue = "scan again";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Barcode already exists!")),
        );
        return;
      }
      setState(() {
        barcodeValue = result;
      });
    }
  }

  void saveProduct() async {
    // Validation check
    if (nameValue.isEmpty ||
        barcodeValue == "click to scan" ||
        barcodeValue == "scan again" ||
        qtyValue == 0 ||
        priceValue == 0) {
      setState(() {
        borderColor = fieldRequired;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All fields are required!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    Product newProduct = Product(
      name: nameValue,
      qty: qtyValue,
      price: priceValue,
      barcode: barcodeValue,
    );

    await DatabaseHelper.instance.insertProduct(newProduct);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Product saved!")));

    nameController.clear();
    qtyController.clear();
    priceController.clear();
    setState(() {
      barcodeValue = "click to scan";
      nameValue = "";
      qtyValue = 0;
      priceValue = 0;
      borderColor = Color.fromARGB(255, 224, 224, 224);
    });
  }
}
