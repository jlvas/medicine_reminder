import 'package:flutter/material.dart';
import 'package:medicine_reminder_list/models/medicine.dart';
import 'package:provider/provider.dart';

import '../providers/medicine_data.dart';

class MedicineDetailsScreen extends StatelessWidget {
  static const routeName = '/screens/medicine_details_screen';
  const MedicineDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medicine = ModalRoute.of(context)!.settings.arguments as Medicine;
    return Scaffold(
      appBar: AppBar(
        title: Text('${medicine.name}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.file(
              medicine.imagePath,
            width: 220,
          ),
          Text('${medicine.name}'),
          Text('${medicine.desc}'),
          Text('Count Days: ${medicine.countDays}'),
          Text('Times Per Day: ${medicine.countTimes}'),
        ],
      ),
    );
  }
}
