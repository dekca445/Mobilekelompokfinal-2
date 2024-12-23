import 'package:flutter/material.dart';

class AngsuranScreen extends StatefulWidget {
  @override
  _AngsuranScreenState createState() => _AngsuranScreenState();
}

class _AngsuranScreenState extends State<AngsuranScreen> {
  TextEditingController bayar = TextEditingController();
  double totalHutang = 500000; // Total hutang
  double perBulan = 100000; // Angsuran per bulan
  int durasiBulan = 5; // Durasi dalam bulan
  double sisaHutang = 500000; // Sisa hutang awal
  int? bulanTerpilih; // Bulan yang dipilih dari dropdown

  void bayarAngsuran() {
    if (sisaHutang > 0 && bulanTerpilih != null) {
      setState(() {
        double bayar = bulanTerpilih! * perBulan;
        sisaHutang = (sisaHutang - bayar).clamp(0, totalHutang);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pembayaran berhasil! Sisa hutang: Rp$sisaHutang'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (sisaHutang == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tidak ada hutang yang harus dibayar.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pilih bulan angsuran untuk membayar.'),
          backgroundColor: Colors.orange,
        ),
      );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sisa Hutang:',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  'Rp$sisaHutang',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: bayar,
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
            // DropdownButtonFormField<int>(
            //   decoration: InputDecoration(
            //     labelText: 'Bayar Berapa Bulan?',
            //     filled: true,
            //     fillColor: Colors.white70,
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //   ),
            //   value: bulanTerpilih,
            //   items: List.generate(
            //     durasiBulan,
            //     (index) => DropdownMenuItem(
            //       value: index + 1,
            //       child: Text('${index + 1} bulan'),
            //     ),
            //   ),
            //   onChanged: sisaHutang == 0
            //       ? null
            //       : (value) {
            //           setState(() {
            //             bulanTerpilih = value;
            //           });
            //         },
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sisaHutang == 0 ? null : bayarAngsuran,
              child: Text('Bayar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: sisaHutang == 0
                    ? Colors.grey
                    : Color.fromRGBO(0, 119, 119, 1.0),
              ),
            ),
            SizedBox(height: 20),
            Text(
              sisaHutang > 0
                  ? 'Sisa hutang Anda saat ini adalah Rp$sisaHutang'
                  : 'Anda tidak memiliki hutang.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
