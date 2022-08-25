import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewNote extends StatefulWidget {
  ViewNote({required this.title, required this.desc, Key? key})
      : super(key: key);

  String? title;
  String? desc;

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(elevation: 0),
        body: Center(
            child: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 9),
              child: Text(
                widget.title.toString(),
                textDirection: TextDirection.rtl,
                style:
                    const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 1, 15, 9),
              child: Text(
                widget.desc.toString(),
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                    fontSize: 19, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
