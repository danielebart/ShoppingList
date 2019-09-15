import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../shopping_list_item.dart';
import '../shopping_list_repository.dart';
import 'add_item_provider.dart';

class AddItemProviderImpl with ChangeNotifier implements AddItemProvider {
  final ShoppingListRepository _shoppingListRepository;
  final String _currentListID;
  AddItemState _state = AddItemDisabled();
  String _currentText = "";

  AddItemProviderImpl(this._shoppingListRepository, this._currentListID);

  @override
  AddItemState get state => _state;

  @override
  addButtonPressed() {
    assert(_currentText.isNotEmpty);

    var uuid = new Uuid();
    var item = ShoppingListItem(
        id: uuid.v4(),
        listId: _currentListID,
        title: _currentText,
        flagged: false);
    _shoppingListRepository.add(item);
    _state = AddItemSuccess(item);
    notifyListeners();
  }

  @override
  onTextChanged(String text) {
    _currentText = text;
    var previousState = _state;
    _state = text.trim().isEmpty ? AddItemDisabled() : AddItemEnabled();
    if (previousState != _state) notifyListeners();
  }

  @override
  setCloseState() {
    _state = Closed();
  }
}