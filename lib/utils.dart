import 'package:flutter/material.dart';

class Utils {
  static Color getColorForSubjectType(String subjectType) {
    var color = const Color.fromRGBO(
      170,
      0,
      255,
      1.0,
    );

    if (subjectType == "radical") {
      color = const Color.fromRGBO(
        25,
        149,
        223,
        1.0,
      );
    } else if (subjectType == "kanji") {
      color = const Color.fromRGBO(
        251,
        1,
        169,
        1.0,
      );
    }

    return color;
  }

  static Color getTextFieldColorForSubjectType(String subjectType) {
    var color = const Color.fromRGBO(
      119,
      0,
      179,
      1.0,
    );

    if (subjectType == "radical") {
      color = const Color.fromRGBO(
        18,
        107,
        160,
        1.0,
      );
    } else if (subjectType == "kanji") {
      color = const Color.fromRGBO(
        178,
        1,
        120,
        1.0,
      );
    }

    return color;
  }
}
