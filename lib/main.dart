import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/shopping_list/add_item/add_shopping_item_widget.dart';
import 'package:shopping_list/shopping_list/items/shopping_list_notifier.dart';
import 'package:shopping_list/shopping_list/items/shopping_list_widget.dart';

import 'common_injector.dart';

void main() {
  registerCommonDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) =>
          Injector.appInstance.getDependency<ShoppingListNotifier>(),
      child: MaterialApp(
          title: 'ShoppingList',
          theme: ThemeData(
              primarySwatch: Colors.pink,
              scaffoldBackgroundColor: Colors.grey[50]),
          home: HomeScaffold()),
    );
  }
}

class HomeScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShoppingList', style: TextStyle(color: Colors.pink)),
        elevation: 0.0,
        backgroundColor: Colors.grey[50],
      ),
      body: Center(
        child: ShoppingListWidget(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text('lista corrente')),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive), title: Text('Archivio'))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => AddItemWidget())),
        tooltip: 'Increment',
        child: Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
