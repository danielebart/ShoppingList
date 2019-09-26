import 'package:flutter/cupertino.dart';

import '../shopping_list_item.dart';

class ShoppingItemDB {
  final String itemId;
  final String shoppingListId;
  final bool flagged;
  final String title;

  ShoppingItemDB({@required this.itemId,
    @required this.shoppingListId,
    @required this.flagged,
    @required this.title});

  Map<String, dynamic> toMap() => <String, dynamic>{
    "item_id": itemId,
    "shopping_list_id": shoppingListId,
    "flagged": flagged ? 1 : 0,
    "title": title,
  };

  ShoppingListItem toUIModel() => ShoppingListItem(
      id: itemId, listId: shoppingListId, flagged: flagged, title: title);

  factory ShoppingItemDB.fromMap(Map<String, dynamic> map) => ShoppingItemDB(
    itemId: map["item_id"],
    shoppingListId: map["shopping_list_id"],
    flagged: map["flagged"] == 0 ? false : true,
    title: map["title"],
  );
}
