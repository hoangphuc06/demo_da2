
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tflite_flutter_plugin_example/login.dart';
import 'package:translator/translator.dart';

import 'classifier.dart';

class End extends StatefulWidget {
  const End({Key? key}) : super(key: key);

  @override
  State<End> createState() => _EndState();
}

class _EndState extends State<End> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String idUser1 = "079db9POW3eHWcWNMsKzJRcaHhq1";
  final String idUser2 = "QVwFYGH4tmb5PwXRkYsGbKvZN5F2";
  late List<String> chatOfUser1, chatOfUser2;
  late List<double> posUser1, posUser2, negUser1, negUser2;
  bool isLoad = true;


  @override
  void initState() {
    super.initState();
    chatOfUser1 = [];
    chatOfUser2 = [];
    posUser1 = [];
    posUser2 = [];
    negUser1 = [];
    negUser2 = [];
    load();
  }

  void load() async {
    await _firestore.collection('CHAT').where("sendby", isEqualTo: idUser1).get().then((value) {
      setState(() {
        for (var a in value.docs) {
          chatOfUser1.add(a.data()["message"]);
        }
      });
    });
    print(chatOfUser1);

    await _firestore.collection('CHAT').where("sendby", isEqualTo: idUser2).get().then((value) {
      setState(() {
        for (var a in value.docs) {
          chatOfUser2.add(a.data()["message"]);
        }
      });
    });
    print(chatOfUser2);

    setState(() {
      isLoad = false;
    });
  }

  String xuly(String rawtext) {

    String finaltext = "";


    rawtext = rawtext.toLowerCase();

    for (var a in rawtext.split(" ")) {

      String temp = "";
      for (var b in a.split("")) {

        if (temp.endsWith(b) == false && b != '-' &&  b != '?' && b != '!' && b != '#' && b != '%' && b != '&' && b != ' ') {
          temp = temp + b.trim();
        }

      }

      finaltext = finaltext + " " + temp;

    }
    finaltext = finaltext.trim();


    return finaltext;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Phân tích"),
        elevation: 0,
        backgroundColor: Colors.orangeAccent,
      ),
      body: isLoad? Center(
        child: Text("Đang tải dữ liệu..."),
      ) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                "User 1:",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 10,),
            User1(chatOfUser1: chatOfUser1,),
            SizedBox(height: 50,),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                "User 2:",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 10,),
            User2(chatOfUser2: chatOfUser2,),
            SizedBox(height: 50,),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10)
              ),
              child: GestureDetector(
                onTap: () async {
                  var collection = FirebaseFirestore.instance.collection('CHAT');
                  var snapshots = await collection.get();
                  for (var doc in snapshots.docs) {
                    await doc.reference.delete();
                  }
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false
                  );
                },
                child: Center(child: Text("Quay về trang chủ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),))
              ),
            )
          ],
        ),
      ),
    );
  }
}

class User1 extends StatefulWidget {
  final List<String> chatOfUser1;
  const User1({Key? key, required this.chatOfUser1}) : super(key: key);

  @override
  State<User1> createState() => _User1State();
}

class _User1State extends State<User1> {

  late Classifier _classifier;
  final translator = GoogleTranslator();
  late List<double> posUser1, negUser1;
  var posU1 = 0.0;
  var negU1 = 0.0;
  bool isLoad = true;

  void initState() {
    super.initState();
    _classifier = Classifier();
    posUser1 = [];
    negUser1 = [];
    load();
  }

  void load() async {
    this.widget.chatOfUser1.forEach((element) async {
      String engText = "";
      String vieText = await xuly(element);
      await translator.translate(vieText,to: 'en', from: 'vi').then((value) => {
        engText = value.toString().toLowerCase(),
      });
      final prediction = _classifier.classify(engText);
      setState(() {
        posU1 += prediction[1];
        negU1 += prediction[0];
      });
      posUser1.add(prediction[1]);
      negUser1.add(prediction[0]);
    });
    Future.delayed(const Duration(milliseconds: 3000), (){
      setState(() {
        isLoad = false;
      });
    });
  }

