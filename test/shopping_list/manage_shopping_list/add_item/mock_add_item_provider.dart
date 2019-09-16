import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/add_item/add_item_provider.dart';

class MockAddItemProvider extends Mock
    with ChangeNotifier
    implements AddItemProvider {}
