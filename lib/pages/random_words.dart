// ignore_for_file: unnecessary_new

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'saved_words.dart';
import 'edit_screen.dart';

import '../components/list_item.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  List<WordPair> _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    CollectionReference savedWords =
        FirebaseFirestore.instance.collection('saved');

    Widget _buildRow(WordPair pair, index) {
      final alreadySaved = _saved.contains(pair);

      Future<void> favoritePair() async {
        setState(() {
          alreadySaved ? _saved.remove(pair) : _saved.add(pair);
        });
        return savedWords
            .doc(pair.asUpperCase)
            .set({
              'first': pair.first,
              'second': pair.second,
              'full': pair.asPascalCase
            })
            .then((value) => print("Word saved"))
            .catchError((error) => print('Failed to save word'));
      }

      void removePair() {
        setState(() {
          _suggestions.removeAt(index);
          if (_saved.contains(pair)) {
            _saved.remove(pair);
          }
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$pair foi excluido')));
      }

      void editPair() async {
        final newListValues = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new EditScreen(
              newPairValue: pair.asPascalCase,
              listOfPairs: _suggestions,
              index: index,
            ),
          ),
        );

        if (newListValues != null) {
          setState(() {
            _suggestions = newListValues;
          });
        }
      }

      return Dismissible(
        key: Key(pair.asPascalCase),
        onDismissed: (direction) {
          removePair();
        },
        background: Container(color: Colors.red),
        child: ListItem(
          pair: pair,
          isSaved: alreadySaved,
          edit: editPair,
          favorite: favoritePair,
        ),
      );
    }

    Widget _buildSuggestions() {
      return ListView.builder(
        // padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return const Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the
            // suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index], index);
        },
      );
    }

    void _pushSaved() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SavedWords()));
      // Navigator.of(context).push(
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) {
      //       final tiles = _saved.map(
      //         (WordPair pair) {
      //           return ListTile(
      //             title: Text(
      //               pair.asPascalCase,
      //               style: _biggerFont,
      //             ),
      //           );
      //         },
      //       );

      //       final divided = ListTile.divideTiles(
      //         context: context,
      //         tiles: tiles,
      //       ).toList();

      //       return Scaffold(
      //         appBar: AppBar(
      //           title: const Text('Saved Suggestions'),
      //         ),
      //         body: Center(
      //           child: StreamBuilder(
      //             stream: FirebaseFirestore.instance
      //                 .collection('saved')
      //                 .snapshots(),
      //             builder: (context, snapshot) {
      //               if (!snapshot.hasData) return const Text('Loading...');
      //               return ListView.builder(
      //                   itemBuilder: (context, index) => Center(
      //                         child: ListTile(
      //                           title: Text(snapshot.data.['name']),
      //                         ),
      //                       ));
      //             },
      //           ),
      //         ),
      //       );
      //     }, // ...to here.
      //   ),
      // );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            onPressed: _pushSaved,
            icon: const Icon(Icons.list),
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
