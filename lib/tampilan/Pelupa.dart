import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(40, 55, 77, 1.0),
      appBar: AppBar(
        title: Text("Lupa Password"),
        backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 80.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email, color: Color.fromRGBO(96, 125, 139, 1.0)),
                  labelStyle: TextStyle(color: Colors.white30),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(96, 125, 139, 1.0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 45.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
                  ),
                  onPressed: () async {
                    String email = emailController.text.trim();
                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Email harus diisi!"),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                      Fluttertoast.showToast(
                        msg: "Email reset password telah dikirim!",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 14.0,
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: "Terjadi kesalahan: $e",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 14.0,
                      );
                    }
                  },
                  child: Text(
                    "Reset Password",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}