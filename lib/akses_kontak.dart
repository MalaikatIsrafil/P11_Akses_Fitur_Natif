import 'dart:typed_data'; // Import untuk tipe data byte yang digunakan pada foto kontak
import 'package:flutter/material.dart'; // Import package Flutter untuk UI
import 'package:flutter_contacts/flutter_contacts.dart'; // Import package untuk akses kontak telepon
import 'package:url_launcher/url_launcher.dart'; // Import package untuk membuka URL (dalam kasus ini untuk panggilan telepon)

void main() async {
  runApp(
    const MyApp(),
  ); // Menjalankan aplikasi Flutter dengan widget MyApp sebagai root
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Read Contact App', // Judul aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue, // Warna utama tema aplikasi
      ),
      home: const MyHomePage(), // Widget utama halaman beranda aplikasi
      debugShowCheckedModeBanner:
          false, // Menghilangkan label debug di kanan atas
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(); // Membuat state untuk halaman ini
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact>?
  contacts; // List nullable untuk menyimpan data kontak yang diambil

  @override
  void initState() {
    super.initState();
    getContact(); // Memanggil fungsi untuk mengambil kontak saat widget pertama kali dibuat
  }

  void getContact() async {
    // Meminta izin akses kontak kepada pengguna
    if (await FlutterContacts.requestPermission()) {
      // Jika izin diberikan, ambil semua kontak dengan properti lengkap dan foto
      contacts = await FlutterContacts.getContacts(
        withProperties: true, // Mengambil data lengkap termasuk nomor telepon
        withPhoto: true, // Mengambil foto kontak jika ada
      );
      setState(() {}); // Memperbarui UI karena data kontak sudah didapat
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Read Contact App", // Judul di AppBar
          style: TextStyle(color: Colors.black), // Warna teks hitam
        ),
        centerTitle: true, // Memposisikan judul di tengah AppBar
        backgroundColor: Colors.blue, // Warna latar AppBar
        elevation: 0, // Menghilangkan bayangan AppBar
      ),
      body:
          (contacts) == null
              // Jika data kontak belum tersedia, tampilkan loading spinner
              ? const Center(child: CircularProgressIndicator())
              // Jika sudah ada data kontak, tampilkan dalam ListView
              : ListView.builder(
                itemCount:
                    contacts!.length, // Jumlah item sebanyak jumlah kontak
                itemBuilder: (BuildContext context, int index) {
                  // Ambil foto kontak dalam bentuk Uint8List
                  Uint8List? image = contacts![index].photo;
                  // Ambil nomor telepon pertama jika ada, jika tidak tampilkan "--"
                  String num =
                      (contacts![index].phones.isNotEmpty)
                          ? (contacts![index].phones.first.number)
                          : "--";

                  return ListTile(
                    // Jika foto tidak ada, tampilkan icon orang default, jika ada tampilkan foto
                    leading:
                        (contacts![index].photo == null)
                            ? const CircleAvatar(child: Icon(Icons.person))
                            : CircleAvatar(
                              backgroundImage: MemoryImage(image!),
                            ),
                    // Tampilkan nama depan dan belakang kontak
                    title: Text(
                      "${contacts![index].name.first} ${contacts![index].name.last}",
                    ),
                    // Tampilkan nomor telepon sebagai subtitle
                    subtitle: Text(num),
                    // Saat ditekan, jika nomor telepon ada, maka lakukan panggilan telepon
                    onTap: () {
                      if (contacts![index].phones.isNotEmpty) {
                        launch(
                          'tel: $num',
                        ); // Memanggil aplikasi telepon dengan nomor tersebut
                      }
                    },
                  );
                },
              ),
    );
  }
}
