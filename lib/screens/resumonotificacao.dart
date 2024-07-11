import 'package:flutter/material.dart';

class ResumoNotificacao extends StatefulWidget {
  const ResumoNotificacao({super.key});

  @override
  State<ResumoNotificacao> createState() => _ResumoNotificacaoState();
}

class _ResumoNotificacaoState extends State<ResumoNotificacao> {
  @override
  Widget build(BuildContext context) {
    final String notificationMessage =
        ModalRoute.of(context)!.settings.arguments.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificação Enviada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Resumo da Notificação',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  notificationMessage,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
