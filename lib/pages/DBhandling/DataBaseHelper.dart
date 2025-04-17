import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stcmng/pages/DBhandling/produck_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        qty INTEGER NOT NULL,
        price INTEGER NOT NULL,
        barcode TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final result = await db.query('products');
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products', // use your actual table name
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> barcodeExists(String barcode) async {
    final db = await instance.database;
    final result = await db.query(
      'products', // replace with your actual table name
      where: 'barcode = ?',
      whereArgs: [barcode],
    );
    return result.isNotEmpty;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
