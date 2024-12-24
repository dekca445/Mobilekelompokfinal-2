import 'package:flutter/material.dart';

class KalkulatorScreen extends StatefulWidget {
  @override
  _KalkulatorScreenState createState() => _KalkulatorScreenState();
}

class _KalkulatorScreenState extends State<KalkulatorScreen> {
  String hasil = "0";
  String input = "";
  String operator = "";
  double angka1 = 0;
  double angka2 = 0;

  void tekanTombol(String nilai) {
    setState(() {
      if (nilai == "C") {
        hasil = "0";
        input = "";
        operator = "";
        angka1 = 0;
        angka2 = 0;
      } else if (nilai == "+" || nilai == "-" || nilai == "*" || nilai == "/") {
        if (input.isNotEmpty) {
          angka1 = double.parse(input);
          operator = nilai;
          input = "";
        }
      } else if (nilai == "=") {
        if (input.isNotEmpty) {
          angka2 = double.parse(input);
          switch (operator) {
            case "+":
              hasil = (angka1 + angka2).toString();
              break;
            case "-":
              hasil = (angka1 - angka2).toString();
              break;
            case "*":
              hasil = (angka1 * angka2).toString();
              break;
            case "/":
              hasil = (angka1 / angka2).toString();
              break;
            default:
              hasil = "0";
          }
          input = hasil;
          operator = "";
        }
      } else {
        input += nilai;
        hasil = input;
      }
    });
  }

  Widget tombol(String nilai) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => tekanTombol(nilai),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
          padding: EdgeInsets.all(24),
        ),
        child: Text(
          nilai,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hitung Hutangmu Pengutang'),
        backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromRGBO(40, 55, 77, 1.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(24),
                child: Text(
                  hasil,
                  style: TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
            ),
            Row(
              children: [
                tombol("7"),
                tombol("8"),
                tombol("9"),
                tombol("/"),
              ],
            ),
            Row(
              children: [
                tombol("4"),
                tombol("5"),
                tombol("6"),
                tombol("*"),
              ],
            ),
            Row(
              children: [
                tombol("1"),
                tombol("2"),
                tombol("3"),
                tombol("-"),
              ],
            ),
            Row(
              children: [
                tombol("0"),
                tombol("C"),
                tombol("="),
                tombol("+"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}