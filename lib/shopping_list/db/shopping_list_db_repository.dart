import "package:path/path.dart";
import 'package:shopping_list/shopping_list/db/shopping_item_db.dart';
import "package:sqflite/sqflite.dart";

import '../shopping_list.dart';
import '../shopping_list_item.dart';
import '../shopping_list_repository.dart';

class ShoppingListDBRepository extends ShoppingListRepository {
  static const _SHOPPING_LIST_ITEMS_DB_NAME = "shopping_list_item";
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
      _SHOPPING_LIST_ITEMS_DB_NAME,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  remove(String itemId) {
    _removeShoppingListItem(itemId);
  }

  @override
  removeAll() async {
    final Database db = await database;

    await db.delete(_SHOPPING_LIST_ITEMS_DB_NAME);
  }

  Future<void> _removeShoppingListItem(String itemId) async {
    final Database db = await database;

    await db.delete(
      _SHOPPING_LIST_ITEMS_DB_NAME,
      where: "item_id = ?",
      whereArgs: [itemId],
    );
  }

  @override
  Future<List<ShoppingList>> getShoppingLists() async {
    final Database db = await database;

    final List<Map<String, dynamic>> dbEntries =
    await db.query(_SHOPPING_LIST_ITEMS_DB_NAME);

    var entries = dbEntries.map((e) => ShoppingItemDB.fromMap(e));

    return entries
        .map((ShoppingItemDB e) => e.shoppingListId)
        .toSet()
        .map((String listId) => createShoppingList(listId, entries))
        .toList();
  }

  @override
  Future<ShoppingList> getShoppingList(String id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> dbEntries = await db.query(
        _SHOPPING_LIST_ITEMS_DB_NAME,
        where: "shopping_list_id = ?",
        whereArgs: [id]);

    var entries = dbEntries
        .map((e) => ShoppingItemDB.fromMap(e))
        .map((ShoppingItemDB e) => e.toUIModel())
        .toList();
    return ShoppingList(id, entries);
  }

  ShoppingList createShoppingList(id, Iterable<ShoppingItemDB> entries) {
    return ShoppingList(
        id,
        entries
            .where((item) => item.shoppingListId == id)
            .map((item) => item.toUIModel())
            .toList());
  }

  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), "shopping_list.db"),
      onCreate: (db, version) {
        db.execute("CREATE TABLE $_SHOPPING_LIST_ITEMS_DB_NAME("
            "item_id TEXT PRIMARY KEY, "
            "shopping_list_id TEXT, "
            "title TEXT, "
            "flagged INTEGER)");
      },
      version: 1,
    );
  }
}
