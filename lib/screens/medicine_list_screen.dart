import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medicine_reminder_list/screens/add_medicine_screen.dart';
import 'package:medicine_reminder_list/screens/medicine_details_screen.dart';
import 'package:medicine_reminder_list/screens/payload_screen.dart';
import 'package:medicine_reminder_list/utilities/notification_api.dart';
import 'package:provider/provider.dart';

import '../providers/medicine_data.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({Key? key}) : super(key: key);

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {

  // @override
  // void initState()
  // {
  //   NotificationApi.init();
  //   // listenNotifications();
  //   super.initState();
  // }

  void listenNotifications()
  {
    NotificationApi.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload)
  {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context)=>PayloadScreen(payload: payload)),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddMedicineScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              // Provider.of<MedicineData>(context, listen: false).fetchAndSetMedicine();
              // Navigator.pushNamed(context, MedicineDetailsScreen.routeName);
              // NotificationApi.showScheduleNotification(
              //     title: 'schedule notification',
              //     body: 'Body for schedule notification',
              //     payload: 'Payload',
              //     scheduleDate: DateTime.now().add(Duration(seconds: 12))
              // );
            },
            icon: const Icon(Icons.folder_open),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<MedicineData>(context, listen: false).fetchAndSetMedicine(),
        builder: (context, data){
          if(data.connectionState == ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else {
            return Consumer<MedicineData>(
              child: const Center(
                child: Text('There is no list'),
              ),
              builder: (ctx, medicineData, ch) {
                if(medicineData.items.isEmpty){
                  // log('MedicineListScreen.build.FutureBuilder.else.medicineData isEmpty: ${medicineData.items.isEmpty}');
                  return ch!;
                }
                else
                {
                  return ListView.builder(
                    itemCount: medicineData.items.length,
                    itemBuilder: (ctx, index){
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: FileImage(medicineData.items[index].imagePath),
                        ),
                        title: Text(medicineData.items[index].name),
                        subtitle: Text(medicineData.items[index].desc),
                        onTap: (){
                          Navigator.pushNamed(context, MedicineDetailsScreen.routeName, arguments: medicineData.items[index]);
                        },
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
