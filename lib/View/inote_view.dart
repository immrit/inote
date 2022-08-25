import 'package:flutter/material.dart';
import 'package:inote/Adapters/todo_adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inote/View/view_note.dart';
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Inote"),
        // backgroundColor: Colors.amber,
      ),
      endDrawer: Drawer(
        width: 250,
        child: ListView(children: [
          Stack(
            children: [
              Image.asset(
                'lib/assets/images/drawerposter.jpg',
              ),
              Positioned(
                top: 8,
                left: 50,
                right: 10,
                bottom: 10,
                child: Container(
                  height: 110,
                  width: 170,
                  alignment: Alignment.bottomRight,
                  // color: Colors.amber,
                  child: const Text(
                    " (: اوقات بخیر",
                    style: TextStyle(
                        backgroundColor: Colors.white70,
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          drawerItem(
              "Github آی نوت در",
              SizedBox(
                  height: 30,
                  child: Image.asset("lib/assets/images/github.png")),
              "https://github.com/immrit/inote"),
          drawerItem(
              "ارسال بازخورد",
              SizedBox(
                  height: 30,
                  child: Image.asset("lib/assets/images/myket.png")),
              "https://myket.ir/app/com.example.inote?utm_source=search-ads-gift&utm_medium=cpc"),
          // drawerItem("امتیاز به برنامه", Icons.star,
          //     "https://myket.ir/app/com.example.inote?utm_source=search-ads-gift&utm_medium=cpc")
        ]),
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

                          return ListTile(
                            onLongPress: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 123,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30))),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            onTap: (() async {
                                              await box.deleteAt(index).then(
                                                  (value) =>
                                                      Navigator.pop(context));
                                            }),
                                            trailing: const Icon(Icons.delete),
                                            title: const Text(
                                              "حذف",
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          ListTile(
                                            onTap: (() => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        WriteNote(
                                                          todo: todo,
                                                        )))
                                                .then((value) =>
                                                    Navigator.pop(context))),
                                            trailing: const Icon(Icons.edit),
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
                                  builder: (context) => ViewNote(
                                      title: todo!.title,
                                      desc: todo.description)));
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
                  onTap: () => _launchURL(),
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

  _launchURL() async {
    var url =
        'https://myket.ir/app/com.example.inote?utm_source=search-ads-gift&utm_medium=cpc';
    // ignore: no_leading_underscores_for_local_identifiers
    final Uri _url = Uri.parse(url);

    await launchUrl(_url, mode: LaunchMode.externalApplication);
  }
}
