import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inote/Adapters/todo_adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';

class inoteView extends StatefulWidget {
  inoteView({Key? key}) : super(key: key);

  final formkey = GlobalKey<FormState>();

  @override
  _inoteViewState createState() => _inoteViewState();
}

class _inoteViewState extends State<inoteView> {
  late String title, description;

  submitDate() async {
    if (widget.formkey.currentState!.validate()) {
      Box<Todo> todobox = Hive.box("todos");
      todobox.add(Todo(title: title, description: description));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Inote"),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Todo>('todos').listenable(),
          builder: (context, Box<Todo> box, _) {
            if (box.values.isEmpty) {
              return Center(
                child: Text(
                  "☹️ داده ای موجود نیست",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  Todo? todo = box.getAt(index);
                  return ListTile(
                    onLongPress: () async {
                      await box.deleteAt(index);
                    },
                    title: Text(
                      todo!.title,
                    ),
                    subtitle: Text(todo.description),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext c) {
                return Dialog(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 200,
                          child: Form(
                              key: widget.formkey,
                              child: ListView(
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Title",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                    onChanged: (value) {
                                      setState(() {
                                        title = value;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: "Des",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      onChanged: (value) {
                                        setState(() {
                                          description = value;
                                        });
                                      },
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        submitDate();
                                      },
                                      child: Text("Save"))
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
