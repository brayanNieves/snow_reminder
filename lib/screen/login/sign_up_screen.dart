import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sow_remember/utils.dart';

import '../../commons/custom_loading.dart';
import '../../routers.dart';
import '../../service/user_service.dart';
import '../../snack.dart';
import '../../bloc/user_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _txtEmail;
  late TextEditingController _txtPassword;
  late TextEditingController _txtUsername;
  bool submit = false;

  @override
  void initState() {
    super.initState();
    _txtEmail = TextEditingController();
    _txtPassword = TextEditingController();
    _txtUsername = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text('Crear cuenta'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (c, b) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _txtUsername,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value.toString().trim().isEmpty) {
                            return '***Campo requerido';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nombre de usuario',
                        ),
                      ),
                      const SizedBox(
                        height: 22.0,
                      ),
                      TextFormField(
                        controller: _txtEmail,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.toString().trim().isEmpty) {
                            return '***Campo requerido';
                          } else if (!Utils.validateEmail(value.toString())) {
                            return '***Correo invalido';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(
                        height: 22.0,
                      ),
                      TextFormField(
                        controller: _txtPassword,
                        obscureText: true,
                        validator: (value) {
                          if (value.toString().trim().isEmpty) {
                            return '***Campo requerido';
                          } else if (value.toString().length < 6) {
                            return '***La contraseña debe de tener al menos 6 caracteres';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contraseña',
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              CustomLoading.show(context);
                              Future.delayed(const Duration(seconds: 1), () {
                                CustomLoading.close(context);
                                UserService()
                                    .signUp(_txtUsername.text, _txtEmail.text,
                                    _txtPassword.text)
                                    .then((value) {
                                  if (value) {
                                    context.read<UserBloc>().init();
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                        Routers.home,
                                            (Route<dynamic> route) => false);
                                  } else {
                                    SnackBarUtil.showSnackBar(
                                        context, 'Error al crear la cuenta');
                                  }
                                  setState(() {
                                    submit = false;
                                  });
                                });
                              });
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  submit ? Colors.grey : Colors.red),
                              textStyle: MaterialStateProperty.all(
                                  const TextStyle(fontSize: 17.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(!submit ? 'Crear cuenta' : 'Espere...'),
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
