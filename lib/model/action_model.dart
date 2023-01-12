import 'dart:core';
import 'dart:ffi';

import 'package:flutter/widgets.dart';

class ActionModel {
  final bool call;
  final bool check;
  final bool raise;
  final bool fold;

  ActionModel(
      {required this.call,
      required this.check,
      required this.raise,
      required this.fold});

  ActionModel.fromMap(Map<dynamic, dynamic> map)
      : call = map["call"],
        check = map["check"],
        raise = map["raise"],
        fold = map["fold"];
}
