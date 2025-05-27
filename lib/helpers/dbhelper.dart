import 'dart:async';
import 'package:akses_fitur_natif/helpers/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Future<Database> db() async {
    //
    String path = await getDatabasesPath();
    final Database = openDatabase(
      join(path, 'contacts.db'),
      onCreate: (db, version) async {
        await _createTable(db);
      },
      version: 1,
    );
    return Database;
  }

  //
  //
  static Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT
      )
      ''');
  }
  //
  //
  static Future<List<Contact>> getContacts() async {
    final Database db = await DbHelper.db();
    //
    final List<Map<String, dynamic>>maps = 
      await db.query('contacts', orderBy: 'name');
    //
    return List.generate(maps.length, (i) {
      return Contact.forMap(
        maps[i]
      );
    });
  }
  //
  //
  static Future<int> insert(Contact contact) async {
    final db = await DbHelper.db();
    //
    int count = await db.insert(
      'contacts',
       contact.toMap(),
       conflictAlgorithm: ConflictAlgorithm.replace,
      );
    //
    return count;
  
  }
  //
  //
  static Future<int> update(Contact contact) async {
    final db = await DbHelper.db();
    //
    int count = await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
    //
    return count;
  }
  //
  //
  static Future<int> delete(int id) async {
    final db = await DbHelper.db();
    //
    int count = await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
    //
    return count;
  }
}
