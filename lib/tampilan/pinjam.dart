import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing1/service/firestore_service.dart';
import 'package:testing1/service/userData.dart';

class PinjamScreen extends StatefulWidget {
  @override
  _PinjamScreenState createState() => _PinjamScreenState();
}

class _PinjamScreenState extends State<PinjamScreen> {
  FirebaseService firebaseService = new FirebaseService();
  TextEditingController jumlahController = TextEditingController();
  DateTime? selectedDate;
  String? userName;
  List<Map<String, dynamic>> pinjamanList = []; // List pinjaman pengguna

  @override
  void initState() {
    super.initState();
    // Ambil nama pengguna dari Firestore berdasarkan email pengguna yang sedang login
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      firebaseService.userRef.doc(user.email).get().then((doc) {
        if (doc.exists && mounted) {
          setState(() {
            userName = doc['nama'];
          });
        }
      });
      // Ambil data pinjaman pengguna
      firebaseService.ambilDataByEmail(user.email!).listen((snapshot) {
        if (mounted) {
          setState(() {
            pinjamanList = snapshot.docs.map((doc) {
              return {
                'jumlah': doc['jumlah'],
                'tanggal': doc['tanggal'],
              };
            }).toList();
          });
        }
      });
    }
  }

  void tambahPinjam(int jumlahPinjaman) async {
    if (jumlahController.text.isNotEmpty && selectedDate != null && userName != null) {
      // Data pinjaman yang akan ditambahkan
      Map<String, dynamic> pinjaman = {
        'jumlah': jumlahController.text,
        'tanggal': selectedDate!.toIso8601String().split('T')[0],
        'email': FirebaseAuth.instance.currentUser!.email, // Tambahkan email pengguna
      };

      try {
        // Tambahkan pinjaman ke Firestore
        await firebaseService.tambahPinjamanKeUser(FirebaseAuth.instance.currentUser!.email!, pinjaman);

        // Bersihkan input
        if (mounted) {
          setState(() {
            jumlahController.clear();
            selectedDate = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pinjaman berhasil ditambahkan!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Terjadi kesalahan: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Akunmu Belum Di veriv admin!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void pilihTanggal(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.teal, // Warna header
              onPrimary: Colors.white, // Warna teks header
              surface: Color.fromRGBO(40, 55, 77, 1.0), // Latar belakang dialog
              onSurface: Colors.white70, // Warna teks tanggal
            ),
            dialogBackgroundColor:
                Color.fromRGBO(30, 40, 55, 1.0), // Latar belakang dialog
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void lihatDetailPinjam(Map<String, String> pinjam) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(40, 55, 77, 1.0),
          title: Text('Detail Pinjam', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama: ${pinjam['nama']}',
                  style: TextStyle(color: Colors.white70)),
              Text('Jumlah: Rp ${pinjam['pinjam']}',
                  style: TextStyle(color: Colors.white70)),
              Text('Tanggal: ${pinjam['waktuPinjaman']}',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tutup', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pinjam'),
        backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Color.fromRGBO(40, 55, 77, 1.0),
        child: Column(
          children: [
            TextField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Jumlah',
                labelStyle: TextStyle(color: Colors.teal),
                filled: true,
                fillColor: Colors.white12,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Pilih Tanggal'
                        : 'Tanggal: ${selectedDate!.toIso8601String().split('T')[0]}',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => pilihTanggal(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: Text('Pilih'),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (jumlahController.text.isNotEmpty) {
                  int jumlahPinjaman = int.parse(jumlahController.text);
                  tambahPinjam(jumlahPinjaman);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Harap masukkan jumlah pinjaman')),
                  );
                }
              },
              child: Text('Simpan'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: pinjamanList.length,
                itemBuilder: (context, index) {
                  final pinjaman = pinjamanList[index];
                  return Card(
                    color: Color.fromRGBO(30, 40, 55, 1.0),
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        'Jumlah: Rp ${pinjaman['jumlah']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Tanggal: ${pinjaman['tanggal']}',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}