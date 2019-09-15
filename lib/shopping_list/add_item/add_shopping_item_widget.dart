import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:injector/injector.dart';
import 'package:provider/provider.dart';

import 'add_item_provider.dart';

class AddItemWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddItemWidgetState();
  }
}

class AddItemWidgetState extends State<AddItemWidget> {
  final textController = TextEditingController();
  final _addNotifier = Injector.appInstance.getDependency<AddItemProvider>();

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      _addNotifier.onTextChanged(textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => _addNotifier,
      child: Container(
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
            IconButtonWidget()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}

class IconButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddItemProvider>(builder: (context, addItemNotifier, _) {
      if (addItemNotifier.state is Closed) {
        return Container();
      } else if (addItemNotifier.state is AddItemSuccess) {
        var state = addItemNotifier.state as AddItemSuccess;
        var shoppingItem = state.item;
        addItemNotifier.setCloseState();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context, shoppingItem);
        });
        return Container();
      }

      return IconButton(
        padding: EdgeInsets.all(16),
        iconSize: 40,
        onPressed: () => _onAddButtonPressed(addItemNotifier),
        icon: Icon(
          Icons.add_circle,
          color: addItemNotifier.state is AddItemEnabled
              ? Colors.pink
              : Colors.grey,
        ),
      );
    });
  }

  void _onAddButtonPressed(var addItemNotifier) {
    if (addItemNotifier.state is AddItemEnabled) {
      addItemNotifier.addButtonPressed();
    }
  }
}
