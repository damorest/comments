import 'package:comments/consts/firebase_consts.dart';
import 'package:comments/consts/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure  extends AuthState {
  final String error;

  AuthFailure(this.error);
}
class AuthSignOut extends AuthState {}
class AuthUserAlreadyExists extends AuthState {}
class AuthUserNotFound extends AuthState {}

class AuthCubit extends Cubit<AuthState>{
  final FirebaseAuth _auth = auth;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
  );

  AuthCubit() : super(AuthInitial());

  Future<void> registeredWithEmail(String email, String password) async{
    emit(AuthLoading());

    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      emit(AuthSuccess());
    } on FirebaseException catch (e) {
      if(e.code == firebaseExceptionUserAlreadyInUse) {
        emit(AuthUserAlreadyExists());
      }else {
        emit(AuthFailure(e.toString()));
      }
    }catch(e) {
      emit(AuthFailure('${e.toString()}'));
    }
  }

  Future<void> signInWithEmail(String email, String password) async{
    emit(AuthLoading());

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSuccess());
      
      if (userCredential.user != null) {
        emit(AuthSuccess());
      }else {
        emit(AuthFailure(userNotFound));
      }
    } on FirebaseException catch (e) {
      if(e.code == firebaseExceptionUserNotFound) {
        emit(AuthUserNotFound());
      }else {
        emit(AuthFailure(e.toString()));
      }
    }catch(e) {
      emit(AuthFailure('${e.toString()}'));
    }
  }

  Future<void> signInWithGoogle () async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        emit(AuthFailure(googleSignInFailed));
        return;
      }
        final googleAuth = await googleUser.authentication;

        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken
          );
          await _auth.signInWithCredential(credential);
          emit(AuthSuccess());

        } else {
          emit(AuthFailure(googleSignInFailed));
        }
    }on FirebaseAuthException catch (e) {
        emit(AuthFailure(e.message.toString()));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    }

  Future<void> signOut() async{
    await googleSignIn.signOut();
    await _auth.signOut();
    emit(AuthSignOut());
  }
}
