import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing1/userData.dart';

class FirebaseService {
  static final String COLLECTION_REF = 'user';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference userRef;

  FirebaseService() {
    userRef = firestore.collection(COLLECTION_REF);
  }

  // Menambahkan data User baru
  void tambah(UserData userData) {
    DocumentReference documentReference = userRef.doc(userData.nama);
    documentReference.set(userData.toJson());
  }

  // Mengambil stream data pengguna
  Stream<QuerySnapshot<Object?>> ambilData() {
    return userRef.snapshots();
  }

  // Menghapus data User
  void hapus(UserData userData) {
    DocumentReference documentReference = userRef.doc(userData.nama);
    documentReference.delete();
  }

  // Fungsi untuk menambahkan pinjaman ke user
  Future<void> tambahPinjamanKeUser(String nama, Map<String, dynamic> pinjaman) async {
    try {
      // Query pengguna berdasarkan nama
      QuerySnapshot userSnapshot = await userRef.where('nama', isEqualTo: nama).get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id; // Ambil ID dokumen
        DateTime waktuPinjaman = DateTime.now(); // Mendapatkan waktu pinjaman

        // Perbarui pinjaman dan waktu pinjaman
        await userRef.doc(userId).update({
          'pinjam': FieldValue.increment(int.parse(pinjaman['jumlah'])),
          'waktuPinjaman': waktuPinjaman, // Menyimpan waktu pinjaman
        });

        print('Pinjaman berhasil ditambahkan');
      } else {
        print('Pengguna tidak ditemukan');
      }
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

}
