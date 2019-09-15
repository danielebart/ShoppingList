import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/shopping_list/home_scaffold.dart';

import 'shopping_list/common_injector.dart';
import 'shopping_list/manage_shopping_list/items/shopping_list_provider.dart';

void main() {
  registerCommonDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) =>
          Injector.appInstance.getDependency<ShoppingListProvider>(),
      child: MaterialApp(
          title: 'ShoppingList',
          theme: ThemeData(
              primarySwatch: Colors.pink,
              scaffoldBackgroundColor: Colors.grey[50]),
          home: HomeScaffold()),
    );
  }
}
