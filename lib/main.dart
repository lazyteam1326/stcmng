import 'package:flutter/material.dart';

import 'package:stcmng/pages/add_product.dart';
import 'package:stcmng/pages/edit_name.dart';
import 'package:stcmng/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AddProduct());
  }
}
