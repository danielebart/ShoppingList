import "package:path/path.dart";
import 'package:shopping_list/shopping_list/db/shopping_item_db.dart';
import "package:sqflite/sqflite.dart";

import '../shopping_list.dart';
import '../shopping_list_item.dart';
import '../shopping_list_repository.dart';

class ShoppingListDBRepository extends ShoppingListRepository {
  final Future<Database> database = _openDB();

  @override
  add(ShoppingListItem item) {
    _insertShoppingListItem(ShoppingItemDB(
        itemId: item.id,
        shoppingListId: item.listId,
        flagged: item.flagged,
        title: item.title));
  }

  Future<void> _insertShoppingListItem(ShoppingItemDB item) async {
    final Database db = await database;

    await db.insert(
      "shopping_list_item",
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  remove(String itemId) {
    _removeShoppingListItem(itemId);
  }

  Future<void> _removeShoppingListItem(String itemId) async {
    final Database db = await database;

    await db.delete(
      "shopping_list_item",
      where: "item_id = ?",
      whereArgs: [itemId],
    );
  }

  @override
  Future<List<ShoppingList>> getShoppingLists() async {
    final Database db = await database;

    final List<Map<String, dynamic>> dbEntries =
        await db.query("shopping_list_item");

    var entries = dbEntries.map((e) => ShoppingItemDB.fromMap(e));

    return entries
        .map((e) => e.shoppingListId)
        .toSet()
        .map((listId) => createShoppingList(listId, entries))
        .toList();
  }

  @override
  Future<ShoppingList> getShoppingList(String id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> dbEntries = await db.query(
        "shopping_list_item",
        where: "shopping_list_id = ?",
        whereArgs: [id]);

    var entries = dbEntries
        .map((e) => ShoppingItemDB.fromMap(e))
        .map((ShoppingItemDB e) => e.toUIModel())
        .toList();
    return ShoppingList(id, entries);
  }

  createShoppingList(id, entries) => ShoppingList(
      id,
      entries
          .where((item) => item.shoppingListId == id)
          .toList()
          .map((item) => item.toUIModel()));

  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), "shopping_list.shopping_list.db"),
      onCreate: (db, version) {
        db.execute("CREATE TABLE shopping_list_item("
            "item_id TEXT PRIMARY KEY, "
            "shopping_list_id TEXT, "
            "title TEXT, "
            "flagged INTEGER"
            ")");
      },
      version: 1,
    );
  }
}
