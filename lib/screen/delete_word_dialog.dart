import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sow_remember/bloc/words_bloc.dart';
import 'package:sow_remember/commons/custom_loading.dart';
import 'package:sow_remember/screen/home_menu.dart';
import 'package:sow_remember/screen/word_list.dart';

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
