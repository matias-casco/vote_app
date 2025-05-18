import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:vote_app/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    socketService.socket.on('message', (data) {
      print('Event received: $data');
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          socketService.socket.emit('flutter', {'message': 'Hello from Flutter'});
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Status Page'),
            Text(socketService.serverStatus.toString()),
          ],
        ),
      ),
    );
  }
}
