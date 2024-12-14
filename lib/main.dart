import 'package:flutter/material.dart';
import 'package:formularioia/screens/chat_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:formularioia/providers/form_state_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormStateProvider()),
      ],
      child: MaterialApp(
        title: 'Chat & Form App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ChatFormScreen(),
      ),
    );
  }
}
