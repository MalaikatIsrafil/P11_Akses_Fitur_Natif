import 'package:flutter/material.dart'; // Import package Flutter untuk UI
import 'package:image_picker/image_picker.dart'; // Import package untuk mengambil gambar dari kamera atau galeri
import 'dart:io'; // Import package untuk mengelola file pada sistem operasi

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi Flutter dengan widget MyApp sebagai root
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pick an Image', // Judul aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue, // Warna tema utama aplikasi
      ),
      home: const Home(), // Widget utama halaman beranda aplikasi
      debugShowCheckedModeBanner: false, // Menghilangkan label debug pada pojok kanan atas
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(); // Membuat state untuk widget Home
}

class _HomeState extends State<Home> {
  File? _image; // Variabel untuk menyimpan file gambar yang dipilih, nullable
  final ImagePicker _picker = ImagePicker(); // Membuat instance ImagePicker untuk mengambil gambar

  Future getImage() async {
    // Fungsi asynchronous untuk mengambil gambar dari kamera
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera, // Sumber gambar dari kamera
      imageQuality: 100, // Kualitas gambar (0-100), 100 adalah kualitas tertinggi
      preferredCameraDevice: CameraDevice.front, // Kamera depan sebagai pilihan kamera
    );
    setState(() {
      if (image != null) {
        // Jika gambar berhasil diambil, konversi ke objek File dan simpan ke variabel _image
        _image = File(image.path);
      } else {
        // Jika pengguna batal mengambil gambar atau tidak ada gambar yang dipilih
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Akses Kamera'), // Judul pada AppBar
        backgroundColor: Colors.blue, // Warna latar AppBar
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20.0), // Memberi jarak atas 20 px
        alignment: Alignment.topCenter, // Menempatkan isi widget di bagian atas dan tengah secara horizontal
        child: Column(
          children: [
            ElevatedButton(
              onPressed: getImage, // Saat tombol ditekan, panggil fungsi getImage()
              child: const Text('Ambil Gambar'), // Teks pada tombol
            ),
            const SizedBox(height: 20), // Memberi jarak vertikal 20 px antar widget
            // Jika belum ada gambar, tampilkan teks, jika sudah ada tampilkan gambar
            _image == null
                ? const Text('Tidak ada gambar yang dipilih.')
                : Image.file(_image!),
          ],
        ),
      ),
    );
  }
}
