import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing1/service/userData.dart';

class FirebaseService {
  static final String COLLECTION_REF = 'user';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference userRef;

  FirebaseService() {
    userRef = firestore.collection(COLLECTION_REF);
  }

  // Menambahkan data User baru
  void tambah(UserData userData) {
    DocumentReference documentReference = userRef.doc(userData.email);
    documentReference.set(userData.toJson());
  }

  // Mengambil stream data pengguna
  Stream<QuerySnapshot<Object?>> ambilData() {
    return userRef.snapshots();
  }

  // Menghapus data User
  void hapus(UserData userData) {
    DocumentReference documentReference = userRef.doc(userData.email);
    documentReference.delete();
  }

  // Fungsi untuk menambahkan pinjaman ke user
  Future<void> tambahPinjamanKeUser(String email, Map<String, dynamic> pinjaman) async {
    try {
      // Tambahkan pinjaman ke koleksi 'pinjaman'
      await firestore.collection('pinjaman').add(pinjaman);

      // Perbarui total hutang pengguna
      DocumentReference userDoc = userRef.doc(email);
      await firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);
        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }
        int newTotalHutang = (snapshot['pinjam'] ?? 0) + int.parse(pinjaman['jumlah']);
        transaction.update(userDoc, {'pinjam': newTotalHutang});
      });

      print('Pinjaman berhasil ditambahkan');
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk menambahkan angsuran ke user
  Future<void> tambahAngsuranKeUser(String email, Map<String, dynamic> angsuran) async {
    try {
      // Tambahkan angsuran ke koleksi 'angsuran'
      await firestore.collection('angsuran').add(angsuran);

      // Perbarui sisa hutang pengguna
      DocumentReference userDoc = userRef.doc(email);
      await firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);
        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }
        int newSisaHutang = (snapshot['pinjam'] ?? 0) - int.parse(angsuran['jumlah']);
        transaction.update(userDoc, {'pinjam': newSisaHutang});
      });

      print('Angsuran berhasil ditambahkan');
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  Stream<QuerySnapshot> ambilDataByEmail(String email) {
    return firestore
        .collection('pinjaman') // Nama koleksi, sesuaikan dengan struktur Firestore Anda
        .where('email', isEqualTo: email) // Filter berdasarkan email
        .snapshots(); // Mendapatkan data secara realtime
  }

  Stream<QuerySnapshot> ambilAngsuranByEmail(String email) {
    return firestore
        .collection('angsuran') // Nama koleksi, sesuaikan dengan struktur Firestore Anda
        .where('email', isEqualTo: email) // Filter berdasarkan email
        .snapshots(); // Mendapatkan data secara realtime
  }
}