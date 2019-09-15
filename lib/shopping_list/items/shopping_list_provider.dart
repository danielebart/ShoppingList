import 'package:flutter/widgets.dart';

import '../shopping_list.dart';
import '../shopping_list_item.dart';

abstract class ShoppingListProvider implements ChangeNotifier {
  Stream<ShoppingList> get list;

  onItemAdded(ShoppingListItem item);

  removeItem(String id);

  setFlagged(String id, bool flagged);

  ShoppingListItem findByID(final String id);

  String get currentListId;
}
