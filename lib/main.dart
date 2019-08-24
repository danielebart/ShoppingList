import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/add_shopping_item.dart';
import 'package:shopping_list/shopping_list_notifier.dart';
import 'package:shopping_list/shopping_list_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ShoppingListNotifier(),
      child: MaterialApp(
          title: 'ShoppingList',
          theme: ThemeData(
              primarySwatch: Colors.purple,
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
        title: Text('ShoppingList', style: TextStyle(color: Colors.purple)),
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
        child: Icon(Icons.add),
      ),
    );
  }
}
