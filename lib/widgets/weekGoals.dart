import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laundary_application/main.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class WeekGoal extends StatefulWidget {
  @override
  _WeekGoalState createState() => _WeekGoalState();
}

class _WeekGoalState extends State<WeekGoal> {
  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return MyApp();
    }));
  }

  Future<void> scheduleNotification(dateTime) async {
    var scheduledNotificationDateTime = dateTime;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: 'app_icon',
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'Laundry Application',
        'Please place your order.',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 170,
      height: 160,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    "SCHEDULE YOUR LAUNDRY",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
              ),
              Text("We will notify you to place your order.."),
              InkWell(
                onTap: () {
                  DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    onConfirm: (date) {
                      scheduleNotification(date);
                    },
                    currentTime: DateTime.now(),
                  );
                },
                focusColor: Colors.white,
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                        colors: [Colors.blue[200], Colors.blueAccent[700]],
                        end: Alignment.bottomRight,
                        begin: Alignment.topLeft),
                  ),
                  child: Center(
                    child: Text(
                      "SET REMINDER",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
