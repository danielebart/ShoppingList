import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/items/shopping_item_widget.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/items/shopping_list_provider.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/items/shopping_list_widget.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/shopping_list.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/shopping_list_item.dart';

import 'widget_utils.dart';

void main() {
  testWidgets(
      'given populated list of item when adding multiple ites then they are displayed in the list',
      (WidgetTester tester) async {
    var fakeItem1 = ShoppingListItem(
        id: "zenzero", listId: "", flagged: true, title: "zenzero");
    var fakeItem2 = ShoppingListItem(
        id: "pizza", listId: "", flagged: false, title: "pizza");
    var streamController = StreamController<ShoppingList>(sync: false);
    var fakeShoppingList = ShoppingList("", [
      ShoppingListItem(
          id: "zenzero", listId: "", flagged: true, title: "zenzero"),
      ShoppingListItem(id: "pizza", listId: "", flagged: false, title: "pizza")
    ]);
    var shoppingListProviderMock = _MockShoppingListProvider();
    when(shoppingListProviderMock.findByID("zenzero")).thenReturn(fakeItem1);
    when(shoppingListProviderMock.findByID("pizza")).thenReturn(fakeItem2);
    when(shoppingListProviderMock.list)
        .thenAnswer((_) => streamController.stream);

    await tester.pumpWidget(MaterialTestProvider<ShoppingListProvider>(
      child: ShoppingListWidget(),
      provider: shoppingListProviderMock,
    ));
    streamController.add(fakeShoppingList);
    await tester.pump(Duration.zero);

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is CheckboxListTile &&
            (widget.title as Text).data == "zenzero" &&
            widget.value),
        findsOneWidget);
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is CheckboxListTile &&
            (widget.title as Text).data == "pizza" &&
            !widget.value),
        findsOneWidget);
    await streamController.close();
  });

  testWidgets(
      'given a populated list of item when removing an item then remove it from the list',
      (WidgetTester tester) async {
    var fakeItemId = "fake-id";
    var fakeItem = ShoppingListItem(
        id: fakeItemId, listId: "", flagged: true, title: "zenzero");
    var streamController = StreamController<ShoppingList>(sync: false);
    var fakeShoppingList = ShoppingList("", [
      ShoppingListItem(
          id: fakeItemId, listId: "", flagged: true, title: "zenzero")
    ]);
    var shoppingListProviderMock = _MockShoppingListProvider();
    when(shoppingListProviderMock.findByID(fakeItemId)).thenReturn(fakeItem);
    when(shoppingListProviderMock.list)
        .thenAnswer((_) => streamController.stream);

    await tester.pumpWidget(MaterialTestProvider<ShoppingListProvider>(
      child: ShoppingListWidget(),
      provider: shoppingListProviderMock,
    ));

    streamController.add(fakeShoppingList);
    await tester.pump(Duration.zero);
    await tester.drag(find.text("zenzero"), Offset(500.0, 0.0));
    await tester.pumpAndSettle();

    verify(shoppingListProviderMock.removeItem(fakeItemId));
    await streamController.close();
  });

  testWidgets(
      'given a populated list of item when flagging an item then call provider flag method',
      (WidgetTester tester) async {
    var fakeItemId = "fake-id";
    var fakeItem = ShoppingListItem(
        id: fakeItemId, listId: "", flagged: true, title: "zenzero");
    var streamController = StreamController<ShoppingList>(sync: false);
    var fakeShoppingList = ShoppingList("", [
      ShoppingListItem(
          id: fakeItemId, listId: "", flagged: true, title: "zenzero")
    ]);
    var shoppingListProviderMock = _MockShoppingListProvider();
    when(shoppingListProviderMock.findByID(fakeItemId)).thenReturn(fakeItem);
    when(shoppingListProviderMock.list)
        .thenAnswer((_) => streamController.stream);

    await tester.pumpWidget(MaterialTestProvider<ShoppingListProvider>(
      child: ShoppingListWidget(),
      provider: shoppingListProviderMock,
    ));
    streamController.add(fakeShoppingList);
    await tester.pump(Duration.zero);
    await tester.tap(find.byType(ShoppingItemWidget));
    await tester.pump();

    verify(shoppingListProviderMock.setFlagged(fakeItemId, false));
    await streamController.close();
  });
}

class _MockShoppingListProvider extends Mock
    with ChangeNotifier
    implements ShoppingListProvider {}
