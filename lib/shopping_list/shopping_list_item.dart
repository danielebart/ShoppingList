import 'package:quiver/core.dart';

class ShoppingListItem {
  final String listId;
  final String id;
  final bool flagged;
  final String title;

  ShoppingListItem({this.id, this.listId, this.flagged, this.title});

  @override
  bool operator ==(o) =>
      o is ShoppingListItem && flagged == o.flagged && title == o.title;

  @override
  int get hashCode => hash2(flagged.hashCode, title.hashCode);
}
