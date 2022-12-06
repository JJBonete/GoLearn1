import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class ProgressNotifier extends ChangeNotifier {
  String extra = " ";

  setExtra({required String extra}) {
    this.extra = extra;
    notifyListeners();
  }
}
