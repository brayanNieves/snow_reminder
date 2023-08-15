import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sow_remember/bloc/words_bloc.dart';
import 'package:sow_remember/commons/custom_search.dart';
import 'package:sow_remember/models/word_model.dart';

class SearchWorldScreen extends StatefulWidget {
  static const String route = '/search_word_page';

  const SearchWorldScreen({Key? key}) : super(key: key);

  @override
  State<SearchWorldScreen> createState() => _SearchWorldScreenState();
}

class _SearchWorldScreenState extends State<SearchWorldScreen> {
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: SnowEatsSearch(
          controller: _search,
          borderRadius: 12.0,
          onChanged: (String? query) =>
              context.read<WordBloc>().filterWord(query ?? ''),
        ),
        toolbarHeight: 90.0,
      ),
      body: Consumer<WordBloc>(
        builder: (BuildContext context, wordBloc, Widget? child) {
          return ListView.separated(
            padding: const EdgeInsets.only(top: 12.0),
            itemCount: wordBloc.words.length,
            itemBuilder: (BuildContext context, int index) {
              WordModel wordModel = wordBloc.words[index];
              return ListTile(
                title: Text(
                  wordModel.word,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          );
        },
      ),
    );
  }
}
