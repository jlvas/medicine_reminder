import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import '../models/medicine.dart';
import '../models/reminder.dart';

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  // it came from rxdart plugin


  // static Future<void> showNotification({int id = 2, String? title, String? body, String? payload}) async {
  //   _notification.show(id,
  //       title,
  //       body,
  //       await _notificationDetails(),
  //       payload: payload
  //   );
  // }

  // static Future<void> showScheduleNotification({required Reminder reminder, required Medicine medicine,}) async
  // {
  //   _notification.periodicallyShow(
  //       int.parse(reminder.dateAndTime)~/10000,
  //       medicine.name,
  //       medicine.desc ,
  //       RepeatInterval.everyMinute,
  //       await _notificationDetails()
  //   );
  //   _notification.zonedSchedule(
  //     reminder.id!,
  //     medicine.name,
  //     medicine.desc,
  //     tz.TZDateTime.from(DateTime.fromMillisecondsSinceEpoch(int.parse(reminder.dateAndTime)),tz.local),
  //     await _notificationDetails(),
  //     payload: '${reminder.medicineID}:${reminder.id}',// use the medicineID and reminder
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
  //   );
  // }

  static Future<NotificationDetails> _notificationDetails(
      {required String id, required String name, required String desc}) async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel ID',
        'Medicine Reminder',
        channelDescription: 'To remind user taking their medicine',
        importance: Importance.max,
        priority: Priority.max,
        icon: '@drawable/ic_car_repair',
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future<void> init( {bool initSchedule = true}) async// set the initSchedule to true to make code commented below working
  {

    const android = AndroidInitializationSettings('@drawable/ic_car_repair');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS,);

    /// When app is closed
    final details = await _notification.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotifications.add(details.payload);
    }

    await _notification.initialize(
      settings,
      onSelectNotification: (payload) async {// each time a tap on the notification, this function will be executed
        onNotifications.add(payload);
      },
    );

    if(initSchedule){
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static void scheduleNotification({ required String name, required String desc, required Reminder reminder,required int order})async{
    log('channel name: $name');
    if(DateTime.fromMillisecondsSinceEpoch(int.parse(reminder.dateAndTime)).isBefore(DateTime.now()))return;
    _notification.zonedSchedule(
        reminder.id!,
        '$name time# $order',
        'Time: ${(DateTime.fromMillisecondsSinceEpoch(int.parse(reminder.dateAndTime)))}\n$desc',
        tz.TZDateTime.from(DateTime.fromMillisecondsSinceEpoch(int.parse(reminder.dateAndTime)),tz.local),
        await _notificationDetails(id: reminder.id.toString(), name: name, desc: desc),
        payload: '${reminder.medicineID}:${reminder.id}',
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
    );
    // _notification.periodicallyShow(id, title, body, RepeatInterval.everyMinute, await _notificationDetails());
  }
}
