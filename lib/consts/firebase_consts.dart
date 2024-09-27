import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseDatabase dataBase = FirebaseDatabase.instance;

const String usersCollection = 'users';