// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inote/Adapters/todo_adapters.dart';

class UpdateScreen extends StatefulWidget {
  final int index;
  final Todo? todo;
  final titleController;
  final descriptionController;

  UpdateScreen(
      {Key? key,
      required this.index,
      this.todo,
      this.titleController,
      this.descriptionController})
      : super(key: key);
  final formkey = GlobalKey<FormState>();

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late final Box dataBox;
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  _updateData() {
    Todo newData = Todo(
      title: titleController.text,
      description: descriptionController.text,
    );
    dataBox.putAt(widget.index, newData);
  }

  @override
  void initState() {
    super.initState();

    dataBox = Hive.box<Todo>('todos');
    titleController = TextEditingController(text: widget.titleController);
    descriptionController =
        TextEditingController(text: widget.descriptionController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('ویرایش یادداشت'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 400,
              child: Form(
                  key: widget.formkey,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 9),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration.collapsed(
                              hintText: "موضوع",
                              // filled: true,
                              hintStyle: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          autofocus: true,
                          textDirection: TextDirection.rtl,
                          controller: titleController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 1, 15, 9),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w300),
                          maxLines: 30,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration.collapsed(
                              hintText: "...یادداشت کنید",
                              hintStyle: TextStyle(fontSize: 23)),
                          textDirection: TextDirection.rtl,
                          controller: descriptionController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "خالی";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _updateData();
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
