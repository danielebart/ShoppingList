import 'package:injector/injector.dart';
import 'package:shopping_list/shopping_list/add_item/add_item_provider.dart';
import 'package:shopping_list/shopping_list/add_item/add_item_provider_impl.dart';
import 'package:shopping_list/shopping_list/db/shopping_list_db_repository.dart';
import 'package:shopping_list/shopping_list/items/shopping_list_provider.dart';
import 'package:shopping_list/shopping_list/items/shopping_list_provider_impl.dart';

// TODO refactor this component
registerCommonDependencies() {
  Injector injector = Injector.appInstance;

  injector.registerDependency<ShoppingListProvider>((injector) {
    return ShoppingListProviderImpl(ShoppingListDBRepository());
  });

  injector.registerDependency<AddItemProvider>((injector) {
    var currentListId = injector.getDependency<String>(
        dependencyName: "current_shopping_list_id");
    return AddItemProviderImpl(ShoppingListDBRepository(), currentListId);
  });

  injector.registerDependency<String>((injector) {
    var listNotifier = injector.getDependency<ShoppingListProvider>();
    return listNotifier.currentListId;
  }, override: true, dependencyName: "current_shopping_list_id");
}
