import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddItemWidget extends StatelessWidget {
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
            onPressed: () {},
            icon: Icon(
              Icons.add_box,
              color: Colors.purple,
            ),
          )
        ],
      ),
    );
  }
}
