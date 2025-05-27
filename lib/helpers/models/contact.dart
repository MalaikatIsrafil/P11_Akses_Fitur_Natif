class Contact {
  int? id;
  late String name;
  late String phone;
  //

  Contact(this.name, this.phone);
  //

  Contact.forMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    phone = map['phone'];
  }
  //

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phone': phone};
  }
  //

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, phone: $phone}';
  }
}
