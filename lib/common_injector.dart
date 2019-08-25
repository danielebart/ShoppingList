import 'package:injector/injector.dart';
import 'package:shopping_list/db/shopping_list_db_repository.dart';
import 'package:shopping_list/shopping_list_notifier.dart';

registerCommonDependencies() {
  Injector injector = Injector.appInstance;

  injector.registerDependency<ShoppingListNotifier>((injector) {
    return ShoppingListNotifier(ShoppingListDBRepository());
  });
}
