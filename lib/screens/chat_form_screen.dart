import 'package:flutter/material.dart';
import 'package:formularioia/widgets/chat_widget.dart';
import 'package:formularioia/widgets/form_widget.dart';

class ChatFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat & Form')),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ChatWidget(),
          ),
          VerticalDivider(width: 1),
          Expanded(
            flex: 1,
            child: FormWidget(),
          ),
        ],
      ),
    );
  }
}
