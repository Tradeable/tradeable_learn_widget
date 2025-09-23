import 'package:flutter/material.dart';

class SideNavController extends ChangeNotifier {
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  void open() {
    _isVisible = true;
    notifyListeners();
  }

  void close() {
    _isVisible = false;
    notifyListeners();
  }
}
