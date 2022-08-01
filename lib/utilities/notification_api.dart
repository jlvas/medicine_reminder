import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import '../models/medicine.dart';
import '../models/reminder.dart'; //show scheduled notifications

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications =
      BehaviorSubject<String?>(); // it came from rxdart plugin

  static Future<void> showNotification(
      {int id = 2, String? title, String? body, String? payload}) async {
    _notification.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static Future<void> showScheduleNotification(
      {
        // int id = 2,
        // String? title,
        // String? body,
        // String? payload,
        // required DateTime scheduleDate
        required Reminder reminder,
        required Medicine medicine,
      }) async {
    _notification.zonedSchedule(
      reminder.dateAndTime~/10000,
      medicine.name,
      medicine.desc,
      // reminder.dateAndTime~/4,
      // medicine.name,
      // medicine.desc,
      // tz.TZDateTime.from(DateTime.fromMillisecondsSinceEpoch(reminder.dateAndTime),tz.local),
      tz.TZDateTime.from(DateTime.fromMillisecondsSinceEpoch(reminder.dateAndTime),tz.local),
      await _notificationDetails(),
      payload: medicine.name,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  static Future<void> scheduleNotificationDaily(
      {int id = 2,
        String? title,
        String? body,
        String? payload,
        required DateTime scheduleDate}) async {
    _notification.zonedSchedule(
        id,
        title,
        body,
        _scheduleDaily(Time(80)),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,// schedule for every day. it could be done weekly as well
    );
  }

  static tz.TZDateTime _scheduleDaily(Time time){
    final now = tz.TZDateTime.now(tz.local); // current day time
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,time.minute, time.second,
    );

    return scheduledDate.isBefore(now) // check if it not on the past already
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }

  static Future<NotificationDetails> _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'id',
        'name',
        channelDescription: 'description',
        importance: Importance.max,
        icon: '@drawable/ic_car_repair',
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future<void> init({bool initSchedule = true}) // set the initSchedule to true to make code commented below working
  async
  {
    tz.initializeTimeZones();// initialize the time zone.
    final android = AndroidInitializationSettings('@drawable/ic_car_repair');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(
      android: android,
      iOS: iOS,
    );
    final details = await _notification.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp)
    {
      onNotifications.add(details.payload);
    }
    await _notification.initialize(
      settings,
      onSelectNotification: (payload) async {// each time a tap on the notification, this function will be executed
        onNotifications.add(payload);
      },
    );

    ///The code below will schedule the notification to show up each 12 seconds
    ///it will be scheduled automatically do to the fact it exists on init function which is
    ///called in the first of initiating application
    ///to initialize the schedule, need to set scheduleDate to true on the argument function
    // NotificationApi.showScheduleNotification(
    //   title: 'Title',
    //   body: 'Body',
    //   payload: 'Payload',
    //   scheduleDate: DateTime.now().add(Duration(seconds: 12));
    // );
  }
}
