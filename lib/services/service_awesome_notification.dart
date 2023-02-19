import 'package:awesome_notifications/awesome_notifications.dart';

notificationService(String title, String body) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'test_key',
      title: title,
      body: body,
      wakeUpScreen: true,
    ),
  );
  // AwesomeNotifications().isNotificationAllowed().then(
  //       (value) => {
  //         if (!value)
  //           {
  //             print('inside notification if statement'),
  //             AwesomeNotifications().requestPermissionToSendNotifications()
  //           }
  //         else
  //           {
  //             print('inside notification else statement with $title and $body'),
  //             AwesomeNotifications().createNotification(
  //               content: NotificationContent(
  //                   id: 10,
  //                   channelKey: 'test_key',
  //                   title: title,
  //                   body: body,
  //                   wakeUpScreen: true),
  //             ),
  //           }
  //       },
  //     );
}
