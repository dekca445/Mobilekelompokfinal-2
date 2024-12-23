import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg.jpg'),
                fit: BoxFit.cover,
              ),
//              color: Color(0xFF7FE5D7),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: topIconBar(),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 90.0),
                  child: LoginForm(),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 15),
            child: Transform.scale(
              alignment: Alignment(0, 1),
              scale: 2,
              child: floatingButton(),
            ),
          ),
          Container(
            color: Colors.white,
            child: SignupForm(),
          ),
        ],
      ),
    );
  }

  // Top icon bar
  Widget topIconBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  IconData(0xe5d2, fontFamily: 'MaterialIcons'),
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(
                  IconData(0xe3b6, fontFamily: 'MaterialIcons'),
                  color: Color(0xFF000000),
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Floating button
  Widget floatingButton() {
    return FloatingActionButton(
      onPressed: () {
        print('floating action pressed');
      },
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Icon(
          IconData(
            0xe313,
            fontFamily: 'MaterialIcons',
          ),
          size: 48,
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            'LOGIN',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0),
            width: 300,
            child: getTextField('@username', 'username'),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: 300,
            child: getTextField('password', 'password', true),
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0),
            width: 150,
            child: OutlinedButton(
                onPressed: () {},
                child: Text(
                  'GO !',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  side: BorderSide(color: Color.fromARGB(255, 16, 69, 229)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )

          ),
        ],
      ),
    );
  }

  Widget getTextField(String hintText, String key, [bool isPassword = false]) {
    return new TextField(
      key: Key(key),
      textAlign: TextAlign.center,
      obscureText: isPassword,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        fillColor: Color(0xFFD8F0F2),
        filled: true,
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupFormState();
  }
}

class _SignupFormState extends State<SignupForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 300,
            child: TextButton(
                onPressed: () {
                  print('login with fb pressed.');
                },
                child: Image(
                  image: AssetImage('images/loginwithfacebook.png'),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0),
                ),
              ),

          ),
          Container(
            width: 300,
            margin: EdgeInsets.only(top: 10),
            child: TextButton(
              onPressed: () {
                print('login with google pressed.');
              },
              child: Image(image: AssetImage('images/loginwithgoogle.png')),
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(0),
              ),
            ),
          ),
          Container(
            width: 300,
            margin: EdgeInsets.only(top: 10),
            child: ElevatedButton(
                onPressed: () {
                  print('create account pressed');
                },
                child: Text(
                  'Create an account',
                  style: TextStyle(fontSize: 24),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
              )

          ),
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 20),
            child: Text(
              'ABOUT | CONTACT',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}