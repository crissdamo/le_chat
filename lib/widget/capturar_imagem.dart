import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUsuarioPicker extends StatefulWidget {
  const ImageUsuarioPicker({super.key, required this.imagemSelecionada});

  final void Function(File imagemCarregada) imagemSelecionada;

  @override
  State<ImageUsuarioPicker> createState() {
    return _ImageUsuarioPickerState();
  }
}

class _ImageUsuarioPickerState extends State<ImageUsuarioPicker> {
  File? _arquivoImagemCarregada;
  void _imagemCarregada() async {
    final imagemCarregada = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 20, maxWidth: 150);

    if (imagemCarregada == null) {
      return;
    }

    setState(() {
      _arquivoImagemCarregada = File(imagemCarregada.path);
    });

    widget.imagemSelecionada(_arquivoImagemCarregada!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _arquivoImagemCarregada != null
              ? FileImage(_arquivoImagemCarregada!)
              : null,
        ),
        TextButton.icon(
            onPressed: _imagemCarregada,
            icon: Icon(Icons.image),
            label: Text(
              "Adicionar imagem",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ))
      ],
    );
  }
}
