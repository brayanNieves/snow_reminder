import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sow_remember/commons/custom_loading.dart';
import 'package:sow_remember/routers.dart';
import 'package:sow_remember/utils.dart';
import '../../service/user_service.dart';
import '../../snack.dart';
import '../../bloc/user_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _txtEmail;
  late TextEditingController _txtPassword;

  bool submit = false;

  @override
  void initState() {
    super.initState();
    _txtEmail = TextEditingController();
    _txtPassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text('Iniciar sesión'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (c, b) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 22.0,
                      ),
                      // const Text(
                      //   'Snow Reminder',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //       fontSize: 32.0, fontWeight: FontWeight.w800),
                      // ),
                      // const SizedBox(
                      //   height: 22.0,
                      // ),
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
                                    .login(_txtEmail.text, _txtPassword.text)
                                    .then((value) {
                                  if (value) {
                                    context.read<UserBloc>().init();
                                    Navigator.pushReplacementNamed(
                                        context, Routers.home);
                                  } else {
                                    SnackBarUtil.showSnackBar(context,
                                        'Usuario o contraseña invalido');
                                  }
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
                            child: Text(!submit ? 'Iniciar' : 'Espere...'),
                          )),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Center(
                        child: InkWell(
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Crear cuenta'),
                          ),
                          onTap: () =>
                              Navigator.pushNamed(context, Routers.signUp),
                        ),
                      )
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
