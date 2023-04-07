import 'dart:io';

import 'package:blood_connection/components/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  runApp(
    ChangeNotifierProvider<ThemeManager>(
      create: (_) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (context, provider, child) {
      return MaterialApp(
        title: 'Blood Connection',
        scaffoldMessengerKey: snackbarKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light()
            .copyWith(scaffoldBackgroundColor: Palette.background),
        darkTheme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: Palette.darkPrimary),
        themeMode: provider.themeMode,
        home: const HomeScreen(id: null),
      );
    });
  }
}
