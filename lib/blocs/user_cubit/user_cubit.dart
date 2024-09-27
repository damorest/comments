import 'package:bloc/bloc.dart';
import 'package:comments/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserState extends Equatable {
  final List<UserModel> users;

  const UserState({this.users = const []});

  @override
  List<Object?> get props => [users];
}

class UserCubit extends Cubit<UserState> {
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref().child('users');

  UserCubit() : super(const UserState());

  Future<void> fetchUsers() async {
    _userRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final List<UserModel> users = data.entries.map((entry) {
          return UserModel.fromMap(entry.value);
        }).toList();

        emit(UserState(users: users));
      }
    });
  }

  // void updateUser(UserModel user) {
  //   bool isAdmin = user.isAdmin;
  //   emit(UserState(user: user, isAdmin: isAdmin));
  // }


  void clearUser(User user) {
    emit(const UserState());
  }

}