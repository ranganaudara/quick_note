import 'package:flutter/material.dart';
import 'package:quick_notes/src/models/Note.dart';
import 'package:quick_notes/src/screens/HomeScreen.dart';
import 'package:quick_notes/src/utils/DatabaseHelper.dart';

class EditNote extends StatefulWidget {
  final Note note;

  EditNote(this.note);

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  DatabaseHelper db = DatabaseHelper();

  Map<String, dynamic> _noteDataMap;
  Note _newNote;

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    titleController.text = widget.note.title;
    bodyController.text = widget.note.body;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Note"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveNote();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,

              style: TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter title',
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: bodyController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your note here...'),
            ),
          ],
        ),
      ),
    );
  }

  _saveNote() {
    _noteDataMap = {"title": titleController.text, "body": bodyController.text};
    print(_noteDataMap);
    _newNote = Note.fromMap(_noteDataMap);
    try {
      db.addReminder(_newNote).then((value) {
        if (value > 1)
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Note added successfully!"),
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
      print("Error inserting:" + e);
    }
  }
}
