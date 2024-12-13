import 'package:flutter/material.dart';
import 'package:my_chat_form_app/widgets/chat_widget.dart';
import 'package:my_chat_form_app/widgets/form_widget.dart';

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
