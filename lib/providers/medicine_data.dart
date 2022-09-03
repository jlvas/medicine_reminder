import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import '../db_helper/db_helper.dart';
import '../models/medicine.dart';
import '../models/reminder.dart';
import '../utilities/notification_api.dart';

class MedicineData with ChangeNotifier {
  List<Medicine> _items = [];
  List<Reminder> _listReminder = [];

  /// by using the 3 dots, it will return a copy of the list not the original list
  /// reason: original list should not be changed from outside this class
  List<Medicine> get items {
    return [..._items];
  }

  List<Reminder> get listReminder {
    return [..._listReminder];
  }

  void addMReminder(Reminder reminder) {
    DBHelper.insert(
      table: DBHelper.reminderTable,
      data: {
        'id': reminder.id,
        'dateAndTime': reminder.dateAndTime,
        'hasBeenTaken': reminder.hasBeenTaken
      },
      createTable: DBHelper.createReminderTable,
    );
  }

  Future<void> addMedicine({
    required String pickedDesc,
    required String pickedName,
    required File pickedImagePath,
    required String pickedCountDays,
    required List<TimeOfDay?> pickedHoursPerDay,
  }) async {
    /// insert medicine into a database
    await DBHelper.insert(
        table: DBHelper.medicineTable,
        data: {
          'name': pickedName,
          'desc': pickedDesc,
          'imagePath': pickedImagePath.path,
          'countDays': pickedCountDays,
          'countTimes': pickedHoursPerDay.length.toString(),
        },
        createTable: DBHelper.createMedicineTable
    );
    final date = DateTime.now().day;
    final month = DateTime.now().month;
    final year = DateTime.now().year;
    final medicineID = await DBHelper.getLastID(DBHelper.medicineTable, DBHelper.createMedicineTable);
    log('medicineID = $medicineID');

    for (int i = 0; i < int.parse(pickedCountDays); i++) {
      for (var selectedHour in pickedHoursPerDay) {
        ///insert reminder
        await DBHelper.insert(
          table: DBHelper.reminderTable,
          data: {
            'medicineID': medicineID,
            'dateAndTime': DateTime(year, month,date + i,  selectedHour!.hour, selectedHour.minute,0,0,0).millisecondsSinceEpoch.toString(),
            'hasBeenTaken': 'false',
          },
          createTable: DBHelper.createReminderTable,
        );
      }
    }

    await fetchAndSetMedicine();
    await fetchAndSetReminder();
    var count =1;
    for(var reminder in _listReminder){
      if(reminder.medicineID == medicineID){
        NotificationApi.scheduleNotification(name: pickedName, desc: pickedDesc, reminder: reminder, order: count);
        count++;
      }
    }
    // notifyListeners();
  }

  Future<void> fetchAndSetMedicine() async {
    log('MedicineData.fetchAndSetMedicine()');
    final dataList = await DBHelper.getData(
        table: DBHelper.medicineTable,
        createTable: DBHelper.createMedicineTable);
    _items = dataList
        .map((e) => Medicine(
              id: e['id'],
              name: e['name'],
              imagePath: File(e['imagePath']),
              desc: e['desc'],
              countDays: e['countDays'],
              countTimes: e['countTimes'],
            ))
        .toList();
    notifyListeners();
  }

  Future<void> fetchAndSetReminder() async {
    log('MedicineData.fetchAndSetReminder()');
    final dataList = await DBHelper.getData(
        table: DBHelper.reminderTable,
        createTable: DBHelper.createReminderTable);
    _listReminder = dataList
        .map((e) => Reminder(
              id: e['id'],
              medicineID: e['medicineID'],
              hasBeenTaken: e['hasBeenTaken'],
              dateAndTime: e['dateAndTime'],
            ))
        .toList();
    notifyListeners();
  }

  Future<Reminder> fetchAndSetReminderById(String reminderID) async {
    log('MedicineData.fetchAndSetReminder()');
    final reminderData = await DBHelper.getById(
        table: DBHelper.reminderTable,
        createTable: DBHelper.createReminderTable,
        id: reminderID);
    return Reminder(
              id: reminderData['id'],
              medicineID: reminderData['medicineID'],
              dateAndTime: reminderData['dateAndTime'],
              hasBeenTaken: reminderData['hasBeenTaken'],
            );
  }

  void deleteMedicine(String idMedicine) async {
    await DBHelper.delete(
        table: DBHelper.medicineTable,
        id: idMedicine,
        createTable: DBHelper.createMedicineTable);
    fetchAndSetMedicine();
  }

  void deleteReminder(String dateAndTime) async {
    await DBHelper.delete(
        table: DBHelper.medicineTable,
        id: dateAndTime,
        createTable: DBHelper.createReminderTable);
    fetchAndSetMedicine();
  }

  void editMedicine(Medicine medicine) async {
    await DBHelper.update(
      createTable: DBHelper.createMedicineTable,
      table: DBHelper.medicineTable,
      data: {
        'id': medicine.id,
        'name': medicine.name,
        'desc': medicine.desc,
        'imagePath': medicine.imagePath.path,
      },
    );
  }
}
