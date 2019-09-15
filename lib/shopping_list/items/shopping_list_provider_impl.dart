import 'package:flutter/foundation.dart';
import 'package:shopping_list/shopping_list/items/shopping_list_provider.dart';

import '../shopping_list.dart';
import '../shopping_list_item.dart';
import '../shopping_list_repository.dart';

class ShoppingListProviderImpl
    with ChangeNotifier
    implements ShoppingListProvider {
  String _currentListId = "0"; // TODO add logic for multiple lists
  final ShoppingListRepository
  _shoppingListRepository; // TODO move it in a interactor
  ShoppingList _inMemoryShoppingList; // TODO move it in a interactor

  ShoppingListProviderImpl(this._shoppingListRepository);

  @override
  String get currentListId => _currentListId;

  @override
  Stream<ShoppingList> get list {
    if (_inMemoryShoppingList == null) {
      return _shoppingListRepository
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

  @override
  onItemAdded(ShoppingListItem item) {
    if (_inMemoryShoppingList == null) {
      _inMemoryShoppingList = ShoppingList(currentListId, []);
    }
    _inMemoryShoppingList.items.add(item);
    notifyListeners();
  }

  @override
  removeItem(String id) {
    _inMemoryShoppingList.items?.removeWhere((item) => item.id == id);
    _shoppingListRepository.remove(id);
  }

  @override
  setFlagged(String id, bool flagged) {
    final oldItem = findByID(id);
    final listItemIndex = _inMemoryShoppingList.items.indexOf(oldItem);
    final newItem = ShoppingListItem(
        id: id, listId: oldItem.listId, title: oldItem.title, flagged: flagged);

    _inMemoryShoppingList.items[listItemIndex] = newItem;
    _shoppingListRepository.add(newItem);

    notifyListeners();
  }

  @override
  ShoppingListItem findByID(final String id) => _inMemoryShoppingList.items
      .firstWhere((ShoppingListItem item) => item.id == id);
}
