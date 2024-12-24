import 'package:flutter/material.dart';
import 'package:testing1/service/popup.dart';
import 'package:testing1/service/auth_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ambil nama yang sudah ada dan tampilkan di TextField (gunakan dummy name jika belum ada)
    // _nameController.text = "Pelanggan"; // Sesuaikan dengan nama yang diambil dari Firestore
  }

  void _updateName() {
    // final newName = _nameController.text;
    // Menampilkan snackbar setelah nama diperbarui
    updateNama(context);
  }

  // void _deleteAccount() async {
  //   await AuthService().deleteAccount(context: context); // Memanggil fungsi hapus akun
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color.fromRGBO(0, 119, 119, 1.0), // Warna yang sesuai dengan dashboard
      ),
      body: Container(
        color: Color.fromRGBO(40, 55, 77, 1.0), // Warna body sesuai dashboard
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ganti Nama
            // TextField(
            //   controller: _nameController,
            //   decoration: InputDecoration(labelText: 'Enter your name'),
            // ),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _updateName, // Memperbarui nama dengan menampilkan snackbar
            //   child: Text('Save Name'),
            //   style: ElevatedButton.styleFrom(
            //     foregroundColor: Colors.white, backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
            //   ),
            // ),
            SizedBox(height: 20),

            // Ganti Password
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Enter new password'),
              onSubmitted: (newPassword) {
                AuthService().updatePassword(newPassword: newPassword, context: context);
              },
            ),
            SizedBox(height: 20),

            // Update Password Button
            ElevatedButton(
              onPressed: () {
                final newPassword = _nameController.text; // Ambil dari field password
                AuthService().updatePassword(newPassword: newPassword, context: context);
              },
              child: Text('Update Password'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color.fromRGBO(0, 119, 119, 1.0),
              ),
            ),
            SizedBox(height: 20),

            // Hapus Akun
            // ElevatedButton(
            //   onPressed: _deleteAccount, // Memanggil fungsi untuk menghapus akun
            //   child: Text('Delete Account'),
            //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            // ),
          ],
        ),
      ),
    );
  }
}
