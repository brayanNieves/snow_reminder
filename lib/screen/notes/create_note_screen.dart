import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sow_remember/commons/custom_loading.dart';
import 'package:sow_remember/service/user_service.dart';
import 'package:intl/intl.dart' as time;

class CreateNoteScreen extends StatefulWidget {
  final String noteId;
  final String note;

  const CreateNoteScreen({Key? key, this.noteId = '', this.note = ''})
      : super(key: key);

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _txtNote = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _txtNote.text = widget.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(widget.noteId.isEmpty ? 'Crear nota' : 'Editar nota'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _txtNote,
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: true,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nota',
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
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.noteId.isEmpty) {
                          CustomLoading.show(context);
                          Future.delayed(const Duration(seconds: 1), () {
                            var date = time.DateFormat("dd/MM/y h:mm a")
                                .format(DateTime.now());
                            CustomLoading.close(context);
                            FirebaseFirestore.instance
                                .collection('Notes')
                                .doc()
                                .set({
                              'Note': _txtNote.text,
                              'user_id': UserService.getUserId(),
                              'status': 'Pendiente',
                              'date': date,
                            }).then((value) {
                              _txtNote.clear();
                              final snackBar = SnackBar(
                                content: const Text(
                                  'Nota guardada',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                behavior: SnackBarBehavior.floating,
                              );
                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            });
                          });
                        } else {
                          FirebaseFirestore.instance
                              .collection('Notes')
                              .doc(widget.noteId)
                              .update({
                            'Note': _txtNote.text,
                          }).then((value) {
                            Navigator.pop(context);
                            final snackBar = SnackBar(
                              content: const Text(
                                'Nota editada',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              behavior: SnackBarBehavior.floating,
                            );
                            // Find the ScaffoldMessenger in the widget tree
                            // and use it to show a SnackBar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 17.0))),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Guardar'),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
