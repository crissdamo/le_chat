import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:habla/screens/chat.dart';
import 'package:habla/screens/resumonotificacao.dart';
import 'package:habla/screens/splash.dart';
import 'firebase_options.dart';

import 'package:habla/screens/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Le Chat',
      theme: ThemeData().copyWith(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(78, 0, 0, 0)),
      ),
      // A diferença entre o StreamBuilder e o FutureBuilder, é que o Future
      // devolve um valor ou erro, enquanto o Stream pode devolver vários
      // valores ao longo do tempo
      home: StreamBuilder(
        // FirebaseAuth.instance.authStateChanges() fica ouvindo se ocorre
        // alguma mudança sobre o estado de autenticação do usuário
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (cxt, snapshot) {
          // Mostra splash enquando carrega dados de auenticação do Firebase
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          // Se o usuário estiver logado (se snapshot.hasData tiveros dados do usuário), vai para tela de chat
          if (snapshot.hasData) {
            return const ChatScreen();
          }
          // Se não estiver logado, é direcionao para tela da conta (login ou criar conta)
          return const AuthScrren();
        },
      ),

      //Usamos a chave de navegação para que o gerenciadorpush faça o controle das rotas e não se preocupe com o contexto
      navigatorKey: chaveDeNavegacao,

      //Relaçao Chave/Tela para a navegação
      routes: {
        '/aviso': (context) => const ResumoNotificacao(),
      },
    );
  }
}
