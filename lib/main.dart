import 'package:flutter/material.dart';
import './screens/add_medicine_screen.dart';
import './screens/payload_screen.dart';
import './screens/set_medicine_time.dart';
import 'package:provider/provider.dart';

import './providers/medicine_data.dart';
import './screens/medicine_list_screen.dart';
import 'screens/medicine_details_screen.dart';
import 'utilities/notification_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    NotificationApi.init(initSchedule: true);
    super.initState();
  }

  void listenNotification() {
    NotificationApi.onNotifications.stream.listen(onClickNotification);
  }

  void onClickNotification(String? payload){
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PayloadScreen(payload: payload),
        )
    );
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: MedicineData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MedicineListScreen() ,
        routes:{
          AddMedicineScreen.routeName:(ctx)=> AddMedicineScreen(),
          MedicineDetailsScreen.routeName:(ctx) => MedicineDetailsScreen(),
          SetMedicineTime.routeName:(ctx) => SetMedicineTime(),
        }
      ),
    );
  }
}