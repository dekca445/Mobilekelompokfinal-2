import 'package:flutter/material.dart';
import 'package:testing1/dashboard.dart';
import 'package:testing1/dashboarduser.dart';
import 'package:testing1/register.dart';
import 'package:testing1/service/auth_service.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(40, 55, 77, 1.0),
        body: SingleChildScrollView(child: LoginPage()),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController(); // Controller untuk Email
  final TextEditingController passwordController = TextEditingController(); // Controller untuk Password

  bool _autoValidate = false;
  bool loading = false;

  @override
  void dispose() {
    // Membersihkan controller untuk menghindari kebocoran memori
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration customTextDecoration({required String text, required IconData icon}) {
    return InputDecoration(
      labelStyle: TextStyle(color: Colors.white30),
      labelText: text,
      prefixIcon: Icon(icon, color: Colors.blueGrey.shade700),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey.shade700),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Widget loginButton(BuildContext context) {
    return SizedBox(
      height: 45.0,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
        ),
        child: Text(
          "Login",
          style: TextStyle(color: Colors.white70),
        ),
        onPressed: () {
  FocusScope.of(context).unfocus(); // Menyembunyikan keyboard
  if (_formKey.currentState!.validate()) {
    setState(() {
      loading = true;
    });

    // Mengambil email dan password langsung dari controller
    Future.delayed(Duration(seconds: 1), () async {
      setState(() {
        loading = false;
      });

      // Ganti ini dengan logika autentikasi Firebase atau lainnya
      {
        String? result =  await AuthService().signin(
          email: emailController.text,
          password: passwordController.text,
          context: context
        );
        if (result == 'Admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Dashboard(),
        ),
      );
    } else if (result == 'User') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UserDashboard(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login Failed: $result'), // Show error message
      ));
    }
      }
    });
  } else {
    setState(() {
      _autoValidate = true;
    });
  }
}

      ),
    );
  }

Widget loginUi() {
  return Form(
    key: _formKey,
    autovalidateMode: _autoValidate
        ? AutovalidateMode.always
        : AutovalidateMode.disabled,
    child: Column(
      children: <Widget>[
        SizedBox(height: 80.0),
        // Ganti Image dengan Icon
        Container(
          height: 150.0,
          child: Icon(
            Icons.account_circle, // Pilih ikon yang sesuai
            color: Colors.white, // Warna ikon
            size: 100.0, // Ukuran ikon disesuaikan
          ),
        ),
                Text(
            "Login",
            style: TextStyle(
            fontSize: 32.0,  // Ukuran teks besar
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 50.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: <Widget>[
              // Email Field
              TextFormField(
                controller: emailController,
                style: TextStyle(color: Colors.white30, fontSize: 15.0),
                keyboardType: TextInputType.emailAddress,
                decoration: customTextDecoration(
                  icon: Icons.person,
                  text: "Email",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan email';
                  } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return "Email tidak valid";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              // Password Field
              TextFormField(
                controller: passwordController,
                style: TextStyle(color: Colors.white30, fontSize: 15.0),
                obscureText: true,
                decoration: customTextDecoration(
                  icon: Icons.lock,
                  text: "Password",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan password';
                  } else if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              loginButton(context),
              SizedBox(height: 30.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: Text(
                  "Belum punya akun? Daftar",
                  style: TextStyle(color: Colors.white30),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        loginUi(),
        if (loading)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
