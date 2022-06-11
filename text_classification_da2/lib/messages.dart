import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'classifier.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  late TextEditingController _controller;
  late Classifier _classifier;
  late List<Widget> _children;
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _classifier = Classifier();
    _children = [];
    _children.add(Container());
  }

  String xuly(String rawtext) {
    //String rawtext = "- Xiiin  chào emmmm";
    String finaltext = "";
    print(rawtext);

    rawtext = rawtext.toLowerCase();

    for (var a in rawtext.split(" ")) {
      print(a);
      String temp = "";
      for (var b in a.split("")) {

        if (temp.endsWith(b) == false && b != '-' &&  b != '?' && b != '!' && b != '#' && b != '%' && b != '&' && b != ' ') {
          temp = temp + b.trim();
        }

      }

      finaltext = finaltext + " " + temp;

    }
    finaltext = finaltext.trim();

    // String preFinalText = "";
    // await for (var a in finaltext.split(" ")) {
    //   if (a == ' ') {
    //     preFinalText = preFinalText + a;
    //   }
    // }

    print(finaltext);
    return finaltext;
  }

  void _myAction(String rawText) async {
    String engText = "";
    String vieText = await xuly(rawText);
    print(vieText);
    await translator.translate(vieText,to: 'en', from: 'vi').then((value) => {
      engText = value.toString().toLowerCase(),
    });
    print("1");
    print(engText);
    final prediction = _classifier.classify(engText);
    setState(() {
      _children.add(Dismissible(
        key: GlobalKey(),
        onDismissed: (direction) {},
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: prediction[1] > prediction[0]
                ? Colors.lightGreen
                : Colors.redAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Input: $rawText",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Xuly: $vieText",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Translate: $engText",
                  style: const TextStyle(fontSize: 16),
                ),
                Text("Output:"),
                Text("   Positive: ${prediction[1]}"),
                Text("   Negative: ${prediction[0]}"),
              ],
            ),
          ),
        ),
      ));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Text classification'),
      ),
      body: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                  itemCount: _children.length,
                  itemBuilder: (_, index) {
                    return _children[index];
                  },
                )),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.orangeAccent)),
              child: Row(children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText: 'Write some text here'),
                    controller: _controller,
                  ),
                ),
                TextButton(
                  child: const Text('Classify'),
                  onPressed: () {
                    _myAction(_controller.text);
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
