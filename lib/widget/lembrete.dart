import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const int idDoAlarme = 1234;
const String isolateExercicios = 'lembrete';

@pragma('vm:entry-point')
void funcaoDeExecucaoDoAlarme() async {
  var notificacoesLocais = FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails canalLembrete = AndroidNotificationDetails(
    'canal2Id',
    'Notificações lembrete',
    channelDescription: 'notificações lembrete',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: canalLembrete);

  await notificacoesLocais.show(
    10,
    'Mensagem Enviada',
    'Em: ${DateTime.now()}',
    notificationDetails,
    payload: "Este é apenas um lembrete...",
  );
}

class Lembrete extends StatelessWidget {
  const Lembrete({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              await AndroidAlarmManager.periodic(
                  const Duration(seconds: 10), 0, funcaoDeExecucaoDoAlarme);
            },
            icon: const Icon(Icons.alarm),
            label: const Text('Lembrete'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await AndroidAlarmManager.cancel(idDoAlarme);
            },
            icon: const Icon(Icons.alarm_off),
            label: const Text('Cancelar Lembrete'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
