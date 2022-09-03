import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medicine_reminder_list/screens/payload_screen.dart';
import 'package:medicine_reminder_list/screens/set_medicine_time.dart';
import 'package:medicine_reminder_list/widgets/days_and_times.dart';
import 'package:provider/provider.dart';

import '../providers/medicine_data.dart';
import '../utilities/notification_api.dart';
import '../widgets/image_input.dart';

class AddMedicineScreen extends StatefulWidget {
  static const routeName = '/screen/add_medicine_screen';

  const AddMedicineScreen({Key? key}) : super(key: key);

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _key = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _descController = TextEditingController();
  final _countDays = TextEditingController();
  final _countTimes = TextEditingController();
  final _startHour = TextEditingController();
 List<TimeOfDay?> pickedHoursPerDay =[];

  File? _pickedImagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('add a new medicine'),
        ),
        body: SafeArea(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ImageInput(_selectedImage),

                        /// Medicine Name
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) return 'Field is required';
                          },
                          decoration: const InputDecoration(
                            labelText: 'Medicine Name',
                          ),
                          controller: _medicineNameController,
                        ),

                        ///Medicine Description
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) return 'Field is required';
                          },
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          controller: _descController,
                        ),

                        ///Count Days
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) return 'Field is required';
                          },
                          keyboardType: TextInputType.number,
                          controller: _countDays,
                          decoration:
                              const InputDecoration(labelText: 'Count Days'),
                        ),

                        /// how many time per day
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) return 'Field is required';
                          },
                          keyboardType: TextInputType.number,
                          controller: _countTimes,
                          decoration: const InputDecoration(
                              labelText: 'Count Times per Day'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Setup Time
                ElevatedButton(
                    onPressed: () async{
                      pickedHoursPerDay = await Navigator.pushNamed(context, SetMedicineTime.routeName, arguments: _countTimes.text) as List<TimeOfDay?>;
                      // pickedHoursPerDay = list as List<TimeOfDay?>;
                      // print("List: ${list.runtimeType}");
                    },
                    child: Text('Set Time')),
                ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate() && pickedHoursPerDay!.isNotEmpty) _saveMedicine();
                  },
                  child: const Text('+ Add Medicine'),
                ),
              ],
            ),
          ),
        ));
  }

  void _selectedImage(File pickedImagePath) {
    log('AddMedicineScreen._selectedImage');
    _pickedImagePath = pickedImagePath;
  }

  void _saveMedicine() {
    if (_medicineNameController.text.isEmpty) return;
    Provider.of<MedicineData>(context, listen: false).addMedicine(
      pickedDesc: _descController.text,
      pickedName: _medicineNameController.text,
      pickedImagePath: _pickedImagePath!,
      pickedCountDays: _countDays.text,
      pickedHoursPerDay: pickedHoursPerDay,
    );
    Navigator.pop(context);
  }

  // @override
  // void initState()
  // {
  //   NotificationApi.init();
  //   listenNotifications();
  //   super.initState();
  // }
  //
  // void listenNotifications()
  // {
  //   NotificationApi.onNotifications.stream.listen(onClickedNotification);
  // }
  //
  // void onClickedNotification(String? payload)
  // {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context)=>PayloadScreen(payload: payload)),
  //   );
  // }

}
