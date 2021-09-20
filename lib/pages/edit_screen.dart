// ignore_for_file: must_be_immutable
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import '../components/random_words.dart';

class EditScreen extends StatefulWidget {
  EditScreen(
      {Key? key,
      required this.newPairValue,
      required this.listOfPairs,
      required this.index})
      : super(key: key);

  late String newPairValue;
  List listOfPairs;
  int index;

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    void _pushToBack() {
      Navigator.pop(context, widget.listOfPairs);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pair'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              initialValue: widget.newPairValue,
              autofocus: true,
              onChanged: (String value) {
                setState(() {
                  widget.newPairValue = value;
                });
              },
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              var myWords = widget.newPairValue.split(' ');
              if (myWords.length > 1) {
                var firstWord = myWords[0];
                var secondWord = myWords[1];
                var toWordPair = WordPair(firstWord, secondWord);
                widget.listOfPairs[widget.index] = toWordPair;
                _pushToBack();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('O nome precisa de duas palavras!')));
              }
              // print(widget.newPairValue);
              // print(widget.listOfPairs);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }
}
