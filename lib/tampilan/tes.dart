import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testing1/service/firestore_service.dart';
import 'package:testing1/service/userData.dart';

class DetailAnggotaScreen extends StatefulWidget {
  @override
  _DetailAnggotaScreenState createState() => _DetailAnggotaScreenState();
}

class _DetailAnggotaScreenState extends State<DetailAnggotaScreen> {
  // Controller untuk TextField
  FirebaseService firebaseService = new FirebaseService();
  TextEditingController nama = TextEditingController();
  TextEditingController umur = TextEditingController();
  // TextEditingController email = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController handphone = TextEditingController();
  String? email;
  List<String> emailList = [];
  @override
  void initState() {
  super.initState();
  // Ambil daftar email pengguna dari Firestore
  FirebaseFirestore.instance.collection('users').snapshots().listen((snapshot) {
    setState(() {
      // Ambil daftar email dari ID dokumen
      emailList = snapshot.docs.map((doc) => doc.id).toList();
    });
  });
}



  // Daftar anggota
  // List<UserData> daftarUser = [
  //   UserData(
  //       'Apipah', 19, 'apipah@gmail.com', 'Jl. Contoh No. 123', 081234567890),
  // ];

  // Fungsi untuk menambahkan anggota baru
  void tambahAnggota() async {
  if (nama.text.isNotEmpty &&
      umur.text.isNotEmpty &&
      email != null && // Pastikan email sudah dipilih
      alamat.text.isNotEmpty &&
      handphone.text.isNotEmpty) {
    try {
      // Cek apakah email sudah ada di Firestore
      final emailExists = await FirebaseFirestore.instance
          .collection('user')
          .doc(email)
          .get();

      if (emailExists.exists) {
        // Email sudah digunakan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email sudah digunakan!'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Keluar dari fungsi
      }

      // Buat instance UserData
      UserData userData = UserData(
        nama.text,
        int.parse(umur.text),
        email!, // Email yang dipilih dari dropdown
        alamat.text,
        int.parse(handphone.text),
        null, // Pinjam awalnya null
        null, // Waktu pinjaman awalnya null
      );

      // Simpan data ke Firestore
      firebaseService.tambah(userData);

      // Bersihkan input setelah menyimpan
      setState(() {
        nama.clear();
        umur.clear();
        email = null; // Reset dropdown
        alamat.clear();
        handphone.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Tangani error jika ada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else {
    // Tampilkan pesan jika input kosong
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Harap isi semua data!'),
        backgroundColor: Colors.red,
      ),
    );
  }
}



  // Fungsi untuk navigasi ke detail anggota
  void lihatDetailAnggota(Map<String, String> anggota) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(40, 55, 77, 1.0),
          title: Text('Detail Anggota', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama: ${anggota['nama']}',
                    style: TextStyle(color: Colors.white70)),
                Text('Umur: ${anggota['umur']}',
                    style: TextStyle(color: Colors.white70)),
                Text('Email: ${anggota['email']}',
                    style: TextStyle(color: Colors.white70)),
                Text('Alamat: ${anggota['alamat']}',
                    style: TextStyle(color: Colors.white70)),
                Text('Handphone: ${anggota['handphone']}',
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
        title: Text('Detail Anggota'),
        backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Color.fromRGBO(40, 55, 77, 1.0),
        child: Column(
          children: [
            InputDecorator(
              decoration: InputDecoration(
                labelText: '',
                labelStyle: TextStyle(color: Colors.teal),
                filled: true,
                fillColor: Colors.white12,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: DropdownButton<String>(
                value: email,
                isExpanded: true,
                hint: Text('Pilih Email', style: TextStyle(color: Colors.teal)),
                style: TextStyle(color: Colors.white),
                dropdownColor: Color.fromRGBO(40, 55, 77, 1.0),
                onChanged: (String? newValue) {
                  setState(() {
                    email = newValue;
                  });
                },
                items: emailList.map<DropdownMenuItem<String>>((String nama) {
                  return DropdownMenuItem<String>(
                    value: nama,
                    child: Text(nama),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 8),
            // Input Data Anggota
            TextField(
              controller: nama,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nama',
                labelStyle: TextStyle(color: Colors.teal),
                filled: true,
                fillColor: Colors.white12,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: umur,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Umur',
                labelStyle: TextStyle(color: Colors.teal),
                filled: true,
                fillColor: Colors.white12,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            // SizedBox(height: 8),
            // TextField(
            //   controller: email,
            //   style: TextStyle(color: Colors.white),
            //   decoration: InputDecoration(
            //     labelText: 'Email',
            //     labelStyle: TextStyle(color: Colors.teal),
            //     filled: true,
            //     fillColor: Colors.white12,
            //     border:
            //         OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            //   ),
            // ),
            SizedBox(height: 8),
            TextField(
              controller: alamat,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Alamat',
                labelStyle: TextStyle(color: Colors.teal),
                filled: true,
                fillColor: Colors.white12,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: handphone,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'No HP',
                labelStyle: TextStyle(color: Colors.teal),
                filled: true,
                fillColor: Colors.white12,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: tambahAnggota,
              child: Text('Simpan'),
            ),
            SizedBox(height: 16),

            // List Data Anggota
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firebaseService.ambilData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Terjadi kesalahan: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Tidak ada data pengguna'));
                  }

                  // Ambil data dokumen
                  final daftarUser = snapshot.data!.docs;

                  return ListView.builder(
  itemCount: daftarUser.length,
  itemBuilder: (context, index) {
    // Ambil hanya nama pengguna
    DocumentSnapshot documentSnapshot = daftarUser[index];
    UserData userData = UserData(
      documentSnapshot['nama'],
      documentSnapshot['umur'],
      documentSnapshot['email'],
      documentSnapshot['alamat'],
      documentSnapshot['handphone'],
      documentSnapshot['pinjam'],
      (documentSnapshot['waktuPinjaman'] != null
          ? (documentSnapshot['waktuPinjaman'] as Timestamp).toDate()
          : null), // Pengecekan Timestamp
    );
    return Card(
      color: Color.fromRGBO(30, 40, 55, 1.0),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          userData.nama,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.teal),
        onTap: () {
          // Konversi userData ke Map<String, String>
          lihatDetailAnggota({
            'nama': userData.nama,
            'umur': userData.umur.toString(),
            'email': userData.email,
            'alamat': userData.alamat,
            'handphone': userData.handphone.toString(),
          });
        },
      ),
    );
  },
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
