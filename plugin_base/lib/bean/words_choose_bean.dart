import 'package:flutter/material.dart';

class WordsChooseBean{
  String words;
  GlobalKey globalKey;
  WordsChooseBean({
    required this.words,
    required this.globalKey,
});

  @override
  String toString() {
    return 'WordsChooseBean{words: $words}';
  }
}