import 'package:flutter/material.dart';
import 'package:quick_notes/src/models/Note.dart';
import 'package:quick_notes/src/utils/DatabaseHelper.dart';

import 'EditNote.dart';
import 'HomeScreen.dart';

class NoteDetails extends StatefulWidget {
  final Note note;

  NoteDetails(this.note);

  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  DatabaseHelper db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNote(widget.note),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteNote(widget.note);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15.0,
          ),
          Text(
            widget.note.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(widget.note.body)
        ],
      ),
    );
  }

  _deleteNote(Note note) {
    try {
      db.deleteNote(note).then((value) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Note deleted successfully!"),
                content: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                        child: Text('OK'),
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }),
                  ],
                ),
              );
            });
      });
    } catch (e) {
      print("Deletion error:" + e);
    }
  }
}
