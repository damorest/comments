import 'package:bloc/bloc.dart';
import 'package:comments/consts/firebase_consts.dart';
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
  final DatabaseReference _userRef =
      dataBase.ref().child(usersCollection);

  UserCubit() : super(const UserState());

  Future<void> fetchUsers() async {
    final snapshot = await _userRef.once();
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      final List<UserModel> users = data.entries.map((entry) {
        return UserModel.fromMap(entry.value);
      }).toList();

      emit(UserState(users: users));
    } else {
      emit(UserState());
    }
  }


  UserModel? getCurrentUser() {
    try {
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        return state.users.firstWhere((user) => user.userId == currentUser.uid);
      }
      return null;
    } catch (e) {
      print('No users found');
      return null;
    }
  }

  void clearUser(User user) {
    emit(const UserState());
  }
}