  String xuly(String rawtext) {
    String finaltext = "";

    rawtext = rawtext.toLowerCase();

    for (var a in rawtext.split(" ")) {
      String temp = "";
      for (var b in a.split("")) {

        if (temp.endsWith(b) == false && b != '-' &&  b != '?' && b != '!' && b != '#' && b != '%' && b != '&' && b != ' ') {
          temp = temp + b.trim();
        }

      }

      finaltext = finaltext + " " + temp;

    }
    finaltext = finaltext.trim();

    return finaltext;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoad? Text("Đang phân tích...") : Column(children: [
        Container(
          height: 200,
          child: PieChart(
            dataMap: {
              "Positive": posU1/this.widget.chatOfUser1.length,
              "Negative": 1 - posU1/this.widget.chatOfUser1.length
            },
            colorList: [Colors.green, Colors.red],
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 10,
            ),
          ),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Kết luận: ", style: TextStyle(fontWeight: FontWeight.w500),),
            SizedBox(width: 1,),
            Text(
              posU1/this.widget.chatOfUser1.length > (1 - posU1/this.widget.chatOfUser1.length) ? "Positive" : "Negative",
              style: posU1/this.widget.chatOfUser1.length > (1 - posU1/this.widget.chatOfUser1.length) ?
              TextStyle(fontWeight: FontWeight.bold, color: Colors.green)
                  : TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            )
          ],
        )
      ],),
    );
  }
}

class User2 extends StatefulWidget {
  final List<String> chatOfUser2;
  const User2({Key? key, required this.chatOfUser2}) : super(key: key);

  @override
  State<User2> createState() => _User2State();
}

class _User2State extends State<User2> {

  late Classifier _classifier;
  final translator = GoogleTranslator();
  late List<double> posUser2, negUser2;
  var posU2 = 0.0;
  var negU2 = 0.0;
  bool isLoad = true;

  void initState() {
    super.initState();
    _classifier = Classifier();
    posUser2 = [];
    negUser2 = [];
    load();
  }

  void load() async {
    this.widget.chatOfUser2.forEach((element) async {
      String engText = "";
      String vieText = await xuly(element);
      await translator.translate(vieText,to: 'en', from: 'vi').then((value) => {
        engText = value.toString().toLowerCase(),
      });
      final prediction = _classifier.classify(engText);
      setState(() {
        posU2 += prediction[1];
        negU2 += prediction[0];
      });
      posUser2.add(prediction[1]);
      negUser2.add(prediction[0]);
    });
    Future.delayed(const Duration(milliseconds: 3000), (){
      setState(() {
        isLoad = false;
      });
    });
  }

  String xuly(String rawtext) {
    String finaltext = "";

    rawtext = rawtext.toLowerCase();

    for (var a in rawtext.split(" ")) {
      String temp = "";
      for (var b in a.split("")) {

        if (temp.endsWith(b) == false && b != '-' &&  b != '?' && b != '!' && b != '#' && b != '%' && b != '&' && b != ' ') {
          temp = temp + b.trim();
        }

      }

      finaltext = finaltext + " " + temp;

    }
    finaltext = finaltext.trim();

    return finaltext;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoad? Text("Đang phân tích...") : Column(children: [
        Container(
          height: 200,
          child: PieChart(
            dataMap: {
              "Positive": posU2/this.widget.chatOfUser2.length,
              "Negative": 1 - posU2/this.widget.chatOfUser2.length,
            },
            colorList: [Colors.green, Colors.red],
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 10,
            ),
          ),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Kết luận: ", style: TextStyle(fontWeight: FontWeight.w500),),
            SizedBox(width: 1,),
            Text(
              posU2/this.widget.chatOfUser2.length > (1 - posU2/this.widget.chatOfUser2.length) ? "Positive" : "Negative",
              style: posU2/this.widget.chatOfUser2.length > (1 - posU2/this.widget.chatOfUser2.length) ?
              TextStyle(fontWeight: FontWeight.bold, color: Colors.green)
              : TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            )
          ],
        )
      ],),
    );
  }
}


