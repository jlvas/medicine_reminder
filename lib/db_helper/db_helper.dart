import 'dart:developer';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DBHelper {


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

  static Future<List<Map<String, dynamic>>> getData(
      {required String table, required createTable}) async {
    final db = await DBHelper.database(table, createTable);
    log('DBHelper.getData: ${await db.toString()}');
    final list = await db.query(table);
    list.forEach((element) {log('${element['countDays']}');});
    return db.query(table);
  }
}
