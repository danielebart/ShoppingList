import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';
import 'package:shopping_list/shopping_list/shopping_list_item.dart';

class ShoppingList {
  final String id;
  final List<ShoppingListItem> items;

  ShoppingList(this.id, this.items);

  @override
  bool operator ==(o) =>
      o is ShoppingList && id == o.id && listEquals(items, o.items);

  @override
  int get hashCode => hash2(id.hashCode, items.hashCode);
}
