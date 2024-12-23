import 'package:flutter/material.dart';

void showSuccessPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Login Berhasil",
          style: TextStyle(
            color: Color.fromRGBO(0, 119, 119, 1.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Selamat datang di aplikasi!",
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Color.fromRGBO(40, 55, 77, 1.0),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
            },
            child: Text(
              "OK",
              style: TextStyle(
                color: Color.fromRGBO(0, 119, 119, 1.0),
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showSuccessPopup2(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Register Berhasil",
          style: TextStyle(
            color: Color.fromRGBO(0, 119, 119, 1.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Selamat Akun Baru!",
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Color.fromRGBO(40, 55, 77, 1.0),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
            },
            child: Text(
              "OK",
              style: TextStyle(
                color: Color.fromRGBO(0, 119, 119, 1.0),
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showSuccessPopup3(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Logout",
          style: TextStyle(
            color: Color.fromRGBO(0, 119, 119, 1.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Anda Telah Logout",
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Color.fromRGBO(40, 55, 77, 1.0),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
            },
            child: Text(
              "OK",
              style: TextStyle(
                color: Color.fromRGBO(0, 119, 119, 1.0),
              ),
            ),
          ),
        ],
      );
    },
  );
}


void updateNama(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Nama Terupdate!",
          style: TextStyle(
            color: Color.fromRGBO(0, 119, 119, 1.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Nama Telah Diganti",
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Color.fromRGBO(40, 55, 77, 1.0),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
            },
            child: Text(
              "OK",
              style: TextStyle(
                color: Color.fromRGBO(0, 119, 119, 1.0),
              ),
            ),
          ),
        ],
      );
    },
  );
}