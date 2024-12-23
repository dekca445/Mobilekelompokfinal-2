import 'package:flutter/material.dart';
import 'package:testing1/service/auth_service.dart';

class Register extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(40, 55, 77, 1.0),
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
        automaticallyImplyLeading: false, // Menghilangkan tombol back
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 80.0),
              // Email Field
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
              // Password Field
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock, color: Color.fromRGBO(96, 125, 139, 1.0)),
                  labelStyle: TextStyle(color: Colors.white30),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(96, 125, 139, 1.0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              // Register Button
              SizedBox(
                width: double.infinity,
                height: 45.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
                  ),
                  onPressed: ()async {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Email dan Password harus diisi!"),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }
                    // Logika register menggunakan Firebase dapat diintegrasikan di sini
                     {
                        await AuthService().signup(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context
                          );
                        };
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Register success"),
                    ));
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // Login Redirect
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    "Sudah punya akun? Login",
                    style: TextStyle(color: Colors.white30),
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
