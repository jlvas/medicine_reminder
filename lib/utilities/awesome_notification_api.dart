import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
class AwesomeNotificationApi{

  static void initNotification(){
    AwesomeNotifications().initialize(
      'resource://drawable/ic_car_repair',
        [
          NotificationChannel(
            icon: 'resource://drawable/ic_car_repair',
            channelKey: 'schedule_notification',
            channelName: 'Schedule Notification',
            defaultColor: Colors.black,
            channelDescription: 'desc channel',
            channelShowBadge: true,
            importance: NotificationImportance.Max,
          )
        ]
    );
  }

  static Future<void> scheduleNotification() async{
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 4,
          channelKey: 'schedule_notification',
          title: 'Test notification title',
          body: 'notification body',
          notificationLayout: NotificationLayout.Default,
        ),
      actionButtons: [
        NotificationActionButton(key: 'DONE', label: 'Done'),
      ],
      schedule: NotificationCalendar(
        weekday: 7,
        hour: 20,
        minute:53 ,
        second: 0,
        millisecond: 0,
      ),

    );
  }
}