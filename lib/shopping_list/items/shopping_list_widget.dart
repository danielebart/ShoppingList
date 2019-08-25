import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/shopping_list/items/shopping_item_widget.dart';
import 'package:shopping_list/shopping_list/items/shopping_list_notifier.dart';

import '../shopping_list.dart';

class ShoppingListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListNotifier>(builder: (context, shoppingList, _) {
      return StreamBuilder<ShoppingList>(
          stream: shoppingList.list,
          builder: (context, AsyncSnapshot<ShoppingList> snapshot) {
            return ListView.builder(
                itemCount: snapshot.data?.items?.length ?? 0,
                itemBuilder: (context, position) {
                  var id = snapshot.data.items[position].id;
                  return Dismissible(
                      key: Key(id),
                      onDismissed: (direction) => shoppingList.removeItem(id),
                      child: ShoppingItemWidget(id));
                });
          });
    });
  }
}
