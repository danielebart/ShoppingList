import 'package:flutter/cupertino.dart';

import '../shopping_list_item.dart';

abstract class AddItemProvider with ChangeNotifier {
  AddItemState get state;

  addButtonPressed();

  onTextChanged(String text);

  setCloseState();
}

abstract class AddItemState {}

class Closed extends AddItemState {}

class AddItemDisabled extends AddItemState {}

class AddItemEnabled extends AddItemState {}

class AddItemSuccess extends AddItemState {
  final ShoppingListItem item;

  AddItemSuccess(this.item);
}
