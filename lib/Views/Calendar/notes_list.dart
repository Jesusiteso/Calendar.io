import 'package:Calendar_io/BLoC/Calendar/firestore_ducntion_notes.dart';
import 'package:Calendar_io/Views/Calendar/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotesList extends StatefulWidget {
  NotesList({Key key}) : super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  TextEditingController _notesTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirestoreConectionsNotes _conecction = FirestoreConectionsNotes(context);

    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(),
      backgroundColor: Colors.deepPurple,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Positioned(
                    child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/planets.png'),
                    fit: BoxFit.fill,
                  )),
                )),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              'Notes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
          DraggableScrollableSheet(
            maxChildSize: 0.85,
            builder: (BuildContext context, ScrollController scrollController) {
              return Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: FutureBuilder(
                          future: _conecction.getAllNotes(),
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Text(
                                  'Loading',
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            } else {
                              if (snapshot.data != null) {
                                return ListView.builder(
                                  controller: scrollController,
                                  itemCount: snapshot.data.docs.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return Container(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, left: 20),
                                          child: Text('Board',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                      );
                                    }
                                    index -= 1;

                                    return GestureDetector(
                                      onDoubleTap: () async {
                                        _notesTextController.text = snapshot
                                            .data.docs[index]
                                            .get('note');

                                        await showModalBottomSheet(
                                          context: context,
                                          builder: (context) => StatefulBuilder(
                                              // para refrescar la botton sheet en caso de ser necesario
                                              builder:
                                                  (context, setModalState) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                top: 24.0,
                                                left: 24,
                                                right: 24,
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      "Udate Note",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 24,
                                                    ),
                                                    TextField(
                                                      controller:
                                                          _notesTextController,
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.text_fields,
                                                          color: Colors.black,
                                                        ),
                                                        labelText: "Tell me",
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black87),
                                                        border:
                                                            OutlineInputBorder(),
                                                        focusedBorder:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                    SizedBox(height: 12),
                                                    MaterialButton(
                                                      child: Text("Update"),
                                                      onPressed: () {
                                                        if (_notesTextController
                                                                .text !=
                                                            '') {
                                                          _conecction.updateTask(
                                                              snapshot.data
                                                                  .docs[index]
                                                                  .get('uuid'),
                                                              _notesTextController
                                                                  .text);
                                                          _notesTextController
                                                              .clear();
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 24,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                              // _bottomSheet(context, setModalState),
                                              ),
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              topRight: Radius.circular(15.0),
                                            ),
                                          ),
                                        ).then(
                                          (result) {
                                            if (result != null) {
                                              // TODO: add notes
                                            }
                                          },
                                        );
                                      },
                                      child: Dismissible(
                                        key: UniqueKey(),
                                        background: Container(
                                          color: Colors.indigo,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: ListTile(
                                          subtitle: Text(
                                            snapshot.data.docs[index]
                                                .get('note'),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black),
                                          ),
                                          trailing: Icon(
                                            CupertinoIcons.news,
                                            color: Colors.green,
                                            size: 30,
                                          ),
                                        ),
                                        onDismissed: (direction) {
                                          _conecction.deleteNote(snapshot
                                              .data.docs[index]
                                              .get('uuid'));
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text("No events found.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      )),
                                );
                              }
                            }
                          })
                      /*
                    ListView.builder(
                      controller: scrollController,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            color: Colors.indigo,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              "Note no $index",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            trailing: Icon(
                              CupertinoIcons.news,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                        );
                      },
                    ),*/
                      ),
                  Positioned(
                    top: -20,
                    right: 30,
                    child: FloatingActionButton(
                      onPressed: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) => StatefulBuilder(
                              // para refrescar la botton sheet en caso de ser necesario
                              builder: (context, setModalState) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: 24.0,
                                left: 24,
                                right: 24,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Add Note",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    TextField(
                                      controller: _notesTextController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.text_fields,
                                          color: Colors.black,
                                        ),
                                        labelText: "Tell me",
                                        labelStyle:
                                            TextStyle(color: Colors.black87),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    MaterialButton(
                                      child: Text("Save"),
                                      onPressed: () {
                                        if (_notesTextController.text != '') {
                                          _conecction.addTodoTask(
                                              _notesTextController.text);
                                          _notesTextController.clear();
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                              // _bottomSheet(context, setModalState),
                              ),
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                          ),
                        ).then(
                          (result) {
                            if (result != null) {
                              // TODO: add notes
                            }
                          },
                        );
                      },
                      backgroundColor: Colors.pinkAccent,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _bottomSheet(BuildContext context, StateSetter setModalState) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24.0,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Add Note",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            TextField(
              controller: _notesTextController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.text_fields,
                  color: Colors.black,
                ),
                labelText: "Tell me",
                labelStyle: TextStyle(color: Colors.black87),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            MaterialButton(
              child: Text("Save"),
              onPressed: () {
                Navigator.of(context).pop();
                _notesTextController.clear();
              },
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
