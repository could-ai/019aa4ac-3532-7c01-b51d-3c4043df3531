import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _username = '';
  String _channel = '1';
  bool _isTransmitting = false;
  bool _isReceiving = false;

  String get username => _username;
  String get channel => _channel;
  bool get isTransmitting => _isTransmitting;
  bool get isReceiving => _isReceiving;

  void setUsername(String name) {
    _username = name;
    notifyListeners();
  }

  void setChannel(String channel) {
    _channel = channel;
    notifyListeners();
  }

  void startTransmitting() {
    _isTransmitting = true;
    notifyListeners();
  }

  void stopTransmitting() {
    _isTransmitting = false;
    notifyListeners();
  }

  // Simulation for receiving data
  void simulateIncomingTransmission(bool active) {
    _isReceiving = active;
    notifyListeners();
  }
}
