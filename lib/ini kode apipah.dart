// child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Bagian Profil Anggota
//             Center(
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Colors.blue,
//                     child: Icon(
//                       Icons.person,
//                       size: 50,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'apipah - Anggota',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Tambahkan aksi untuk tombol "Nonaktifkan Akun"
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                     ),
//                     child: Text('Nonaktifkan Akun'),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),

//             // Bagian Simpanan
//             Text(
//               'Buat Akun',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Card(
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: Text('Pokok'),
//                     trailing: Text('Rp 70.000'),
//                   ),
//                   Divider(height: 1),
//                   ListTile(
//                     title: Text('Wajib'),
//                     trailing: Text('Rp 100.000'),
//                   ),
//                   Divider(height: 1),
//                   ListTile(
//                     title: Text('Manasuka'),
//                     trailing: Text('Rp 0'),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),

//             // Bagian Informasi Anggota
//             Text(
//               'Informasi',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 children: [
//                   ListTile(
//                     title: Text('Urutan Prioritas'),
//                     subtitle: Text('250'),
//                   ),
//                   ListTile(
//                     title: Text('Username'),
//                     subtitle: Text('apipah'),
//                   ),
//                   ListTile(
//                     title: Text('Nama'),
//                     subtitle: Text('Apipah'),
//                   ),
//                   ListTile(
//                     title: Text('Tempat Lahir'),
//                     subtitle: Text('Tulungagung'),
//                   ),
//                   ListTile(
//                     title: Text('Tanggal Lahir'),
//                     subtitle: Text('1990-01-01'),
//                   ),
//                   ListTile(
//                     title: Text('Email'),
//                     subtitle: Text('591861@gmail.com'),
//                   ),
//                   ListTile(
//                     title: Text('Pekerjaan'),
//                     subtitle: Text('PNS'),
//                   ),
//                   ListTile(
//                     title: Text('Status'),
//                     subtitle: Text('Menikah'),
//                   ),
//                   ListTile(
//                     title: Text('Alamat'),
//                     subtitle: Text('Jl. Contoh No. 123'),
//                   ),
//                   ListTile(
//                     title: Text('Handphone'),
//                     subtitle: Text('591861'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),