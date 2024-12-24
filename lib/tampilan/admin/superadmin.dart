import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing1/service/firestore_service.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  FirebaseService firebaseService = FirebaseService();
  String? email; // Untuk email yang dipilih
  String? role; // Untuk role yang dipilih
  List<String> emailList = [];
  final List<String> roleList = ['User', 'Admin']; // Opsi peran

  @override
  void initState() {
    super.initState();
    // Ambil daftar email pengguna dari Firestore
    FirebaseFirestore.instance.collection('users').snapshots().listen((snapshot) {
      setState(() {
        emailList = snapshot.docs.map((doc) => doc.id).toList();
      });
    });
  }

  // Fungsi untuk memperbarui peran pengguna
  void updateRole() async {
    if (email == null || role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pilih email dan peran terlebih dahulu!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(email) // Ambil dokumen berdasarkan email yang dipilih
          .update({'role': role}); // Update field role

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Peran berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui peran: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - Atur Peran'),
        backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Color.fromRGBO(40, 55, 77, 1.0),
        child: Column(
          children: [
            // Dropdown untuk memilih email
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Pilih Email',
                labelStyle: TextStyle(color: Colors.teal),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: DropdownButton<String>(
                value: email,
                isExpanded: true,
                hint: Text('Pilih Email', style: TextStyle(color: Colors.teal)),
                dropdownColor: Color.fromRGBO(40, 55, 77, 1.0),
                onChanged: (String? newValue) {
                  setState(() {
                    email = newValue;
                  });
                },
                items: emailList.map((String email) {
                  return DropdownMenuItem<String>(
                    value: email,
                    child: Text(email, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            // Dropdown untuk memilih peran
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Pilih Peran',
                labelStyle: TextStyle(color: Colors.teal),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: DropdownButton<String>(
                value: role,
                isExpanded: true,
                hint: Text('Pilih Peran', style: TextStyle(color: Colors.teal)),
                dropdownColor: Color.fromRGBO(40, 55, 77, 1.0),
                onChanged: (String? newValue) {
                  setState(() {
                    role = newValue;
                  });
                },
                items: roleList.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            // Tombol untuk menyimpan perubahan
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: updateRole,
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
