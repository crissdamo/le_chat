import 'package:flutter/material.dart';

class NovaMensagem extends StatefulWidget {
  const NovaMensagem({super.key});

  @override
  State<NovaMensagem> createState() {
    return _NovaMensagemState();
  }
}

class _NovaMensagemState extends State<NovaMensagem> {
  var _mensagemController = TextEditingController();

  @override
  void dispose() {
    _mensagemController.dispose();
    super.dispose();
  }

  void _enviarMensagem() {
    final mensagem = _mensagemController.text;

    if (mensagem.trim().isEmpty) {
      return;
    }

    // enviar pelo Firebase

    _mensagemController.clear();
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
              decoration: InputDecoration(labelText: 'Enviar mensagem...'),
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
