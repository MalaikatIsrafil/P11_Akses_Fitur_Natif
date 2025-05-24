import 'dart:async'; // Import untuk fitur Future dan async
import 'package:flutter/material.dart'; // Import Flutter material design widget
import 'package:url_launcher/url_launcher.dart'; // Import package untuk membuka URL dan panggilan telepon
import 'package:permission_handler/permission_handler.dart'; // Import permission handler

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi Flutter dimulai dari widget MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor stateless widget dengan key opsional

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Launcher', // Judul aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tema warna utama aplikasi
      ),
      home: const MyHomePage(title: 'URL Launcher'), // Halaman utama aplikasi
    );
  }
}

class MyHomePage extends StatefulWidget {
  //
  const MyHomePage({super.key, required this.title}); // Constructor dengan parameter title wajib
  //
  final String title; // Judul halaman sebagai properti final

  @override
  _MyHomePageState createState() => _MyHomePageState(); // Membuat state untuk widget ini
}

class _MyHomePageState extends State<MyHomePage> {
  //
  bool _hasCallSupport = false; // Variabel untuk cek apakah device support panggilan telepon
  Future<void>? _launched; // Future untuk status peluncuran URL/panggilan
  String _phone = ""; // Variabel menyimpan nomor telepon input pengguna

  @override
  void initState() {
    super.initState();
    // Mengecek apakah device support panggilan telepon menggunakan canLaunch
    canLaunch('tel:123').then((bool result) {
      setState(() {
        _hasCallSupport = result; // Simpan hasil cek ke variabel state
      });
    });
  }

  Future<bool> _requestCallPermission() async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
    }
    return status.isGranted;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel', // Skema URL telepon
      path: phoneNumber, // Nomor telepon yang akan dipanggil
    );
    await launch(launchUri.toString()); // Memanggil aplikasi telepon dengan nomor tersebut
  }

  Future<void> _handleCall(String phoneNumber) async {
    bool granted = await _requestCallPermission();
    if (granted) {
      await _makePhoneCall(phoneNumber);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission telepon tidak diberikan')),
      );
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url, // URL yang ingin dibuka
      forceSafariVC: false, // Jangan pakai Safari View Controller di iOS (buka di browser eksternal)
      forceWebView: false, // Jangan pakai WebView internal
      headers: <String, String>{'my_header_key': 'my_header_value'}, // Header tambahan jika perlu
    )) {
      throw 'Could not launch $url'; // Error jika gagal membuka URL
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}'); // Tampilkan error jika ada
    } else {
      return const Text(""); // Teks kosong jika tidak ada error
    }
  }

  @override
  Widget build(BuildContext context) {
    const String toLaunch = 'https://www.polbeng.ac.id/'; // URL yang akan diluncurkan ke browser
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Judul pada AppBar sesuai properti widget
      ),
      //
      body: ListView(
        //
        children: <Widget>[
          //
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Posisi isi kolom di tengah vertikal
            //
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0), // Jarak padding di sekitar TextField
                child: TextField(
                  onChanged: (String text) => _phone = text, // Simpan input nomor telepon ke variabel _phone
                  decoration: const InputDecoration(
                    hintText: 'Input the phone number to launch', // Petunjuk di dalam TextField
                  ),
                ),
              ),
              //
              ElevatedButton(
                onPressed: _hasCallSupport
                    ? () => setState(() {
                          _launched = _handleCall(_phone);
                        })
                    : null, // Jika device tidak support panggilan, tombol nonaktif
                child: _hasCallSupport
                    ? const Text('Make phone call') // Teks tombol saat support
                    : const Text('Calling not supported'), // Teks saat tidak support
              ),
              //
              Padding(
                padding: const EdgeInsets.all(16.0), // Jarak padding untuk teks URL
                child: Text(toLaunch), // Tampilkan URL yang akan diluncurkan
              ),
              //
              ElevatedButton(
                onPressed: () => setState(() {
                  _launched = _launchInBrowser(toLaunch); // Meluncurkan URL di browser saat tombol ditekan
                }),
                child: const Text('Launch in browser'), // Teks tombol
              ),
              //
              const Padding(padding: EdgeInsets.all(16.0)), // Padding kosong untuk jarak antar elemen
              //
              FutureBuilder<void>(
                future: _launched, // Pantau status peluncuran URL atau panggilan
                builder: _launchStatus, // Bangun widget status sesuai snapshot Future
              ),
            ],
          ),
        ],
      ),
    );
  }
}
  