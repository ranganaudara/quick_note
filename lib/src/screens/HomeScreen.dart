import 'package:flutter/material.dart';
import 'package:quick_notes/src/models/Note.dart';
import 'package:quick_notes/src/screens/CreateNote.dart';
import 'package:quick_notes/src/utils/DatabaseHelper.dart';

import 'NoteDetails.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper db = DatabaseHelper();

  Future<List<Note>> _fetchAllNotes() async {
    List<Note> notesList;
    try {
      notesList = await db.getAllNotes();
    } catch (e) {
      print("Database error occurred : " + e);
    }
    return notesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Notes"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNote(),
            ),
          );
        },
      ),
      body: Center(
        child: FutureBuilder(
            future: _fetchAllNotes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(snapshot.data[index].title),
                            subtitle: Text(
                              snapshot.data[index].body,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NoteDetails(snapshot.data[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    });
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}
