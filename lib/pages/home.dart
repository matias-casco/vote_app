import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:vote_app/models/option.dart';
import 'package:vote_app/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Option>? options;

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-options', _handleActiveOptions);

    super.initState();
  }

  void _handleActiveOptions(dynamic data) {
    this.options =
        (data as List).map((option) => Option.fromMap(option)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.off('active-options');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Options', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child:
                socketService.serverStatus == ServerStatus.online
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.do_disturb_alt_outlined, color: Colors.red),
          ),
        ],
      ),
      body:
          options == null
              ? Center(child: CircularProgressIndicator())
              : options!.isEmpty
              ? Center(child: Text('No options yet'))
              : Column(
                children: [
                  _showGraph(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: options!.length,
                      itemBuilder: (context, i) => _optionTile(options![i]),
                    ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewOption,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};

    for (var option in options!) {
      dataMap.putIfAbsent(option.name, () => option.votes!.toDouble());
    }

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        legendOptions: LegendOptions(
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: true,
          decimalPlaces: 0,
        ),
      ),
    );
  }

  Widget _optionTile(Option option) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(option.id),
      direction: DismissDirection.startToEnd,
      onDismissed:
          (_) => socketService.socket.emit('delete-option', {'id': option.id}),
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
          backgroundColor: Colors.blue[100],
          child: Text(option.name.substring(0, 2)),
        ),
        title: Text(option.name),
        trailing: Text('${option.votes}', style: TextStyle(fontSize: 20)),
        onTap:
            () => socketService.socket.emit('vote-option', {'id': option.id}),
      ),
    );
  }

  addNewOption() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      // Android
      return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('New option name:'),
            content: TextField(controller: textController),
            actions: <Widget>[
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addOptionToList(textController.text),
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
          title: Text('New option name:'),
          content: CupertinoTextField(controller: textController),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => addOptionToList(textController.text),
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
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-option', {'name': name});
      setState(() {});
    }

    Navigator.pop(context);
  }
}
