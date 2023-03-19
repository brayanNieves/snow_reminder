import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sow_remember/commons/custom_loading.dart';
import 'package:sow_remember/routers.dart';
import 'package:sow_remember/screen/home_menu.dart';
import 'package:sow_remember/screen/notes/create_note_screen.dart';
import 'package:sow_remember/screen/word_list.dart';
import 'package:sow_remember/service/user_service.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    'Mis notas',
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 34.0),
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Notes')
                      .where('user_id', isEqualTo: UserService.getUserId())
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return const Expanded(
                          child: Center(child: CircularProgressIndicator()));
                    }
                    List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                    if (data.isEmpty) {
                      return const Expanded(
                          child: Center(
                              child: Text(
                        'No tienes notas',
                        style: TextStyle(fontSize: 18.0),
                      )));
                    }
                    return Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, int index) {
                          QueryDocumentSnapshot note = data[index];
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateNoteScreen(
                                            note: note.get('Note'),
                                            noteId: note.id,
                                          )));
                            },
                            leading: IconButton(
                              icon: Icon(
                                note.get('status') == 'Pendiente'
                                    ? Icons.radio_button_off
                                    : Icons.radio_button_checked,
                                color: note.get('status') == 'Pendiente'
                                    ? Colors.white
                                    : Colors.green,
                                size: 30.0,
                              ),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('Notes')
                                    .doc(note.id)
                                    .update({
                                  'status': note.get('status') == 'Completada'
                                      ? 'Pendiente'
                                      : 'Completada'
                                });
                              },
                            ),
                            title: Text(
                              note.get('Note'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(note.get('date')),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Badge(
                                  label: Text(note.get('status')),
                                  backgroundColor:
                                      note.get('status') == 'Pendiente'
                                          ? Colors.orange
                                          : Colors.green,
                                  largeSize: 20,
                                )
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () =>
                                  confirmDeleteBottomSheet(context, note.id),
                            ),
                          );
                        },
                        separatorBuilder: (context, int index) {
                          return const Divider();
                        },
                        itemCount: data.length,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, Routers.newNote),
          child: Row(
            children: const [
              Icon(
                Icons.add,
                size: 35.0,
              ),
              Text(
                'Nueva nota',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> confirmDeleteBottomSheet(
      BuildContext context, String id) async {
    dynamic value = await showModalBottomSheet(
      context: context,
      // backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBottomSheetLine(),
              const Text(
                '¡Ups!',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '¿Deseas eliminar esta nota, al eliminarla no podras recuperarla?',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BuildCustomButton(
                      color: Colors.redAccent,
                      widget: const Text(
                        'Eliminar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('Notes')
                            .doc(id)
                            .delete()
                            .then((value) => Navigator.pop(context));
                      },
                    ),
                    BuildCustomButton(
                        color: Colors.orange,
                        widget: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    return value;
  }
}
