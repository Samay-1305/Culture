import 'package:culture/api_calls/authentication.dart';
import 'package:culture/constants/color_contants.dart';
import 'package:culture/main.dart';
import 'package:culture/objects/user.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[grey, white],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  bool passwordVisible = false;
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: black,
      child: SafeArea(
        child: Center(
          child: Container(
            height: 600,
            width: 300,
            color: black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Culture',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: white
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                   "Trading today's culture a dollar at a time",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: grey
                    ),
                  ),
                ),
                SizedBox(height: 16),
                if (MediaQuery.of(context).viewInsets.bottom == 0.0)
                 Spacer(),
                TextField(
                  obscureText: false,
                  style: TextStyle(color: white, fontSize: 18),
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Username",
                    hintStyle: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
                    labelText: "Username",
                    labelStyle: TextStyle(color: grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: grey, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  obscureText: !passwordVisible,
                  style: TextStyle(color: white, fontSize: 18),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                      child: passwordVisible ?
                        Icon(Icons.visibility_off, color: white) : Icon(Icons.visibility, color: white)
                    ),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Password",
                    hintStyle: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
                    labelText: "Password",
                    labelStyle: TextStyle(color: grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: grey, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ConfirmationSlider(
                  text: 'Slide to Login',
                  foregroundColor: grey,
                  foregroundShape: BorderRadius.all(Radius.circular(10.0)),
                  backgroundShape: BorderRadius.all(Radius.circular(10.0)),
                  onConfirmation: () async {
                    User user = await Authentication(username: username, password: password).fetchUser();
                    if (user.success) {
                      print(user.authKey);
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MyHomePage(user: user)
                      ));
                    } else {
                      print(user.error);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(user.error),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
