import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/add_item/add_item_provider.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/add_item/add_item_provider_impl.dart';
import 'package:shopping_list/shopping_list/manage_shopping_list/shopping_list_item.dart';

import '../items/mock_shopping_list_repository.dart';

void main() {
  test(
      'when text is changed with not empty text then change the state in order to enable adding item',
      () {
    var notified = 0;
    var addItemProvider =
        AddItemProviderImpl(MockShoppingListRepository(), "list-id");
    addItemProvider.addListener(() {
      notified++;
    });

    addItemProvider.onTextChanged("pizza");

    expect(addItemProvider.state, isA<AddItemEnabled>());
    expect(notified, 1);
  });

  test(
      'when text is changed with empty text then change the state in order to disable adding item',
      () {
    var notified = 0;
    var addItemProvider =
        AddItemProviderImpl(MockShoppingListRepository(), "list-id");
    addItemProvider.addListener(() {
      notified++;
    });

    addItemProvider.onTextChanged("  ");

    expect(addItemProvider.state, isA<AddItemDisabled>());
    expect(notified, 1);
  });

  test(
      'when setting some text and pressing the add button then create in the repo that item',
      () {
    var notified = 0;
    var mockShoppingListRepository = MockShoppingListRepository();
    var addItemProvider =
        AddItemProviderImpl(mockShoppingListRepository, "list-id");
    var expectedTitle = "zenzero piccante";
    addItemProvider.addListener(() {
      notified++;
    });

    addItemProvider.onTextChanged(expectedTitle);
    addItemProvider.addButtonPressed();

    verify(mockShoppingListRepository.add(argThat(predicate<ShoppingListItem>(
        (item) =>
            !item.flagged &&
            item.listId == "list-id" &&
            item.title == expectedTitle))));
    expect(
        addItemProvider.state,
        predicate<AddItemSuccess>(
            (state) => state.item.title == expectedTitle));
    expect(notified, 2);
  });

  test('when closing the widget then set the state to closed', () {
    var addItemProvider =
        AddItemProviderImpl(MockShoppingListRepository(), "list-id");

    addItemProvider.setCloseState();

    expect(addItemProvider.state, isA<Closed>());
  });
}
