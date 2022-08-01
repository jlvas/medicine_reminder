import 'package:flutter/material.dart';
import 'package:medicine_reminder_list/screens/add_medicine_screen.dart';
import 'package:provider/provider.dart';

import './providers/medicine_data.dart';
import './screens/medicine_list_screen.dart';
import 'screens/medicine_details_screen.dart';
import 'utilities/notification_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationApi.init(); // intialize the notification
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        }
      ),
    );
  }
}