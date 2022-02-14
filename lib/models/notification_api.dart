import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';

class NotificationApi {

  // initialize the local notifications plugin
  static final _notifications = FlutterLocalNotificationsPlugin();
  // create a listener of type string to store the payload
  static final onNotifications = BehaviorSubject<String?>();

  // we want to navigate to a specific screen when clicking on a notification
  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@drawable/notifications_icon');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(
      settings,
      // onSelect is called every time you click on the notification. The payload is also passed to you.
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
    if(initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  // let's say how our notifications should look like in android
  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        priority: Priority.high,
        channelDescription: 'channel description',
        importance: Importance.max,
        icon: '@drawable/notifications_icon',
      ),
    );
  }

  // create show notifications method
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  // create show scheduled notifications method
  static void showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local), // this is used for simple scheduled notification
        // _scheduleDaily(const Time(05, 18)),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        // matchDateTimeComponents: DateTimeComponents.time, // in case you want to use daily notifications
        // matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // in case you want weekly notification
      );

  // static tz.TZDateTime _scheduleDaily(Time time) {
  //   final now = tz.TZDateTime.now(tz.local);
  //   final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute, now.second);
  //   return scheduleDate.isBefore(now) ? scheduleDate.add(const Duration(days: 1)) : scheduleDate;
  // }
  //
  // static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
  //   tz.TZDateTime scheduleDate = _scheduleDaily(time);
  //   while(days.contains(scheduleDate.weekday)) {
  //     scheduleDate = scheduleDate.add(Duration(days: 1));
  //   }
  //   return scheduleDate;
  // }

}