import 'package:flutter/material.dart';
import 'package:stcmng/pages/DBhandling/DataBaseHelper.dart';
import 'package:stcmng/pages/DBhandling/produck_model.dart';
import 'package:stcmng/pages/Wigdets/ScannerScreen.dart';
import 'package:stcmng/pages/add_product.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  String _searchQuery = "";
  List<Product> _allProducts = []; // original full list

  List<Product> _products = [];
  final Set<int> _selectedProductIds = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isSelectionMode
                ? Text("${_selectedProductIds.length}")
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
      body: GestureDetector(
        onTap: () {
          if (_isSelectionMode) {
            _cancelSelection();
          }
          FocusScope.of(context).unfocus(); // hide keyboard
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: "Recherche",
                  prefixIcon: IconButton(
                    icon: Image.asset(
                      "assets/icons/barcode-scan.png",
                      width: 24, // you can adjust size
                      height: 24,
                    ),
                    onPressed: () async {
                      await scanDef(); // reload all
                    },
                  ),
                  suffixIcon:
                      _isSearchFocused && _searchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () async {
                              _searchController.clear();
                              _unfocusAfterRebuild(); // hide keyboard
                              setState(() {
                                _searchQuery = '';
                              });
                              await _loadProducts(); // reload all
                            },
                          )
                          : null,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _products = _filterProducts(_searchQuery);
                  });
                },
              ),
            ),
            Expanded(
              child:
                  _products.isEmpty
                      ? Center(child: Text("Aucun produit trouvé"))
                      : ListView.builder(
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          final isSelected = _selectedProductIds.contains(
                            product.id,
                          );

                          return ListTile(
                            tileColor:
                                isSelected
                                    ? Colors.grey.withOpacity(0.3)
                                    : Colors.transparent,
                            title: Text(product.name),
                            subtitle: Text(
                              "Qty: ${product.qty} | Prix: ${product.price}",
                            ),
                            trailing: Text("Barcode: ${product.barcode}"),
                            onLongPress: () {
                              FocusScope.of(context).unfocus();
                              _toggleSelection(product.id!);
                            },
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              if (_isSelectionMode) {
                                _toggleSelection(product.id!);
                              }
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadProducts() async {
    final products = await DatabaseHelper.instance.getAllProducts();
    setState(() {
      _allProducts = products;
      _products = _filterProducts(_searchQuery);
      _selectedProductIds.clear();
      _isSelectionMode = false;
    });
    _unfocusAfterRebuild();
  }

  List<Product> _filterProducts(String query) {
    return _allProducts
        .where(
          (product) =>
              product.name.toLowerCase().startsWith(query.toLowerCase()),
        )
        .toList();
  }

  Future<void> _loadProductsByBarcode(String barcodevalue) async {
    final products = await DatabaseHelper.instance.getAllProducts();
    setState(() {
      _allProducts = products;
      _products = _filterProductsByBarcode(barcodevalue);
      _selectedProductIds.clear();
      _isSelectionMode = false;
    });
  }

  List<Product> _filterProductsByBarcode(String query) {
    return _allProducts
        .where(
          (product) =>
              product.barcode.toLowerCase().startsWith(query.toLowerCase()),
        )
        .toList();
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
            title: const Text('Confirmer'),
            content: Text(
              '${_selectedProductIds.length} éléments seront supprimés',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Supprimer'),
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

  Future<void> scanDef() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScannerScreen()),
    );

    if (result != null && mounted) {
      await _loadProductsByBarcode(result);
    }
    _unfocusAfterRebuild();
  }

  void _unfocusAfterRebuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }
}
