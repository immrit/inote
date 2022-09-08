import 'package:hive/hive.dart';

part 'todo_adapters.g.dart';

@HiveType(typeId: 1)
class Todo {
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String description;

  Todo({required this.title, required this.description});
}

@HiveType(typeId: 2)
class Cats {
  @HiveField(0)
  late String title;

  Cats({required this.title});
}
