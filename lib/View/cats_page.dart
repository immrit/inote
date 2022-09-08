import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inote/Adapters/todo_adapters.dart';

class CatsPage extends StatefulWidget {
  CatsPage({Key? key}) : super(key: key);

  final formkey = GlobalKey<FormState>();

  Cats? cats;

  @override
  State<CatsPage> createState() => _CatsPageState();
}

class _CatsPageState extends State<CatsPage> {
  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;

    TextEditingController titleController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('CatsPage'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Cats>('cats').listenable(),
        builder: (BuildContext context, Box<Cats> boxCats, _) {
          if (boxCats.values.isEmpty) {
            return Container(
              height: he / 1.5,
              alignment: Alignment.center,
              // color: Colors.orange,
              child: const Text(
                "☹️ دسته بندی موجود نیست",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.builder(
              itemCount: boxCats.length,
              itemBuilder: (context, index) {
                Cats? cats = boxCats.getAt(index);
                return ListTile(
                  title: Text(cats!.title[index]),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: (context),
              builder: ((context) {
                return Dialog(
                  child: Container(
                    height: 100,
                    child: Column(
                      children: [
                        Form(
                          key: widget.formkey,
                          child: Column(
                            children: [
                              TextField(
                                controller: titleController,
                              ),
                              FloatingActionButton.extended(
                                  onPressed: () async {
                                    var newCats =
                                        Cats(title: titleController.text);

                                    Box<Cats> submitDate = Hive.box("cats");
                                    await submitDate.add(newCats).then(
                                        (value) => Navigator.pop(context));
                                  },
                                  label: Text("label"))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
