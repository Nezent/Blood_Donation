import 'dart:io';

import 'package:blood_connection/components/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shared_preferences/shared_preferences.dart';

mongo.ObjectId? id;
bool viewed = false;

Future<void> main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  WidgetsFlutterBinding.ensureInitialized();
  ByteData data =
      await PlatformAssetBundle().load('assets/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  await MongoDB.connect();
  SharedPreferences session = await SharedPreferences.getInstance();
  String? value = session.getString('objectId');
  viewed = session.getBool('viewed') ?? false;
  if (value != null) {
    id = mongo.ObjectId.fromHexString(value);
  } else {
    id = null;
  }
  runApp(
    ChangeNotifierProvider<ThemeManager>(
      create: (_) => ThemeManager()..initializeTheme(),
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
        home: viewed ? HomeScreen(id: id) : const Onboarding(),
      );
    });
  }
}
