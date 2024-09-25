import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure  extends AuthState {
  final String error;

  AuthFailure(this.error);
}
class AuthCubit extends Cubit<AuthState>{
  AuthCubit(super.initialState);

  // final FirebaseAuth _firebaseAuth;

  // AuthCubit(this._firebaseAuth) : super(AuthInitial());

  // Future<void> registeredWithEmail(String email, String password) async{
  //   emit(AuthLoading());
  //
  //   try{
  //     _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  //     emit(AuthSuccess());
  //   }catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }

}