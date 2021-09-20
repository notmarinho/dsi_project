// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  EditScreen({Key? key, required this.newPairValue}) : super(key: key);

  late String newPairValue;
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Pair'),
        ),
        body:
        
         Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            initialValue: widget.newPairValue,
            autofocus: true,
            onChanged: (String value) {
              widget.newPairValue = value;
            },
          ),
        ));
  }
}
