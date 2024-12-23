import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing1/service/firestore_service.dart';
import 'package:testing1/userData.dart';

class PinjamScreen extends StatefulWidget {
  @override
  _PinjamScreenState createState() => _PinjamScreenState();
}

class _PinjamScreenState extends State<PinjamScreen> {
  FirebaseService firebaseService = new FirebaseService();
  String? selectedNama; // Variabel untuk menyimpan nama yang dipilih
  TextEditingController jumlahController = TextEditingController();
  DateTime? selectedDate;

  List<Map<String, String>> pinjamList = [];
  List<String> namaList = []; // Daftar nama yang diambil dari Firestore

  @override
  void initState() {
    super.initState();
    // Ambil daftar nama pengguna dari Firestore
    FirebaseService().userRef.snapshots().listen((snapshot) {
      setState(() {
        namaList = snapshot.docs.map((doc) => doc['nama'] as String).toList();
      });
    });
  }

  void tambahPinjam(String nama, int jumlahPinjaman) {
    if (selectedNama != null &&
        jumlahController.text.isNotEmpty &&
        selectedDate != null) {
      // Data pinjaman yang akan ditambahkan
      Map<String, dynamic> pinjaman = {
        'jumlah': jumlahController.text,
        'tanggal': selectedDate!.toIso8601String().split('T')[0],
      };

      // Tambahkan pinjaman ke Firestore
      FirebaseService().tambahPinjamanKeUser(nama, pinjaman);

      // Tambahkan ke daftar lokal untuk ditampilkan
      setState(() {
        pinjamList.add({
          'nama': selectedNama!,
          'jumlah': jumlahController.text,
          'tanggal': pinjaman['tanggal'],
        });

        // Bersihkan input
        jumlahController.clear();
        selectedDate = null;
      });
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

    if (pickedDate != null) {
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
            // Dropdown untuk memilih nama pengguna yang terlihat seperti TextField
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Pilih Nama',
                labelStyle: TextStyle(color: Colors.teal),
                filled: true,
                fillColor: Colors.white12,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: DropdownButton<String>(
                value: selectedNama,
                isExpanded: true,
                hint: Text('Pilih Nama', style: TextStyle(color: Colors.teal)),
                style: TextStyle(color: Colors.white),
                dropdownColor: Color.fromRGBO(40, 55, 77, 1.0),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedNama = newValue;
                  });
                },
                items: namaList.map<DropdownMenuItem<String>>((String nama) {
                  return DropdownMenuItem<String>(
                    value: nama,
                    child: Text(nama),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 8),
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
                if (selectedNama != null && jumlahController.text.isNotEmpty) {
                  int jumlahPinjaman = int.parse(jumlahController.text);
                  tambahPinjam(selectedNama!, jumlahPinjaman);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Harap pilih nama dan masukkan jumlah pinjaman')),
                  );
                }
              },
              child: Text('Simpan'),
            ),
            SizedBox(height: 16),
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
                        (documentSnapshot['waktuPinjaman'] as Timestamp)
                            .toDate(), // Konversi Timestamp ke DateTime
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
                            lihatDetailPinjam({
                              'nama': userData.nama,
                              // 'umur': userData.umur.toString(),
                              // 'email': userData.email,
                              // 'alamat': userData.alamat,
                              // 'handphone': userData.handphone.toString(),
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
