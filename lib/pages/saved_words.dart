import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SavedWords extends StatefulWidget {
  const SavedWords({Key? key}) : super(key: key);

  @override
  _SavedWordsState createState() => _SavedWordsState();
}

class _SavedWordsState extends State<SavedWords> {
  final Stream<QuerySnapshot> _savedWords =
      FirebaseFirestore.instance.collection('saved').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Palavras Salvas')),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: _savedWords,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot savedWord) {
                Map<String, dynamic> data =
                    savedWord.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['full']),
                  subtitle: Text(data['second']),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
