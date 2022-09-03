import 'dart:developer';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DBHelper {

  static const String medicineTable = 'medicine_list';
  static const String reminderTable = 'reminder_list';
  static const String createMedicineTable =
      'CREATE TABLE $medicineTable(id INTEGER primary key AUTOINCREMENT, name TEXT, desc TEXT, imagePath TEXT, countDays TEXT, countTimes TEXT)';
  static const String createReminderTable =
      'CREATE TABLE $reminderTable(id INTEGER primary key AUTOINCREMENT, medicineID INTEGER, dateAndTime TEXT, hasBeenTaken TEXT)';

  static Future<Database> database(String table, String createTable) async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, '$table.db'),
        onCreate: (database, version) {
      database.execute(createTable);
    }, version: 1);
  }

  static Future<void> insert(
      {required String table, required Map<String, dynamic> data, required createTable}) async {
    final db = await DBHelper.database(table, createTable);
    int id = await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    log('DBHelper.insert\nid: $id');
  }

  static Future<void> delete({required String table, required String id, required createTable}) async{
    final db = await DBHelper.database(table, createTable);
    await db.delete(table, where: 'id=$id');
  }

  static Future<void> update({required String table, required Map<String, dynamic> data,required createTable}) async {
    final db = await DBHelper.database(table, createTable);
    await db.update(table, data);
  }

  static Future<List<Map<String, dynamic>>> getData({required String table, required createTable}) async {
    final db = await DBHelper.database(table, createTable);
    log('DBHelper.getData: ${db.toString()}');
    final list = await db.query(table);
    for (var element in list) {log('ID: ${element['id']}');}
    return db.query(table);
  }

  static Future<Map<String, dynamic>> getById({required String table, required String createTable, required String id})async{
    log('DBHelper.getById');
    final db = await DBHelper.database(table, createTable);
    final List<Map<String, dynamic>> data = await db.rawQuery('select * from $table where id = $id');
    log('${data.first}');
    return data.first;
  }
  
  static Future<int> getLastID(String table, String createTable) async{
    final db = await DBHelper.database(table, createTable);
    List<Map<String, Object?>> lastID = await db.rawQuery('SELECT id FROM $table ORDER BY id DESC LIMIT 1;');
    int id = int.parse(lastID.first['id'].toString());
    return id;
  }
}
