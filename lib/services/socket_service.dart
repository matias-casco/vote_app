import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  IO.Socket? _socket;

  IO.Socket get socket => _socket!;
  ServerStatus get serverStatus => _serverStatus;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    print('initConfig');
    _socket = IO.io('http://localhost:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket!.onConnect((_) {
      _serverStatus = ServerStatus.online;
      socket.emit('message', 'New connection from Flutter');
      notifyListeners();
    });

    _socket!.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    _socket!.onConnectError((data) {
      print('connect error');
      print(data);
    });

     _socket!.on('event', (data) => print(data));

  }
}
