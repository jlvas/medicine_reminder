import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/medicine.dart';
import '../providers/medicine_data.dart';

class PayloadScreen extends StatelessWidget {
  final String? payload;
  const PayloadScreen({this.payload,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<MedicineData>(context, listen: false).fetchAndSetReminder();
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder'),
      ),
      body: Consumer<MedicineData>(
        child: Text(''),
        builder: (ctx, medicineData, ch){
          Medicine medicine = _initializeMedicine(medicineData);
          return Center(
            child: Column(
              children: [
                Text('Name: ${medicine.name}'),
                Text('Description: ${medicine.desc}'),
              ],
            ),
          );
        },
      ),
    );
  }

  Medicine _initializeMedicine(MedicineData medicineData){
    return medicineData.items.where((element) => element.id == this.payload).first;
  }
}
