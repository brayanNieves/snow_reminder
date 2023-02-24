import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sow_remember/commons/custom_loading.dart';
import 'package:sow_remember/service/user_service.dart';

class CreateWordScreen extends StatefulWidget {
  const CreateWordScreen({Key? key}) : super(key: key);

  @override
  State<CreateWordScreen> createState() => _CreateWordScreenState();
}

class _CreateWordScreenState extends State<CreateWordScreen> {
  late TextEditingController _wordController;
  late TextEditingController _meaningController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  bool submit = false;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController();
    _meaningController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text('Crear palabras & significados'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _wordController,
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Palabra o frase',
                  ),
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return '***Campo requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: _meaningController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Significado',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Oración',
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
                          FirebaseFirestore.instance
                              .collection('WordMeaning')
                              .doc()
                              .set({
                            'word': _wordController.text,
                            'meaning': _meaningController.text,
                            'description': _descriptionController.text,
                            'user_id': UserService.getUserId()
                          }).then((value) {
                            _descriptionController.clear();
                            _meaningController.clear();
                            _wordController.clear();
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
                      child: Text(submit ? 'Guardando' : 'Guardar'),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
