import 'package:flutter/material.dart';
import 'package:medicine_reminder_list/models/medicine.dart';
import 'package:provider/provider.dart';

import '../db_helper/db_helper.dart';
import '../models/reminder.dart';
import '../providers/medicine_data.dart';

class MedicineDetailsScreen extends StatelessWidget {
  static const routeName = '/screens/medicine_details_screen';
  const MedicineDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medicine = ModalRoute.of(context)!.settings.arguments as Medicine;
    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.name),
      ),
      body: FutureBuilder(
          future: Provider.of<MedicineData>(context, listen: false)
              .fetchAndSetReminder(),
          builder: (context, data) {
            if (data.connectionState == ConnectionState.waiting)return const CircularProgressIndicator();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.file(
                  medicine.imagePath,
                  width: 150,

                ),
                Text('Name: ${medicine.name}'),
                const Divider(),
                Text('Desc: ${medicine.desc}'),
                const Divider(),
                Text('Count Days: ${medicine.countDays}'),
                const Divider(),
                Text('Times Per Day: ${medicine.countTimes}'),
                const Divider(),
                 SizedBox(
                   height: 390,
                   child: Consumer<MedicineData>(
                    child: const Center(
                      child: Text('Empty'),
                    ),
                    builder: (ctx, medicineData, ch) {
                      if (medicineData.listReminder.isEmpty) {
                        return ch!;
                      }
                      else
                      {
                        final list = medicineData.listReminder.where((element) => element.medicineID == medicine.id).toList();// filter list  by id
                        return ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (ctx, index) {
                              return ListTile(
                                title: Text('ID: ${list[index].id}'),
                                subtitle: Text('Time: ${DateTime.fromMillisecondsSinceEpoch(int.parse(list[index].dateAndTime))}'),
                              );
                            }
                        );
                      }
                    },
                  ),
                 )
              ],
            );
          }),
    );
  }
}
