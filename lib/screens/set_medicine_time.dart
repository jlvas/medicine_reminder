import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SetMedicineTime extends StatefulWidget {
  static const routeName = '/screens/set_medicine_time';

  const SetMedicineTime({Key? key}) : super(key: key);

  @override
  State<SetMedicineTime> createState() => _SetMedicineTimeState();
}

class _SetMedicineTimeState extends State<SetMedicineTime> {
  final TimeOfDay time = const TimeOfDay(hour: 10, minute: 50);

  bool isSelected = true;
  List<TimeOfDay?> list = [];

  @override
  Widget build(BuildContext context) {
    final times =
        int.parse(ModalRoute.of(context)!.settings.arguments as String);
    if (isSelected) {
      for (int i = 0; i < times; i++) {
        list.add(TimeOfDay.now());
        log('For Loop');
      }
      isSelected = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Time'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: times,
                itemBuilder: (ctx, index) {
                  return Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              TimeOfDay? selectedTime = await showTimePicker(
                                context: ctx,
                                initialTime: time,
                              );
                              setState(() {
                                list[index] = selectedTime;
                                isSelected = false;
                              });
                            },
                            child: const Icon(Icons.alarm)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(list[index]!.format(context)),
                      ],
                    ),
                  );
                }),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, list);
              },
              child: const Text('Submit'))
        ],
      ),
    );
  }
}
