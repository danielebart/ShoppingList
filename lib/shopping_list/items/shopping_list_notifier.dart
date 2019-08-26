import 'package:flutter/foundation.dart';

import '../shopping_list.dart';
import '../shopping_list_item.dart';
import '../shopping_list_repository.dart';

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

  onItemAdded(ShoppingListItem item) {
    if (_inMemoryShoppingList == null) {
      _inMemoryShoppingList = ShoppingList(currentListId, []);
    }
    _inMemoryShoppingList.items.add(item);
    notifyListeners();
  }

  removeItem(String id) {
    _inMemoryShoppingList.items?.removeWhere((item) => item.id == id);
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
