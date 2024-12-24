import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing1/angsuran.dart';
import 'package:testing1/dashboarduser.dart';
import 'package:testing1/pinjam.dart';
import 'package:testing1/service/auth_service.dart';
import 'package:testing1/setting.dart'; // Import halaman Setting
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing1/superadmin.dart';
import 'package:testing1/tes.dart';
import 'package:testing1/userData.dart';
import 'package:testing1/service/firestore_service.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FirebaseService firebaseService = new FirebaseService();
  String name = "Mimin ganteng"; // Nama default jika belum diubah
  String email = ""; // Email dari Firebase Auth

  @override
  void initState() {
    super.initState();
    // Ambil email dari Firebase Auth saat login
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email =
          user.email ?? "Email@Dummy.com"; // Menampilkan email dari Firebase
    }
  }

  // Fungsi untuk memperbarui nama setelah diubah di halaman Settings
  void updateName(String newName) {
    setState(() {
      name = newName; // Update nama di Dashboard
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> nama = ['Anggota', 'Pinjam', 'Admin'];
    final List<IconData> icons = [
      Icons.person_add, // Ikon untuk Anggota
      Icons.monetization_on, // Ikon untuk Pinjam
      Icons.payment, // Ikon untuk Angsuran
    ];

    void lihatDetailAnggota(Map<String, String> anggota) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(40, 55, 77, 1.0),
            title:
                Text('Detail Anggota', style: TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama: ${anggota['nama']}',
                    style: TextStyle(color: Colors.white70)),
                Text('Umur: ${anggota['umur']}',
                    style: TextStyle(color: Colors.white70)),
                // Text('Email: ${anggota['email']}',
                //     style: TextStyle(color: Colors.white70)),
                Text('Alamat: ${anggota['alamat']}',
                    style: TextStyle(color: Colors.white70)),
                Text('Handphone: ${anggota['handphone']}',
                    style: TextStyle(color: Colors.white70)),
                Text('Pinjaman: ${anggota['pinjam']}',
                    style: TextStyle(color: Colors.white70)),
                // Text('waktu: ${anggota['waktuPinjaman']}',
                //     style: TextStyle(color: Colors.white70)),
                // Text('Jumlah: Rp ${pinjam['jumlah']}',
                // style: TextStyle(color: Colors.white70)),
                // Text('Tanggal: ${pinjam['tanggal']}',
                // style: TextStyle(color: Colors.white70)),
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Simpan Pinjam'),
        backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
        centerTitle: true,
        elevation: 4,
      ),
      drawer: Drawer(
        child: Container(
          color: Color.fromRGBO(40, 55, 77, 1.0),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(name,
                    style: TextStyle(color: Colors.white)), // Menampilkan nama
                accountEmail: Text(email,
                    style:
                        TextStyle(color: Colors.white70)), // Menampilkan email
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/profile.jpg'), // Gambar profil
                ),
                decoration:
                    BoxDecoration(color: Color.fromRGBO(0, 119, 119, 1.0)),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  );
                  // .then((newName) {
                  //   // Jika ada perubahan nama dari halaman Settings
                  //   if (newName != null) {
                  //     updateName(newName); // Update nama di Dashboard
                  //   }
                  // });
                },
              ),
              Divider(color: Colors.white70),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  await AuthService().signout(context: context); // Logout
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(40, 55, 77, 1.0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.dashboard,
                size: 80,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Selamat Datang $name!", // Menampilkan nama pengguna
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Kategori
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                nama.length,
                (index) => Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman sesuai kategori
                        if (nama[index] == 'Anggota') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailAnggotaScreen()),
                          );
                        } else if (nama[index] == 'Pinjam') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserDashboard()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminScreen()),
                          );
                        }
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            Icon(icons[index], color: Colors.white, size: 35),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      nama[index],
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Pinjaman Section
            Text(
              'Pinjaman',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70),
            ),
            SizedBox(height: 10),
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
                          trailing:
                              Icon(Icons.arrow_forward, color: Colors.teal),
                          onTap: () {
                            // Konversi userData ke Map<String, String>
                            lihatDetailAnggota({
                              'nama': userData.nama,
                              'umur': userData.umur.toString(),
                              // 'email': userData.email,
                              'alamat': userData.alamat,
                              'handphone': userData.handphone.toString(),
                              'pinjam': userData.pinjam.toString(),
                              'waktuPinjaman':
                                  userData.waktuPinjaman.toString(),
                              // 'pinjaman' : userData.,
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
