import 'package:flutter/material.dart';
import 'package:inote/Adapters/todo_adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inote/View/cats_page.dart';
import 'package:inote/View/update_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:inote/View/writeNote.dart';
import 'package:url_launcher/url_launcher.dart';

class InoteView extends StatefulWidget {
  InoteView({Key? key}) : super(key: key);

  final formkey = GlobalKey<FormState>();

  @override
  // ignore: library_private_types_in_public_api
  _InoteViewState createState() => _InoteViewState();
}

class _InoteViewState extends State<InoteView> {
  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;

//Menu Item
    void handleClick(int item) {
      switch (item) {
        case 0:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CatsPage()));
          break;
        case 1:
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Inote"),
        // backgroundColor: Colors.amber,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                  padding: EdgeInsets.only(left: 50),
                  value: 1,
                  child: Text('Github آی نوت در'),
                  onTap: () async {
                    var url = "https://github.com/immrit/inote";

                    final Uri _url = Uri.parse(url);

                    await launchUrl(_url, mode: LaunchMode.externalApplication);
                  }),
              PopupMenuItem<int>(
                  padding: EdgeInsets.only(left: 80),
                  value: 2,
                  onTap: () async {
                    var url =
                        "https://myket.ir/app/com.example.inote?utm_source=search-ads-gift&utm_medium=cpc";

                    final Uri _url = Uri.parse(url);

                    await launchUrl(_url, mode: LaunchMode.externalApplication);
                  },
                  child: Text('ارسال بازخورد')),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
            valueListenable: Hive.box<Todo>('todos').listenable(),
            builder: (context, Box<Todo> box, _) {
              if (box.values.isEmpty) {
                return Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AdMyket(50),
                    Container(
                      height: he / 1.5,
                      alignment: Alignment.center,
                      // color: Colors.orange,
                      child: const Text(
                        "☹️ یادداشتی موجود نیست",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  AdMyket(50),
                  SizedBox(
                    height: kIsWeb ? he / 1.3 : he / 1.2,
                    // color: Colors.blue,
                    child: ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          Todo? todo = box.getAt(index);

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Card(
                              child: ListTile(
                                onLongPress: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 123,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight:
                                                      Radius.circular(30))),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                onTap: (() async {
                                                  await box
                                                      .deleteAt(index)
                                                      .then((value) =>
                                                          Navigator.pop(
                                                              context));
                                                }),
                                                trailing:
                                                    const Icon(Icons.delete),
                                                title: const Text(
                                                  "حذف",
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                              ListTile(
                                                onTap: (() => Navigator.of(
                                                        context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) => UpdateScreen(
                                                            index: index,
                                                            todo: todo,
                                                            titleController:
                                                                todo!.title
                                                                    .toString(),
                                                            descriptionController:
                                                                todo.description
                                                                    .toString())))
                                                    .then((value) =>
                                                        Navigator.pop(
                                                            context))),
                                                trailing:
                                                    const Icon(Icons.edit),
                                                title: const Text(
                                                  "ویرایش",
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UpdateScreen(
                                          index: index,
                                          todo: todo,
                                          titleController:
                                              todo!.title.toString(),
                                          descriptionController:
                                              todo.description.toString())));
                                },
                                title: Text(todo!.title,
                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    textDirection: TextDirection.rtl,
                                    overflow: TextOverflow.ellipsis),
                                subtitle: Text(todo.description,
                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    textDirection: TextDirection.rtl,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.create),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => WriteNote())),
      ),
    );
  }

  Widget drawerItem(String txt, Widget icon, String urlAdd) {
    return InkWell(
      onTap: () async {
        var url = urlAdd;
        // ignore: no_leading_underscores_for_local_identifiers
        final Uri _url = Uri.parse(url);

        await launchUrl(_url, mode: LaunchMode.externalApplication);
      },
      child: ListTile(
        title: Text(
          txt,
          textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: icon,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget AdMyket(he) {
    return kIsWeb
        ? Container(
            height: he,
            width: double.maxFinite,
            color: Colors.white10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => launchURL(),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: SizedBox(
                      height: 50,
                      width: 150,
                      child: Image.asset("lib/assets/images/getmyket.png"),
                    ),
                  ),
                ),
                const Text(
                  "دانلود نسخه اندروید از مایکت",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  launchURL() async {
    var url =
        'https://myket.ir/app/com.example.inote?utm_source=search-ads-gift&utm_medium=cpc';
    final Uri _url = Uri.parse(url);

    await launchUrl(_url, mode: LaunchMode.externalApplication);
  }
}
