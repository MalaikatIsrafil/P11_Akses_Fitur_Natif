/*

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Send SMS',
      //
      debugShowCheckedModeBanner: false, // Menonaktifkan tulisan debug
      //
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Send SMS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  //
  final String title;
  //
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//
//
class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();
  //
  String _message = "";
  //
  void _sendSMS(List<String> number, String message) async {
    //
    try {
      String _result = await sendSMS(message: message, recipients: number);
      setState(() => _message = _result);
    } catch (error) {
      setState(() => _message = error.toString());
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Demo Kirim SMS"),
       backgroundColor: Colors.blue,),// Mengatur warna latar belakang AppBar menjadi biru),

      //
      body: Center(
        //
        child: Padding(
          padding: const EdgeInsets.all(20.0),

          //
          child: Column(
            //
            children: <Widget>[
              //
              TextField(
                controller: _numController,
                keyboardType:
                    TextInputType
                        .phone, // Menampilkan keyboard untuk input nomor telepon
                decoration: const InputDecoration(
                  hintText: 'Masukkan nomor telepon',
                ),
              ),
              //
              //
              Container(
                height: 30.0,
              )
              //
              ,
              //
              TextField(
                controller: _msgController,
                decoration: const InputDecoration(
                  hintText: 'Pesan SMS',
                ),
              ),
              //
              //
              Container(
                height: 30.0,
              ),
              //              
              //
              FloatingActionButton(
               tooltip: 'Kirim SMS',
                child: const Icon(Icons.sms),
                //
                onPressed: () {
                  List<String> numbers = [_numController.text];
                  _sendSMS(numbers, _msgController.text);
                },)

            ],
            //
          ),
        ),
      ),
    );
  }
}

*/
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Send SMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Send SMS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();
  final Telephony telephony = Telephony.instance;

  String _message = "";

  // Tambahkan fungsi openSmsApp di sini
  //Ubah fungsi openSmsApp menjadi mengembalikan Future<void>, dan tambahkan async
  Future<void> openSmsApp(String number, String message) async {
  final Uri uri = Uri(
    scheme: 'smsto',  // Ganti dari 'sms' ke 'smsto'
    path: number,
    queryParameters: <String, String>{'body': message},
  );

  print("Mencoba membuka: ${uri.toString()}");

  if (await canLaunch(uri.toString())) {
    print("canLaunch berhasil, membuka aplikasi SMS...");
    await launch(uri.toString());
  } else {
    print("canLaunch gagal, tidak bisa membuka aplikasi SMS");
    setState(() {
      _message = "Gagal membuka aplikasi SMS.";
    });
  }
}


  // Ubah fungsi _sendSMS supaya pakai openSmsApp
  void _sendSMS(String number, String message) async {
    final bool? permissionGranted = await telephony.requestSmsPermissions;

    if (permissionGranted ?? false) {
      try {
        await openSmsApp(number, message); // Panggil openSmsApp
        setState(() {
          _message = "Aplikasi SMS terbuka. Silakan kirim pesan.";
        });
      } catch (e) {
        setState(() {
          _message = "Gagal membuka aplikasi SMS: $e";
        });
      }
    } else {
      setState(() {
        _message = "Izin tidak diberikan.";
      });
    }
  }

  /*

  void _sendSMS(String number, String message) async {
    final bool? permissionGranted = await telephony.requestSmsPermissions;

    if (permissionGranted ?? false) {
      try {
        await telephony.sendSms(to: number, message: message);
        setState(() {
          _message = "Pesan berhasil dikirim.";
        });
      } catch (e) {
        setState(() {
          _message = "Gagal mengirim: $e";
        });
      }
    } else {
      setState(() {
        _message = "Izin tidak diberikan.";
      });
    }
  }
*/

  /*
void _sendSMS(String number, String message) async {
  final bool? permissionGranted = await telephony.requestSmsPermissions;

  if (permissionGranted ?? false) {
    try {
      // Coba open dialer sebagai alternatif
      await telephony.openDialer(number);
      setState(() {
        _message = "Aplikasi SMS terbuka. Silakan kirim pesan.";
      });
    } catch (e) {
      setState(() {
        _message = "Gagal membuka aplikasi SMS: $e";
      });
    }
  } else {
    setState(() {
      _message = "Izin tidak diberikan.";
    });
  }
}

 */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.blue),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _numController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nomor telepon',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _msgController,
                decoration: const InputDecoration(hintText: 'Pesan SMS'),
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                tooltip: 'Kirim SMS',
                child: const Icon(Icons.sms),
                onPressed: () {
                  final number = _numController.text.trim();
                  final message = _msgController.text.trim();
                  if (number.isNotEmpty && message.isNotEmpty) {
                    _sendSMS(number, message);
                  } else {
                    setState(() {
                      _message = "Nomor dan pesan tidak boleh kosong.";
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              Text(_message, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
