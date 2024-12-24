import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing1/service/firestore_service.dart';

class AngsuranScreen extends StatefulWidget {
  @override
  _AngsuranScreenState createState() => _AngsuranScreenState();
}

class _AngsuranScreenState extends State<AngsuranScreen> {
  FirebaseService firebaseService = new FirebaseService();
  TextEditingController bayarController = TextEditingController();
  DateTime? selectedDate;
  String? userName;
  List<Map<String, dynamic>> angsuranList = []; // List angsuran pengguna
  int totalHutang = 0; // Total hutang pengguna

  @override
  void initState() {
    super.initState();
    // Ambil nama pengguna dan total hutang dari Firestore berdasarkan email pengguna yang sedang login
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      firebaseService.userRef.doc(user.email).get().then((doc) {
        if (doc.exists && mounted) {
          setState(() {
            userName = doc['nama'];
            totalHutang = doc['pinjam'] ?? 0;
          });
        }
      });
      // Ambil data angsuran pengguna
      firebaseService.ambilAngsuranByEmail(user.email!).listen((snapshot) {
        if (mounted) {
          setState(() {
            angsuranList = snapshot.docs.map((doc) {
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

  void tambahAngsuran(int jumlahAngsuran) async {
    if (bayarController.text.isNotEmpty && selectedDate != null && userName != null) {
      // Data angsuran yang akan ditambahkan
      Map<String, dynamic> angsuran = {
        'jumlah': bayarController.text,
        'tanggal': selectedDate!.toIso8601String().split('T')[0],
        'email': FirebaseAuth.instance.currentUser!.email, // Tambahkan email pengguna
      };

      try {
        // Tambahkan angsuran ke Firestore
        await firebaseService.tambahAngsuranKeUser(FirebaseAuth.instance.currentUser!.email!, angsuran);

        // Bersihkan input
        if (mounted) {
          setState(() {
            bayarController.clear();
            selectedDate = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Angsuran berhasil ditambahkan!'),
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
          content: Text('Harap isi semua data!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Angsuran'),
        backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromRGBO(40, 55, 77, 1.0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Angsuran',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Hutang:',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  'Rp$totalHutang',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: bayarController,
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
                if (bayarController.text.isNotEmpty) {
                  int jumlahAngsuran = int.parse(bayarController.text);
                  tambahAngsuran(jumlahAngsuran);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Harap masukkan jumlah angsuran')),
                  );
                }
              },
              child: Text('Bayar'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: angsuranList.length,
                itemBuilder: (context, index) {
                  final angsuran = angsuranList[index];
                  return Card(
                    color: Color.fromRGBO(30, 40, 55, 1.0),
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        'Jumlah: Rp ${angsuran['jumlah']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Tanggal: ${angsuran['tanggal']}',
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