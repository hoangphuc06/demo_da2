import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter_plugin_example/chat.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Đăng nhập",
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                _loginUser1();
              },
              child: Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Center(child: Text("User 1", style: TextStyle(fontWeight: FontWeight.w500),)),
              ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                _loginUser2();
              },
              child: Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(child: Text("User 2", style: TextStyle(fontWeight: FontWeight.w500),)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _loginUser1() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "user1@gmail.com",
          password: "123456"
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Chat()),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {

        print("Tài khoản chưa được đăng ký");

      } else if (e.code == 'wrong-password') {

        print("Mật khẩu không chính xác");

      }
    }
  }

  void _loginUser2() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "user2@gmail.com",
          password: "123456"
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Chat()),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {

        print("Tài khoản chưa được đăng ký");

      } else if (e.code == 'wrong-password') {

        print("Mật khẩu không chính xác");

      }
    }
  }
}
