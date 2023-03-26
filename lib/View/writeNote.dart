import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../Adapters/todo_adapters.dart';

// ignore: must_be_immutable
class WriteNote extends StatefulWidget {
  WriteNote({Key? key, this.todo}) : super(key: key);

  final formkey = GlobalKey<FormState>();

  Todo? todo;

  @override
  State<WriteNote> createState() => _WriteNoteState();
}

class _WriteNoteState extends State<WriteNote> {
  late String title, description;

  // submitDate() async {
  //   if (widget.formkey.currentState!.validate()) {
  //     Box<Todo> todobox = Hive.box<Todo>("todos");
  //     todobox.add(Todo(title: title, description: description));
  //     Navigator.pop(context);
  //   }
  // }

  late FocusNode titlefocus;
  late FocusNode descriptionfocus;

  @override
  void initState() {
    super.initState();

    titlefocus = FocusNode();
    descriptionfocus = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    descriptionfocus.dispose();
    titlefocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(
        text: widget.todo == null ? null : widget.todo!.title);
    TextEditingController descController = TextEditingController(
        text: widget.todo == null ? null : widget.todo!.description);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.todo == null ? "افزودن یادداشت" : "ویرایش یادداشت"),
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
                          focusNode: titlefocus,
                          autofocus: true,
                          textDirection: TextDirection.rtl,
                          controller: titleController,
                          onFieldSubmitted: (value) {
                            titlefocus.unfocus();
                            FocusScope.of(context)
                                .requestFocus(descriptionfocus);
                          },
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
                          focusNode: descriptionfocus,
                          textDirection: TextDirection.rtl,
                          controller: descController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "dsdd";
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
        onPressed: () async {
          if (widget.formkey.currentState!.validate()) {
            var newNote = Todo(
                title: titleController.text, description: descController.text);

            Box<Todo> submitDate = Hive.box("todos");

            if (widget.todo != null) {
              widget.todo!.title = newNote.title;
              widget.todo!.description = newNote.description;
              Navigator.pop(context);
            } else {
              await submitDate
                  .add(newNote)
                  .then((value) => Navigator.pop(context));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("لطفا یادداشت خود را بنویسید")));
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
