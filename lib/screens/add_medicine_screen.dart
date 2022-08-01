import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medicine_reminder_list/screens/payload_screen.dart';
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
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _countDays = TextEditingController();
  final _countTimes = TextEditingController();
  final _startHour = TextEditingController();
  final _startMinut = TextEditingController();

  File? _pickedImagePath;
  @override
  Widget build(BuildContext context)
  {
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
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)return 'Field is required';
                          },
                          decoration: const InputDecoration(
                            labelText: 'Title',
                          ),
                          controller: _titleController,
                        ),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)return 'Field is required';
                          },
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          controller: _descController,
                        ),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)return 'Field is required';
                          },
                          keyboardType: TextInputType.number,
                          controller: _countDays,
                          decoration: InputDecoration(
                            labelText: 'Count Days'
                          ),
                        ),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)return 'Field is required';
                          },
                          keyboardType: TextInputType.number,
                          controller: _countTimes,
                          decoration: const InputDecoration(
                            labelText: 'Count Times per Day'
                          ),
                        ),

                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)return 'Field is required';
                          },
                          keyboardType: TextInputType.number,
                          controller: _startHour,
                          decoration: const InputDecoration(
                              labelText: 'When to start'
                          ),
                        ),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)return 'Field is required';
                          },
                          keyboardType: TextInputType.number,
                          controller: _startMinut,
                          decoration: const InputDecoration(
                              labelText: 'When to start'
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    // NotificationApi.showScheduleNotification(
                    //     title: 'schedule notification',
                    //     body: 'Body for schedule notification',
                    //     payload: 'Payload',
                    //     scheduleDate: DateTime.now().add(Duration(seconds: 12))
                    // );
                    if(_key.currentState!.validate())_saveMedicine();
                  },
                  child: Text('+ Add Medicine'),
                ),
              ],
            ),
          ),
        ));
  }

  void _selectedImage(File pickedImagePath)
  {
    log('AddMedicineScreen._selectedImage');
    _pickedImagePath = pickedImagePath;
  }

  void _saveMedicine()
  {
    if(_titleController.text.isEmpty)return;
    Provider.of<MedicineData>(context, listen: false).addMedicine(
      pickedDesc: _descController.text,
      pickedName: _titleController.text,
      pickedImagePath: _pickedImagePath!,
      pickedCountDays: _countDays.text,
      pickedCountTimes: _countTimes.text,
      pickedStartHour: _startHour.text,
      pickedStartMinut: _startMinut.text,
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
