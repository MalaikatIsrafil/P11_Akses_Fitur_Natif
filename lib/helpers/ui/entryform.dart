import 'package:flutter/material.dart';
import 'package:akses_fitur_natif/helpers/models/contact.dart';

class EntryForm extends StatefulWidget {
  final Contact contact;
  //
  const EntryForm(this.contact, {Key? key}) : super(key: key);
  //
  @override
  _EntryFormState createState() => _EntryFormState();
}

//
//
class _EntryFormState extends State<EntryForm> {
  //
  Contact? _contact;
  _EntryFormState();

  //
  final TextEditingController _namedController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  //
  @override
  Widget build(BuildContext context) {
    _contact = widget.contact;
    //
    if (_contact!.name != "") {
      _namedController.text = _contact!.name;
      _phoneController.text = _contact!.phone;
    }
    //
    return Scaffold(
      //
      appBar: AppBar(
        //
        title:
            _contact!.name == ""
                ? const Text('Tambah Data')
                : const Text('Ubah Data'),
        //
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          //
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        //
      ),
      //
      body: Padding(
        //
        padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        //
        child: ListView(
          //
          children: <Widget>[
            //
            //NAMA
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: _namedController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                //
                onChanged: (value) {},
                //
              ),
            ),
            //
            //NO HP
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Handphone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                //
                onChanged: (value) {},
                //
              ),
            ),
            //
            //SIMPAN
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  //tombol simpan
                  Expanded(
                    child: ElevatedButton(
                      child: const Text('Simpan'),
                      //
                      onPressed: () {
                        if (_contact == null) {
                          _contact = Contact(
                            _namedController.text,
                            _phoneController.text,
                          );
                        } else {
                          _contact?.name = _namedController.text;
                          _contact?.phone = _phoneController.text;
                        }
                        //
                        Navigator.pop(context, _contact);
                      },
                      //
                    ),
                  ),
                  //
                  //BATAL
                  Container(width: 5.0),
                  //
                  //tombol batal
                  Expanded(
                    child: ElevatedButton(
                      child: const Text('Batal'),
                      //
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      //
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    //

    //
  }
}
