import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:habla/widget/chat_mensagens.dart';
import 'package:habla/widget/lembrete.dart';
import 'package:habla/widget/nova_mensagem.dart';
import 'package:logger/logger.dart';

final chaveDeNavegacao = GlobalKey<NavigatorState>();

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var notificacoesLocais = FlutterLocalNotificationsPlugin();

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    final confNotificacao = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final log = Logger();

    log.i('PERMISSÃO USUÁRIO: ${confNotificacao.authorizationStatus}');

    final tokenUsuario = await fcm.getToken();

    log.i('TOKEN: $tokenUsuario');

    fcm.subscribeToTopic('chat');

    //Quando esta em foco
    FirebaseMessaging.onMessage.listen(processarNotificacao);

    //Quando esta em background
    FirebaseMessaging.onMessageOpenedApp.listen(processarNotificacao);
  }

  void setupLocalNotification() async {
    const AndroidInitializationSettings cfgAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const cfgiOs = DarwinInitializationSettings();

    var initializationSettings =
        const InitializationSettings(android: cfgAndroid, iOS: cfgiOs);

    await notificacoesLocais.initialize(initializationSettings,
        onDidReceiveNotificationResponse: funcaoRespostaDaNotificacao);
  }

  void funcaoRespostaDaNotificacao(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      Logger().i('notification payload: $payload');
    } else {
      Logger().i('funcaoRespostaDaNotificacao');
    }

    chaveDeNavegacao.currentState?.pushNamed('/aviso', arguments: payload);
  }

  @override
  void initState() {
    super.initState();

    setupPushNotification();
    setupLocalNotification();
  }

  void processarNotificacao(RemoteMessage? msg) {
    //Quando tocar na notificação
    //Se tipo = aviso: Abre a tela resumoNotificacao.dart
    //Se não: abre o app na sua tela principal
    if (msg?.data['tipo'] == 'aviso') {
      chaveDeNavegacao.currentState?.pushNamed('/aviso', arguments: msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le Chat'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: MensagemChat(),
          ),
          NovaMensagem(),
          Lembrete(),
        ],
      ),
    );
  }
}
