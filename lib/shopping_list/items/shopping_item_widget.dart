import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/shopping_list/items/shopping_list_notifier.dart';

class ShoppingItemWidget extends StatelessWidget {
  final String itemID;

  ShoppingItemWidget(this.itemID);

  @override
  Widget build(BuildContext context) {
    final shoppingList =
    Provider.of<ShoppingListNotifier>(context, listen: false);
    return _buildCheckbox(shoppingList);
  }

  Widget _buildCheckbox(ShoppingListNotifier shoppingList) {
    final listItem = shoppingList.findByID(itemID);
    return CheckboxListTile(
      title: listItem.flagged
          ? Text(listItem.title,
              style: TextStyle(decoration: TextDecoration.lineThrough))
          : Text(listItem.title),
      controlAffinity: ListTileControlAffinity.leading,
      value: listItem.flagged,
      onChanged: (bool value) {
        shoppingList.setFlagged(itemID, value);
      },
    );
  }
}
