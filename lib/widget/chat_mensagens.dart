import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habla/widget/balao_mensagem.dart';

class MensagemChat extends StatelessWidget {
  const MensagemChat({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioAutenticado = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('criadoem', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text("Nenhuma mensagem encontrada"),
            );
          }
          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('Ocorreu algo de errado ao carregar as mensagens...'),
            );
          }

          final mensagensCarregadas = chatSnapshots.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 40,
              left: 13,
              right: 13,
            ),
            reverse: true,
            itemCount: mensagensCarregadas.length,
            itemBuilder: (ctx, index) {
              final chatMensagem = mensagensCarregadas[index].data();
              final proximaMensagem = index + 1 < mensagensCarregadas.length
                  ? mensagensCarregadas[index + 1].data()
                  : null;

              final UsuarioIDMensagemAtual = chatMensagem['userID'];
              final proximaMensagemUsuarioID =
                  proximaMensagem != null ? proximaMensagem['userID'] : null;

              final proximoUsuarioEIgual =
                  proximaMensagemUsuarioID == UsuarioIDMensagemAtual;

              if (proximoUsuarioEIgual) {
                return MessageBubble.next(
                    message: chatMensagem['text'],
                    isMe: usuarioAutenticado.uid == UsuarioIDMensagemAtual);
              } else {
                return MessageBubble.first(
                  userImage: chatMensagem['image_url'],
                  username: chatMensagem['username'],
                  message: chatMensagem['text'],
                  isMe: usuarioAutenticado.uid == UsuarioIDMensagemAtual,
                );
              }
            },
          );
        });
  }
}
