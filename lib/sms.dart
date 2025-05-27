import 'package:flutter/material.dart'; // Import paket Flutter untuk UI
import 'package:url_launcher/url_launcher.dart'; // Import paket untuk membuka URL (termasuk SMS)

void main() {
  runApp(MyApp()); // Menjalankan aplikasi Flutter dengan root widget MyApp
}

// Widget utama aplikasi, stateless karena tidak menyimpan state internal
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kirim SMS', // Judul aplikasi
      theme: ThemeData(primarySwatch: Colors.green), // Tema warna utama hijau
      home: SMSHome(), // Widget halaman utama aplikasi
    );
  }
}

// Widget stateful untuk halaman utama yang memungkinkan perubahan state
class SMSHome extends StatefulWidget {
  @override
  _SMSHomeState createState() => _SMSHomeState(); // Membuat state untuk widget ini
}

// State dari widget SMSHome
class _SMSHomeState extends State<SMSHome> {
  // Controller untuk input nomor handphone
  final TextEditingController _phoneController = TextEditingController();

  // Controller untuk input isi pesan SMS
  final TextEditingController _messageController = TextEditingController();

  // Fungsi async untuk mengirim SMS dengan nomor dan pesan tertentu
  Future<void> _sendSMS(String number, String message) async {
    // Membuat URI khusus scheme sms dengan nomor dan body pesan
    final Uri smsUri = Uri(
      scheme: 'sms', // Scheme untuk membuka aplikasi SMS
      path: number, // Nomor tujuan SMS
      queryParameters: <String, String>{'body': message}, // Isi pesan SMS
    );

    // Mengecek apakah device dapat membuka URI sms ini
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri); // Jika bisa, buka aplikasi SMS dengan data tadi
    } else {
      // Jika gagal membuka aplikasi SMS, tampilkan pesan error menggunakan SnackBar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal membuka aplikasi SMS')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kirim SMS')), // AppBar dengan judul halaman
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Padding di sekeliling body
        child: Column(
          children: [
            TextField(
              controller:
                  _phoneController, // Menghubungkan input nomor ke controller
              keyboardType:
                  TextInputType.phone, // Keyboard khusus nomor telepon
              decoration: InputDecoration(
                labelText: 'Nomor Handphone',
              ), // Label input
            ),
            SizedBox(height: 20), // Spacer vertikal 20 pixel
            TextField(
              controller:
                  _messageController, // Menghubungkan input pesan ke controller
              keyboardType: TextInputType.text, // Keyboard teks biasa
              maxLines: 4, // Input teks dapat multi baris hingga 4 baris
              decoration: InputDecoration(
                labelText: 'Isi Pesan',
              ), // Label input pesan
            ),
            SizedBox(height: 30), // Spacer vertikal 30 pixel
            ElevatedButton.icon(
              onPressed: () {
                // Ketika tombol ditekan, panggil fungsi kirim SMS dengan isi dari input
                _sendSMS(_phoneController.text, _messageController.text);
              },
              icon: Icon(Icons.sms), // Ikon tombol SMS
              label: Text('Kirim SMS'), // Teks tombol
            ),
          ],
        ),
      ),
    );
  }
}
