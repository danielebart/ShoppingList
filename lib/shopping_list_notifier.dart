import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';
import 'package:shopping_list/shopping_list_repository.dart';
import 'package:uuid/uuid.dart';

class ShoppingListNotifier with ChangeNotifier {
  String currentListId = "0";
  final ShoppingListRepository shoppingListRepository;
  ShoppingList _inMemoryShoppingList;

  ShoppingListNotifier(this.shoppingListRepository);

  Stream<ShoppingList> get list {
    if (_inMemoryShoppingList == null) {
      return shoppingListRepository
          .getShoppingList(currentListId)
          .asStream()
          .handleError((e, stacktrace) => print("$e\n$stacktrace"))
          .map((list) {
        _inMemoryShoppingList = list;
        return list;
      });
    } else {
      return Stream.fromFuture(Future.value(_inMemoryShoppingList));
    }
  }

  addItem(String title) {
    if (title.isEmpty) return;

    var uuid = new Uuid();
    var item = ShoppingListItem(
        id: uuid.v4(), listId: currentListId, title: title, flagged: false);

    _inMemoryShoppingList?.items?.add(item);
    shoppingListRepository.add(item);
    notifyListeners();
  }

  removeItem(String id) {
    _inMemoryShoppingList?.items?.removeWhere((item) => item.id == id);
    shoppingListRepository.remove(id);
  }

  setFlagged(String id, bool flagged) {
    final item = findByID(id);
    final listItemIndex = _inMemoryShoppingList.items.indexOf(item);
    _inMemoryShoppingList.items[listItemIndex] = ShoppingListItem(
        id: id, listId: item.listId, title: item.title, flagged: flagged);
    notifyListeners();
  }

  ShoppingListItem findByID(final String id) => _inMemoryShoppingList.items
      .firstWhere((ShoppingListItem item) => item.id == id);
}

class ShoppingList {
  final String id;
  final List<ShoppingListItem> items;

  ShoppingList(this.id, this.items);
}

class ShoppingListItem {
  final String listId;
  final String id;
  final bool flagged;
  final String title;

  ShoppingListItem({this.id, this.listId, this.flagged, this.title});

  @override
  bool operator ==(o) =>
      o is ShoppingListItem && flagged == o.flagged && title == o.title;

  @override
  int get hashCode => hash2(flagged.hashCode, title.hashCode);
}
