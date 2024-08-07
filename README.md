# habla

A new Flutter project.


## Apresentação:
A atividade foi feita com base nas bibliotecas descritas a baixo e no curso "A Complete Guide to the Flutter SDK &amp; Flutter Framework for building native iOS and Android apps", ministrado por Maximilian Schwarzmüller. 


## Funcionalidades
* Criação de conta
* login
* envio de mensagem
* lista de mensagens do chat
* recebimento de notificação local
* recebimento de notificação remota


## observações:
Foi utilizado os seguintes recursos Firebase:
- autenticação: Authentication
- repositório de arquivo (imagem do perfil do contato): Storage
- banco de dados para armazenamento dos dados do usuário e das mensagens: Firebase DataBase
- envio de mensagem push: Messaging
- registrar função para enviar mensagem push quando uma mensagem no chat é criada: Functions


## Bibliotecas instaladas

* logger
> flutter pub add logger
### Referência:
https://pub.dev/packages/logger


* firebase
> flutter pub add firebase_core
> flutter pub add firebase_auth
> flutter pub add firebase_storage

### Referencias:
https://firebase.google.com/docs/auth/flutter/start?hl=pt
https://firebase.google.com/docs/storage/flutter/start?hl=pt


* image
> flutter pub add image_picker

### Referencias:
https://pub.dev/packages/image_picker


* armazenamento
> flutter pub add cloud_firestore

### Referencias:
https://firebase.flutter.dev/docs/firestore/overview/


* push notification
> flutter pub add firebase_messaging

### Referencias:
https://firebase.google.com/docs/cloud-messaging/flutter/client?hl=pt-br



* firebase npm
> npm install -g firebase-tools
> firebase init
> firebase deploy


* notificacao local
> flutter pub add flutter_local_notifications
### Referência:
https://pub.dev/packages/flutter_local_notifications

* alarm manager
> flutter pub add android_alarm_manager_plus
### Referência:
https://pub.dev/packages/android_alarm_manager_plus
