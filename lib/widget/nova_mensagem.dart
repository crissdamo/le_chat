import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NovaMensagem extends StatefulWidget {
  const NovaMensagem({super.key});

  @override
  State<NovaMensagem> createState() {
    return _NovaMensagemState();
  }
}

class _NovaMensagemState extends State<NovaMensagem> {
  final _mensagemController = TextEditingController();

  @override
  void dispose() {
    _mensagemController.dispose();
    super.dispose();
  }

  void _enviarMensagem() async {
    final mensagem = _mensagemController.text;

    if (mensagem.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _mensagemController.clear();

    final user = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .get();

    // add método cria um id dinâmico

    FirebaseFirestore.instance.collection('chat').add({
      'text': mensagem,
      'criadoem': Timestamp.now(),
      'userID': user.uid,
      'username': userData.data()!['username'],
      'image_url': userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _mensagemController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration:
                  const InputDecoration(labelText: 'Enviar mensagem...'),
            ),
          ),
          IconButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: _enviarMensagem,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
