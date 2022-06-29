import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/locators/locator.dart';
import 'package:flutter_app/utility/utils.dart';
import 'package:flutter_app/view/home_list/home_list.dart';
import 'package:flutter_app/view/login/login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(Utils.dbName);
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.purpleAccent),
        colorScheme: ColorScheme.fromSwatch(
          accentColor:  Colors.purpleAccent[100],
        ),
      ),
      home: LoginPage(),
    );
  }
}


