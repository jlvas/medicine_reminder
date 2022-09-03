import 'dart:developer';

import 'package:flutter/material.dart';
import '../db_helper/db_helper.dart';
import '../models/medicine.dart';
import '../providers/medicine_data.dart';

class PayloadScreen extends StatelessWidget {
  final String? payload; // need to make the payload the same as medicine id.
  PayloadScreen({required this.payload, Key? key}) : super(key: key);
//
//   @override
//   State<PayloadScreen> createState() => _PayloadScreenState();
// }
//
// class _PayloadScreenState extends State<PayloadScreen> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: getDatabase(payload!),
        builder: (context, data) {
          if (data.connectionState == ConnectionState.waiting)return const CircularProgressIndicator();
          final listData = [...?data.data];
          return Scaffold(
            appBar: AppBar(
              title: Text(listData![1]['name']),
            ),
            body: Center(
                child: Column(
                children: [
                  Text('Date: ${DateTime.fromMillisecondsSinceEpoch(int.parse(listData[0]['dateAndTime']))}'),
                  Text('Description: ${listData[1]['desc']}'),
                  Text('has been taken: ${listData[0]['hasBeenTaken']}'),
                  ElevatedButton(
                      onPressed: () async{
                        final reminder = {
                          'medicineID':listData[0]['medicineID'],
                          'dateAndTime':listData[0]['dateAndTime'],
                          'hasBeenTaken':'true',
                        };


                        await DBHelper.update(
                            table: DBHelper.reminderTable,
                            data: reminder,
                            createTable: DBHelper.createReminderTable);
                        /// show a toast message
                        /// navigate to home
                      },
                      child:const Text('has Been Taken'))
                ],
            )),
          );
        });
  }


  List<String> split(String rm) {
    final list = rm.split(':');
    return list;
  }


  Future<List<Map<String, dynamic>>> getDatabase(String payload) async {
    log('payload: $payload');
    final list = split(payload!);
    final reminderData = await DBHelper.getById(
      table: DBHelper.reminderTable,
      createTable: DBHelper.createReminderTable,
      id: list[1],
    );
    log('reminderData: $reminderData');
    final medicineData = await DBHelper.getById(
      table: DBHelper.medicineTable,
      createTable: DBHelper.createMedicineTable,
      id: list[0],
    );

    List<Map<String, dynamic>> listData = [reminderData, medicineData];
    return listData;
  }
}
