import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sow_remember/bloc/words_bloc.dart';
import 'package:sow_remember/models/word_model.dart';
import 'package:sow_remember/routers.dart';

import '../commons/custom_loading.dart';
import 'home_menu.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({Key? key}) : super(key: key);

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<WordBloc>().getWords();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, box) {
          return Column(
            children: [
              buildBottomSheetLine(),
              const Text(
                'Listado de palabras',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //       horizontal: 16.0, vertical: 12.0),
              //   child: TextField(
              //     onChanged: (value) {
              //       context.read<WordBloc>().filterWord(value);
              //     },
              //     onEditingComplete: () {
              //       print('onEditingComplete()');
              //     },
              //   ),
              // ),
              Consumer<WordBloc>(
                  builder: (BuildContext context, wordBloc, Widget? child) {
                if (wordBloc.loading) {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                } else {
                  return Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, int index) {
                            WordModel wordModel = wordBloc.words[index];
                            return ListTile(
                              title: Text(
                                wordModel.word,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text('Significado: ${wordModel.meaning}'),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                  Text('Descripción: ${wordModel.desc}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {
                                  confirmDeleteBottomSheet(
                                      context, wordModel.id, index);
                                },
                              ),
                            );
                          },
                          separatorBuilder: (context, int index) {
                            return const Divider();
                          },
                          itemCount: wordBloc.words.length,
                        ),
                      );
                }
              }),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () =>
              Navigator.popAndPushNamed(context, Routers.createWord)),
    );
  }

  Future<dynamic> confirmDeleteBottomSheet(
      BuildContext context, String id, int index) async {
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
                  '¿Deseas eliminar esta palabra o frase, al eliminarla no podras recuperarla?',
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
                        CustomLoading.show(context);
                        context.read<WordBloc>().deleteWord(id, context, index);
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

class BuildCustomButton extends StatelessWidget {
  final Color color;
  final Widget widget;
  final VoidCallback onPressed;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double padding;
  final double borderRadius;
  final Color borderSideColor;

  BuildCustomButton(
      {required this.widget,
      required this.color,
      required this.onPressed,
      this.fontWeight,
      this.fontSize,
      this.borderSideColor = Colors.transparent,
      this.padding = 0.0,
      this.borderRadius = 22.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: MaterialButton(
          color: color,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(color: borderSideColor)),
          onPressed: onPressed,
          child: Padding(padding: const EdgeInsets.all(14.0), child: widget)),
    );
  }
}
