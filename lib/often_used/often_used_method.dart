import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../consts/strings.dart';

void nextScreen (context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace (context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar (context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message,
        style: const TextStyle(fontSize: 14)
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 3),
    action: SnackBarAction(label: ok, onPressed: () {}, textColor: Colors.white,
    ),
  ));
}

Future<bool> hasInternetConnection() async {
  try {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  } catch (e) {
    print('$errorChecking $e');
    return false;
  }
}

