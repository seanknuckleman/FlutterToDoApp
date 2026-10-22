import 'package:flutter/material.dart';
// import 'package:todoapp/mogodb/mongodb.dart';
import 'package:todoapp/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        primaryColor: Colors.limeAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.yellow,
        ),
      ),
    );
  }
}
