import 'package:quiver/core.dart';

class ShoppingListItem {
  final String listId;
  final String id;
  final bool flagged;
  final String title;

  ShoppingListItem({this.id, this.listId, this.flagged, this.title});

  @override
  bool operator ==(o) =>
      o is ShoppingListItem &&
          flagged == o.flagged &&
          title == o.title &&
          id == o.id &&
          listId == o.listId;

  @override
  int get hashCode =>
      hash4(id.hashCode, listId.hashCode, flagged.hashCode, title.hashCode);
}
