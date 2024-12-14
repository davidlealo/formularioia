import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:formularioia/screens/chat_form_screen.dart';
import 'package:formularioia/providers/form_state_provider.dart';

Future<void> main() async {
  // Inicializa Flutter antes de realizar operaciones asincrónicas
  WidgetsFlutterBinding.ensureInitialized();

  // Carga el archivo .env y maneja errores
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error al cargar .env: $e");
  }

  runApp(MyApp()); // Quita const aquí
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
        home: ChatFormScreen(), // Quita const aquí también
      ),
    );
  }
}
