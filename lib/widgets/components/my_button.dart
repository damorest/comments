import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget myButton({onPress, color, textColor, title}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(12),
      ),
      onPressed: onPress,
      child: Text(title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          )));
}