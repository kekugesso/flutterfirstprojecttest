import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Map<String, String> loadData() {
  final jsonData = window.localStorage['myData'];
  if (jsonData != null) {
    final Map<String, dynamic> jsonMap = json.decode(jsonData);
    return jsonMap.map((key, value) => MapEntry(key.toString(), value.toString()));
  } else {
    return {};
  }
}
hello
void saveData(Map<String, String> data) {
  final jsonData = json.encode(data);
  window.localStorage['myData'] = jsonData;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        dividerColor: Colors.black26,
        primaryColor: const Color.fromARGB(255, 52, 146, 223),
        scaffoldBackgroundColor: const Color.fromARGB(255, 162, 212, 217),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Color.fromARGB(255, 59, 58, 58),
          ),
          labelSmall: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromARGB(255, 43, 43, 43),
          )
        ),
      ),
      home: const ListNotes(title: 'Notes list'),
    );
  }
}

class ListNotes extends StatefulWidget {
  const ListNotes({super.key, required this.title});

  final String title;

  @override
  State<ListNotes> createState() => _ListNotesState();
}

class _ListNotesState extends State<ListNotes> {
  Map<String, String> _notes = {};
  
  

  @override
  Widget build(BuildContext context) {
    setState(() {
      _notes = loadData();
    });
    List<String> _keys = _notes.keys.toList();
    List<String> _values = _notes.values.toList();
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.bookmark),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Colors.black,
        ),
        ),
      ),
      body: ListView.separated(
        itemCount: _notes.length,
        separatorBuilder: (context, index) => Divider(
          color: const Color.fromARGB(66, 0, 0, 0),
        ),
        itemBuilder: (context, index) => ListTile(
            title: Text(
              _keys[index],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text(
              _values[index],
              style: Theme.of(context).textTheme.labelSmall,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              TextEditingController _editController = TextEditingController(text: _keys[index]);
                              TextEditingController _editController2 = TextEditingController(text: _values[index]);
                              return AlertDialog(
                                title: const Text("Edit note"),
                                content: SingleChildScrollView(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [  TextField(
                                  maxLines: null,
                                  controller: _editController,
                                  ),
                                  const SizedBox(height: 16.0),
                                  TextField(
                                  maxLines: null,
                                  controller: _editController2,
                                  ),
                                  ]
                                ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        _notes.remove(_keys[index]);
                                        _notes[_editController.text] = _editController2.text;
                                      });
                                      saveData(_notes);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Save"),
                                  ), 
                                ], 
                              );
                            }, 
                          ); 
                        },  
                      ),  
                    IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete"),
                            content: const Text("Are you sure?"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    _notes.remove(_keys[index]);
                                  });
                                  saveData(_notes);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Yes"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, 
                                child: const Text("No"),
                              )
                            ],
                          );
                        },
                      );
                  }
                ),
            ],    
          ),
        ),
      

      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateNote(),
          ),
        );
        if (result != null) {
          setState(() {
            _notes[result[0]] = result[1];
          });
          saveData(_notes);
        }
      },
      tooltip: "Add note",
      child: const Icon(Icons.add),
      backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}


class CreateNote extends StatefulWidget {
  const CreateNote({super.key});
  @override
  _CreateNoteState createState() => _CreateNoteState();
}
class _CreateNoteState extends State<CreateNote>{
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Creating new note",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Colors.black,
        ),),
        
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              maxLines: null,
              controller: _controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write title of your note",
                  fillColor: Colors.white30,
                  filled: true,
                ),
              ),
              SizedBox(height: 16.0),
            TextField(
              maxLines: null,
              controller: _controller2,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write subtitle of your note",
                  fillColor: Colors.white30,
                  filled: true,
                ),
              ),
          ]
            )
            ),
        
       bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context, [_controller.text, _controller2.text]);
              _controller.text = "";
              _controller2.text = "";
            },
            child: Text(
              'Submit',
              style: Theme.of(context).textTheme.bodyMedium,),
          ),
        )
       )
    );
  }
  
}
