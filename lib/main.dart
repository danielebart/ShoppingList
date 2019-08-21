import 'package:flutter/material.dart';
import 'package:shopping_list/add_shopping_item.dart';
import 'package:shopping_list/shopping_list_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShoppingList',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'ShoppingList'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShoppingList'),
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
