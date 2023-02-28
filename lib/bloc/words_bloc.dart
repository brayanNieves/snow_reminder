import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sow_remember/models/word_model.dart';

import '../service/user_service.dart';

class WordBloc with ChangeNotifier {
  bool loading = true;
  List<WordModel> words = [];
  List<WordModel> _firstList = [];

  void getWords() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('WordMeaning')
        .where('user_id', isEqualTo: UserService.getUserId())
        .get();
    if (querySnapshot.size > 0) {
      words = querySnapshot.docs
          .map((e) => WordModel(
              id: e.id,
              word: e.get('word'),
              meaning: e.get('meaning'),
              desc: e.get('description')))
          .toList();
      words = words
        ..sort((a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()));
      _firstList = words;
    }
    loading = false;
    notifyListeners();
  }

  void deleteWord(String id, BuildContext context, int index) {
    Future.delayed(const Duration(seconds: 1), () {
      FirebaseFirestore.instance
          .collection('WordMeaning')
          .doc(id)
          .delete()
          .then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        words.removeAt(index);
        notifyListeners();
      });
    });
  }

  void filterWord(String query) {
    if (query.trim().isEmpty) {
      words = _firstList;
      notifyListeners();
      return;
    }
    words = words
        .where((element) =>
            element.desc.toLowerCase().contains(query.toLowerCase()) ||
            element.meaning.toLowerCase().contains(query.toLowerCase()) ||
            element.word.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
