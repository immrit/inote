import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inote/Adapters/todo_adapters.dart';
import 'package:inote/View/inote_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: inoteView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
