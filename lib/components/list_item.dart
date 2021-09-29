// ignore_for_file: unnecessary_new

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem(
      {Key? key,
      required this.pair,
      required this.isSaved,
      required this.edit,
      required this.favorite})
      : super(key: key);

  final WordPair pair;
  final bool isSaved;
  final Function favorite;
  final Function edit;

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        edit();
      },
      title: Text(pair.asPascalCase, style: _biggerFont),
      trailing: Column(
        children: <Widget>[
          new IconButton(
              onPressed: () {
                favorite();
              },
              color: isSaved ? Colors.red : null,
              icon: new Icon(isSaved ? Icons.favorite : Icons.favorite_border))
        ],
      ),
    );
  }
}
