import 'package:flutter/material.dart';
import 'package:stcmng/pages/DBhandling/DataBaseHelper.dart';
import 'package:stcmng/pages/DBhandling/produck_model.dart';
import 'package:stcmng/pages/add_product.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> _products = [];
  final Set<int> _selectedProductIds = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isSelectionMode
                ? Text("${_selectedProductIds.length} selected")
                : Text("Stock"),
        leading:
            _isSelectionMode
                ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: _cancelSelection,
                )
                : null,
        actions:
            _isSelectionMode
                ? [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: _deleteSelectedProducts,
                  ),
                ]
                : [],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => AddProduct()));
          _loadProducts();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body:
          _products.isEmpty
              ? Center(child: Text("No products yet"))
              : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  final isSelected = _selectedProductIds.contains(product.id);

                  return ListTile(
                    tileColor:
                        isSelected
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.transparent,
                    title: Text(product.name),
                    subtitle: Text(
                      "Qty: ${product.qty} | Price: ${product.price}",
                    ),
                    trailing: Text("Barcode: ${product.barcode}"),
                    onLongPress: () {
                      _toggleSelection(product.id!);
                    },
                    onTap: () {
                      if (_isSelectionMode) {
                        _toggleSelection(product.id!);
                      }
                    },
                  );
                },
              ),
    );
  }

  Future<void> _loadProducts() async {
    final products = await DatabaseHelper.instance.getAllProducts();
    setState(() {
      _products = products;
      _selectedProductIds.clear();
      _isSelectionMode = false;
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedProductIds.contains(id)) {
        _selectedProductIds.remove(id);
      } else {
        _selectedProductIds.add(id);
      }
      _isSelectionMode = _selectedProductIds.isNotEmpty;
    });
  }

  void _deleteSelectedProducts() async {
    if (_selectedProductIds.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: Text(
              'Are you sure you want to delete ${_selectedProductIds.length} selected item(s)?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      for (int id in _selectedProductIds) {
        await DatabaseHelper.instance.deleteProduct(id);
      }

      _selectedProductIds.clear();
      _isSelectionMode = false;
      _loadProducts();
    }
  }

  void _cancelSelection() {
    setState(() {
      _isSelectionMode = false;
      _selectedProductIds.clear();
    });
  }
}
