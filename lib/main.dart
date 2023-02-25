import 'package:blood_connection/components/components.dart';
import 'package:flutter/material.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Connection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Palette.background,
      ),
      home: const HomeScreen(),
    );
  }
}
