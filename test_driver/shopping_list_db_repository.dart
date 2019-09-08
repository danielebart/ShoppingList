import 'dart:io';

import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/shopping_list/db/shopping_list_db_repository.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';
import 'package:shopping_list/shopping_list/shopping_list_item.dart';

// TODO this must be refactored and find a cleaner way to write those kind of tests
void main() {
  enableFlutterDriverExtension();

  var repository = ShoppingListDBRepository();

  tearDown(() {
    repository.removeAll();
  });

  tearDownAll(() {
    Future.delayed(const Duration(milliseconds: 50), () => exit(0));
  });

  test('given an empty db when adding an item then return that item', () async {
    var item = ShoppingListItem(
        id: "fake-id",
        listId: "fake-list-id",
        flagged: true,
        title: "fake-title");

    repository.add(item);
    var list = await repository.getShoppingList("fake-list-id");

    expect(list.items, [item]);
  });

  test('given an empty db when adding multiple items then return that items',
      () async {
    var items = [
      ShoppingListItem(
          id: "fake-id",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id2",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id3",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
    ];

    items.forEach((item) => repository.add(item));
    var list = await repository.getShoppingList("fake-list-id");

    expect(list.items, items);
  });

  test('given an empty db when removing an item then return an empty list',
      () async {
    var itemId = "fake-id";
    var item = ShoppingListItem(
        id: itemId, listId: "fake-list-id", flagged: true, title: "fake-title");

    repository.add(item);
    repository.remove(itemId);
    var list = await repository.getShoppingList("fake-list-id");

    expect(list.items, []);
  });

  test(
      'given a populated db when removing an item then return the previous items'
      'without the removed one', () async {
    var items = [
      ShoppingListItem(
          id: "fake-id",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id2",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id3",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
    ];
    items.forEach((item) => repository.add(item));

    repository.remove("fake-id2");
    var list = await repository.getShoppingList("fake-list-id");

    expect(list.items, items.toList()..removeAt(1));
  });

  test('given a populated db when removing all items then return an empy list',
      () async {
    var items = [
      ShoppingListItem(
          id: "fake-id",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id2",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id3",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
    ];
    items.forEach((item) => repository.add(item));

    repository.removeAll();
    var list = await repository.getShoppingList("fake-list-id");

    expect(list.items, []);
  });

  test(
      'given a populated db when adding an already existing item then replace it',
      () async {
    repository.add(ShoppingListItem(
        id: "fake-id",
        listId: "fake-list-id",
        flagged: true,
        title: "fake-title"));

    var list = await repository.getShoppingList("fake-list-id");

    expect(list.items, [
      ShoppingListItem(
          id: "fake-id",
          listId: "fake-list-id",
          flagged: false,
          title: "fake-title")
    ]);
  });

  test(
      'given a populated db with different list ids, when getting all items '
      'from a specific list id, then return the items belonging to that list id',
      () async {
    var items = [
      ShoppingListItem(
          id: "fake-id",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id2",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id3",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id4",
          listId: "fake-list-id2",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id5",
          listId: "fake-list-id2",
          flagged: true,
          title: "fake-title"),
    ];
    items.forEach((item) => repository.add(item));

    var list = await repository.getShoppingList("fake-list-id");

    expect(list.items, [
      ShoppingListItem(
          id: "fake-id",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id2",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id3",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
    ]);
  });

  test(
      'given a populated db with different list ids, when getting the shopping lists '
      'then return all the original shopping lists in the db', () async {
    var expectedList = [
      ShoppingList("fake-list-id", [
        ShoppingListItem(
            id: "fake-id",
            listId: "fake-list-id",
            flagged: true,
            title: "fake-title"),
        ShoppingListItem(
            id: "fake-id2",
            listId: "fake-list-id",
            flagged: true,
            title: "fake-title")
      ]),
      ShoppingList("fake-list-id2", [
        ShoppingListItem(
            id: "fake-id3",
            listId: "fake-list-id2",
            flagged: true,
            title: "fake-title"),
        ShoppingListItem(
            id: "fake-id4",
            listId: "fake-list-id2",
            flagged: true,
            title: "fake-title")
      ])
    ];
    var items = [
      ShoppingListItem(
          id: "fake-id",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id2",
          listId: "fake-list-id",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id3",
          listId: "fake-list-id2",
          flagged: true,
          title: "fake-title"),
      ShoppingListItem(
          id: "fake-id4",
          listId: "fake-list-id2",
          flagged: true,
          title: "fake-title"),
    ];
    items.forEach((item) => repository.add(item));

    expect(await repository.getShoppingLists(), expectedList);
  });
}
