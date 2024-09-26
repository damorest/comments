import 'package:comments/consts/firebase_consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure  extends AuthState {
  final String error;

  AuthFailure(this.error);
}
class AuthSignOut extends AuthState {}

class AuthCubit extends Cubit<AuthState>{
  final FirebaseAuth _auth = auth;

  AuthCubit() : super(AuthInitial());

  Future<void> registeredWithEmail(String email, String password) async{
    emit(AuthLoading());

    try{
      _auth.createUserWithEmailAndPassword(email: email, password: password);
      emit(AuthSuccess());
    }catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signInWithEmail(String email, String password) async{
    emit(AuthLoading());

    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSuccess());
    }catch(e) {
      emit(AuthFailure('${e.toString()}'));
    }
  }
  Future<void> signOut() async{
    await _auth.signOut();
    emit(AuthSignOut());
  }

}