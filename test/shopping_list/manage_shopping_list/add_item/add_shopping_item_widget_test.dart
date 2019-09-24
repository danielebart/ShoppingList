import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injector/injector.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_list/main.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/add_item/add_item_provider.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/add_item/add_shopping_item_widget.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/items/shopping_list_provider.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/shopping_list_item.dart';

import '../items/mock_shopping_list_provider.dart';
import 'mock_add_item_provider.dart';

void main() {
  testWidgets('when pressing the add item button then show the add item widget',
          (WidgetTester tester) async {
        Injector injector = Injector.appInstance;
        var addItemProviderMock = MockAddItemProvider();
        injector.registerDependency<ShoppingListProvider>((injector) {
          return MockShoppingListProvider();
        });
        injector.registerDependency<AddItemProvider>((injector) {
          return addItemProviderMock;
        });
        await tester.pumpWidget(MyApp());
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.add_shopping_cart));
        await tester.pumpAndSettle();

        expect(find.byType(AddItemWidget), findsOneWidget);
        injector.clearAll();
      });

  testWidgets(
      'given AddItemDisabled state when opening the add sheet then '
          'the add button is disabled', (WidgetTester tester) async {
    Injector injector = Injector.appInstance;
    var addItemProviderMock = MockAddItemProvider();
    injector.registerDependency<ShoppingListProvider>((injector) {
      return MockShoppingListProvider();
    });
    injector.registerDependency<AddItemProvider>((injector) {
      return addItemProviderMock;
    });
    when(addItemProviderMock.state).thenReturn(AddItemDisabled());

    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add_shopping_cart));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate(
                (Widget widget) =>
            widget is Icon && widget.color == Colors.grey),
        findsOneWidget);
    injector.clearAll();
  });

  testWidgets(
      'given AddItemDisabled state when opening the add sheet then the add '
          'button is disabled', (WidgetTester tester) async {
    Injector injector = Injector.appInstance;
    var addItemProviderMock = MockAddItemProvider();
    injector.registerDependency<ShoppingListProvider>((injector) {
      return MockShoppingListProvider();
    });
    injector.registerDependency<AddItemProvider>((injector) {
      return addItemProviderMock;
    });
    when(addItemProviderMock.state).thenReturn(AddItemDisabled());

    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add_shopping_cart));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate(
                (Widget widget) =>
            widget is Icon && widget.color == Colors.grey),
        findsOneWidget);
    injector.clearAll();
  });

  testWidgets(
      'given AddItemEnabled state when clicking on add button'
          ' then verify button press call', (WidgetTester tester) async {
    Injector injector = Injector.appInstance;
    var addItemProviderMock = MockAddItemProvider();
    injector.registerDependency<ShoppingListProvider>((injector) {
      return MockShoppingListProvider();
    });
    injector.registerDependency<AddItemProvider>((injector) {
      return addItemProviderMock;
    });
    when(addItemProviderMock.state).thenReturn(AddItemEnabled());

    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add_shopping_cart));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), "whatever");
    await tester.tap(find.byType(IconButton));
    await tester.pump();

    verify(addItemProviderMock.addButtonPressed());
    injector.clearAll();
  });

  testWidgets(
      'given AddItemEnabled state when typing text'
          ' then verify typing text changed call', (WidgetTester tester) async {
    Injector injector = Injector.appInstance;
    var addItemProviderMock = MockAddItemProvider();
    injector.registerDependency<ShoppingListProvider>((injector) {
      return MockShoppingListProvider();
    });
    injector.registerDependency<AddItemProvider>((injector) {
      return addItemProviderMock;
    });
    when(addItemProviderMock.state).thenReturn(AddItemEnabled());

    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add_shopping_cart));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), "whatever");
    await tester.pump();

    verify(addItemProviderMock.onTextChanged("whatever"));
    injector.clearAll();
  });

  testWidgets(
      'given AddItemSuccess state when opening the add sheet then return the '
          'added item to the ShoppingListProvider', (
      WidgetTester tester) async {
    Injector injector = Injector.appInstance;
    var addItemProviderMock = MockAddItemProvider();
    var shoppingListProviderMock = MockShoppingListProvider();
    injector.registerDependency<ShoppingListProvider>((injector) {
      return shoppingListProviderMock;
    });
    injector.registerDependency<AddItemProvider>((injector) {
      return addItemProviderMock;
    });
    var addedItem = ShoppingListItem(
        id: "fake-id",
        listId: "fake-list-id",
        flagged: true,
        title: "fake-title");
    when(addItemProviderMock.state).thenReturn(AddItemSuccess(addedItem));

    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add_shopping_cart));
    await tester.pumpAndSettle();

    expect(find.byType(AddItemWidget), findsNothing);
    verify(shoppingListProviderMock.onItemAdded(addedItem));
    verify(addItemProviderMock.setCloseState());
    injector.clearAll();
  });
}
