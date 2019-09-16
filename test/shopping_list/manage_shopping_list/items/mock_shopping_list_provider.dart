import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/items/shopping_list_provider.dart';

class MockShoppingListProvider extends Mock
    with ChangeNotifier
    implements ShoppingListProvider {}
