import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vote_app/models/option.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Option> options = [
    Option(id: '1', name: 'Metallica', votes: 5),
    Option(id: '2', name: 'Queen', votes: 1),
    Option(id: '3', name: 'Héroes del Silencio', votes: 2),
    Option(id: '4', name: 'Bon Jovi', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Options', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, i) => _optionTile(options[i]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewOption,
      ),
    );
  }

  Widget _optionTile(Option option) {
    return Dismissible(
      key: Key(option.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direction: $direction');
        print('id: ${option.id}');
        // TODO: llamar el borrado en el server
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete option', style: TextStyle(color: Colors.white)),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(option.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(option.name),
        trailing: Text('${option.votes}', style: TextStyle(fontSize: 20)),
        onTap: () {
          print(option.name);
        },
      ),
    );
  }

  addNewOption() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      // Android
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(controller: textController),
            actions: <Widget>[
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addOptionToList( textController.text )
              ),
            ],
          );
        },
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('New band name:'),
          content: CupertinoTextField(controller: textController),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => addOptionToList( textController.text )
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void addOptionToList(String name) {
    print(name);

    if (name.length > 1) {
      // Podemos agregar
      options.add(
        new Option(id: DateTime.now().toString(), name: name, votes: 0),
      );
      setState(() {});
    }

    Navigator.pop(context);
  }
}
