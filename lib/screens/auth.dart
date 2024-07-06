import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habla/widget/capturar_imagem.dart';

final _firebase = FirebaseAuth.instance;

class AuthScrren extends StatefulWidget {
  const AuthScrren({super.key});

  @override
  State<AuthScrren> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScrren> {
  final _form = GlobalKey<FormState>();

  var _estaLogado = true;
  var _email = "";
  var _senha = "";
  var _nome = "";
  File? _imagemSelecionada;

  var _estaAutenticado = false;

  void _submit() async {
    final formValido = _form.currentState!.validate();
    if (!formValido) {
      return;
    }

    if (!_estaLogado && _imagemSelecionada == null) {
      return;
    }
    _form.currentState!.save();

    try {
      setState(() {
        _estaAutenticado = true;
      });
      if (_estaLogado) {
        final credenciaisUsuario = await _firebase.signInWithEmailAndPassword(
            email: _email, password: _senha);
        // print(credenciaisUsuario);
      } else {
        // autenticação via SDK Firebase
        final credenciaisUsuario =
            await _firebase.createUserWithEmailAndPassword(
          email: _email,
          password: _senha,
        );
        // print(credenciaisUsuario);

        final localArmazenamento = FirebaseStorage.instance
            .ref()
            .child("imagem_usuario")
            .child("${credenciaisUsuario.user!.uid}.jpg");
        await localArmazenamento.putFile(_imagemSelecionada!);
        final urlImagem = await localArmazenamento.getDownloadURL();

        print(urlImagem);

        FirebaseFirestore.instance
            .collection('usuarios')
            .doc(credenciaisUsuario.user!.uid)
            .set({
          'username': _nome,
          'email': _email,
          'image_url': urlImagem,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "email-already-in-use") {
        //..
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? "Falha na autenticação."),
      ));
      setState(() {
        _estaAutenticado = false;
      });
    }
    // if (formValido) {
    //   print(_email);
    //   print(_senha);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset("assets/images/chat.png"),
              ),
              Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!_estaLogado)
                              ImageUsuarioPicker(
                                imagemSelecionada: (imagemcarregada) {
                                  _imagemSelecionada = imagemcarregada;
                                },
                              ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "E-mail",
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains("@")) {
                                  return "Insira um e-mail válido";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _email = value!;
                              },
                            ),
                            if (!_estaLogado)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Nome",
                                ),
                                enableSuggestions: false,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.trim().length < 2) {
                                    return "Insira um nome";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _nome = value!;
                                },
                              ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Senha",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return "Senha deve ter pelo menos 6 caracteres";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _senha = value!;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            if (_estaAutenticado)
                              const CircularProgressIndicator(),
                            if (!_estaAutenticado)
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                child: Text(
                                    _estaLogado ? "Logar" : "Cadastrar-se"),
                              ),
                            if (!_estaAutenticado)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _estaLogado = !_estaLogado;
                                  });
                                },
                                child: Text(_estaLogado
                                    ? "Criar uma conta"
                                    : 'Fazer login'),
                              )
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
