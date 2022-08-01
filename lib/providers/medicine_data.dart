import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import '../db_helper/db_helper.dart';
import '../models/medicine.dart';
import '../models/reminder.dart';
import '../utilities/notification_api.dart';

class MedicineData with ChangeNotifier {
  static const String _medicineTable = 'medicine_list';
  static const String _reminderTable = 'reminder_list';
  static const String _createMedicineTable =
      'CREATE TABLE $_medicineTable(id TEXT PRIMARY KEY, name TEXT, desc TEXT, imagePath TEXT, countDays TEXT, countTimes TEXT, startHour TEXT)';
  static const String _createReminderTable =
      'CREATE TABLE $_reminderTable(id TEXT, dateAndTime INTEGER, hasBeenTaken TEXT)';

  List<Medicine> _items = [];
  List<Reminder> _listReminder = [];

  /// by using the 3 dots, it will return a copy of the list not the original list
  /// reason: original list should not be changed from outside this class
  List<Medicine> get items
  {
    return [..._items];
  }

  List<Reminder> get list
  {
    return [..._listReminder];
  }

  void addMReminder(Reminder reminder)
  {
    DBHelper.insert(
      table: _reminderTable,
      data: {'id': reminder.id, 'dateAndTime': reminder.dateAndTime, 'hasBeenTaken':reminder.hasBeenTaken},
      createTable: _createReminderTable,);
  }

  void addMedicine(
      {required String pickedDesc,
      required String pickedName,
      required File pickedImagePath,
      required String pickedCountDays,
      required String pickedCountTimes,
      required String pickedStartHour,
        required String pickedStartMinut,
      })
  {
    final medicine = Medicine(
      id: DateTime.now().toString(),
      imagePath: pickedImagePath,
      name: pickedName,
      desc: pickedDesc,
      countDays: pickedCountDays,
      countTimes: pickedCountTimes,
      startHour: pickedStartHour,
    );

    final int hourDiff = 24~/int.parse(pickedCountTimes);
    final int times = int.parse(pickedCountDays)* int.parse(pickedCountTimes);
    final int startHour = int.parse(pickedStartHour);
    // (DateTime.now().year, DateTime.now().month, DateTime.now().day , startHour,DateTime.now().minute)
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(pickedStartHour),
      int.parse(pickedStartMinut),
    );

    int addingHour =0;

    for(int i =0; i< times; i++)
    {
      final reminder = Reminder(
          id: medicine.id,
          dateAndTime: today.add(Duration(hours: addingHour)).millisecondsSinceEpoch,
          hasBeenTaken: 'No',
      );
      addMReminder(reminder);
      NotificationApi.showScheduleNotification(reminder: reminder,medicine: medicine);
      addingHour+=hourDiff;
    }

    _items.add(medicine);

    DBHelper.insert(
        createTable: _createMedicineTable,
        table: _medicineTable,
        data: {
          'id': medicine.id,
          'name': medicine.name,
          'desc': medicine.desc,
          'imagePath': medicine.imagePath.path,
          'countDays': medicine.countDays,
          'countTimes': medicine.countTimes,
          'startHour': medicine.startHour,
        });

    log('MedicineData.addMedicine\n${medicine.imagePath.path}');
    notifyListeners();
  }

  Future<void> fetchAndSetMedicine() async
  {
    final dataList = await DBHelper.getData(
        table: _medicineTable, createTable: _createMedicineTable);
    _items = dataList
        .map((e) => Medicine(
              id: e['id'],
              name: e['name'],
              imagePath: File(e['imagePath']),
              desc: e['desc'],
              countDays: e['countDays'],
              countTimes: e['countTimes'],
              startHour: e['startHour'],
            ))
        .toList();
    notifyListeners();
    log('MedicineData.fetchAndSetMedicine');
    _items.forEach((element) {
      log('${element.imagePath}');
    });
  }

  Future<void> fetchAndSetReminder() async
  {
    final dataList = await DBHelper.getData(
        table: _reminderTable, createTable: _createReminderTable);
    _listReminder = dataList
        .map((e) => Reminder(
      id: e['id'],
      dateAndTime: e['dateAndTime'],
      hasBeenTaken: e['hasBeenTaken'],
    ))
        .toList();
    notifyListeners();
    log('MedicineData.fetchAndSetMedicine');
    _listReminder.forEach((element) {
      log('${DateTime.fromMillisecondsSinceEpoch(element.dateAndTime)}');
    });
  }

  void deleteMedicine(String idMedicine) async
  {
    await DBHelper.delete(
        table: _medicineTable,
        id: idMedicine,
        createTable: _createMedicineTable);
    fetchAndSetMedicine();
  }

  void deleteReminder(String dateAndTime) async
  {
    await DBHelper.delete(
        table: _medicineTable,
        id: dateAndTime,
        createTable: _createReminderTable);
    fetchAndSetMedicine();
  }

  void editMedicine(Medicine medicine) async
  {
    await DBHelper.update(
      createTable: _createMedicineTable,
      table: _medicineTable,
      data: {
        'id': medicine.id,
        'name': medicine.name,
        'desc': medicine.desc,
        'imagePath': medicine.imagePath.path,
      },
    );
  }
}
