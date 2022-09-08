import 'package:flutter/material.dart';
import 'package:inote/Adapters/todo_adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inote/View/splash_Screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');
  await Hive.openBox<Cats>('cats');

  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inote',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
          primaryColor: Colors.amber,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.amber,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.amber)),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: SplashScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
