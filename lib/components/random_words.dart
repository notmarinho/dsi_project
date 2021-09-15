import 'dart:developer';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    Widget _buildRow(WordPair pair, index) {
      final alreadySaved = _saved.contains(pair);
      final item = _suggestions[index];

      return Dismissible(
        key: Key(item.asPascalCase),
        onDismissed: (direction) {
          setState(() {
            _suggestions.removeAt(index);
            if (_saved.contains(pair)) {
              _saved.remove(pair);
            }
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$item foi excluido')));
        },
        background: Container(color: Colors.red),
        child: ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
          ),
          onTap: () {
            setState(() {
              alreadySaved ? _saved.remove(pair) : _saved.add(pair);
            });
          },
        ),
      );
    }

    Widget _buildSuggestions() {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
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
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          // NEW lines from here...
          builder: (BuildContext context) {
            final tiles = _saved.map(
              (WordPair pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
            );

            final divided = ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList();

            return Scaffold(
              appBar: AppBar(
                title: const Text('Saved Suggestions'),
              ),
              body: ListView(children: divided),
            );
          }, // ...to here.
        ),
      );
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
