import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/shopping_list_notifier.dart';

class AddItemWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddItemWidgetState();
  }
}

class AddItemWidgetState extends State<AddItemWidget> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            maxLines: null,
            controller: textController,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
                border: InputBorder.none,
                hintText: 'Biscotti allo zenzero...'),
          ),
          IconButton(
            padding: EdgeInsets.all(16),
            iconSize: 40,
            onPressed: () {
              var provider =
              Provider.of<ShoppingListNotifier>(context, listen: false);
              provider.addItem(textController.text);
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.add_box,
              color: Colors.purple,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
