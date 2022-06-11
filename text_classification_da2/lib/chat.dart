

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String name;
  const Chat({Key? key, required this.name}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(this.widget.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('CHAT').orderBy("time", descending: false).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messages(size, map, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                            hintText: "Nhập tin nhắn",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send), onPressed: onSendMessage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return Column(
      children: [
        Container(
          width: size.width,
          alignment: map['sendby'] == _auth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: map['sendby'] == _auth.currentUser!.uid ? Colors.orangeAccent : Colors.grey.withOpacity(0.1),
            ),
            child: Text(
              map['message'],
              style: TextStyle(
                //fontSize: 16,
                //fontWeight: FontWeight.w500,
                color: map['sendby'] == _auth.currentUser!.uid ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),

      ],
    );
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.uid,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };
      _message.clear();
      await _firestore.collection('CHAT').add(messages);
    }
    else {
      print("Enter Some Text");
    }
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
}
