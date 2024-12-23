class UserData {
  String nama;
  int umur;
  String email;
  String alamat;
  int handphone;
  int? pinjam; // Ubah menjadi nullable
  DateTime? waktuPinjaman; // Menambahkan field waktu

  UserData(
    this.nama,
    this.umur,
    this.email,
    this.alamat,
    this.handphone,
    this.pinjam,
    this.waktuPinjaman,
  );

  Map<String, dynamic> toJson() {
    return {
      "nama": this.nama,
      "umur": this.umur,
      "email": this.email,
      "alamat": this.alamat,
      "handphone": this.handphone,
      "pinjam": this.pinjam, // Menyimpan null jika belum ada pinjaman
      "waktuPinjaman": this.waktuPinjaman?.toString(), // Menyimpan waktu pinjaman
    };
  }
}
