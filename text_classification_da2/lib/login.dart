import 'package:flutter/material.dart';

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
              onTap: (){},
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
              onTap: (){},
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
}
