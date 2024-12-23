import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing1/service/auth_service.dart';
import 'package:testing1/service/firestore_service.dart';
import 'package:testing1/pinjam.dart';
import 'package:testing1/angsuran.dart';

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  FirebaseService firebaseService = FirebaseService();
  String name = "Pengguna"; // Nama default
  String email = ""; // Email pengguna

  @override
  void initState() {
    super.initState();
    // Ambil email dari Firebase Auth
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email ?? "Email Tidak Diketahui";
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> nama = ['Pinjam', 'Angsuran'];
    final List<IconData> icons = [
      Icons.monetization_on,
      Icons.payment,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Pengguna'),
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
                    style: TextStyle(color: Colors.white)),
                accountEmail: Text(email,
                    style: TextStyle(color: Colors.white70)),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 119, 119, 1.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  await AuthService().signout(context: context);
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
                "Selamat Datang $name!",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Kategori
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                nama.length,
                (index) => Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman sesuai kategori
                        if (nama[index] == 'Pinjam') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PinjamScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AngsuranScreen(),
                            ),
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
              'Data Pinjaman Anda',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firebaseService.ambilDataByEmail(email),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Terjadi kesalahan: ${snapshot.error}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada data pinjaman',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final daftarPinjam = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: daftarPinjam.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = daftarPinjam[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Card(
                        color: Color.fromRGBO(30, 40, 55, 1.0),
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            data['pinjam'],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Tanggal: ${data['waktuPinjaman']}',
                            style: TextStyle(color: Colors.white70),
                          ),
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
