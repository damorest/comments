import 'package:comments/consts/firebase_consts.dart';
import 'package:comments/consts/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}

class AuthSignOut extends AuthState {}

class AuthUserAlreadyExists extends AuthState {}

class AuthUserNotFound extends AuthState {}

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = auth;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
  );

  AuthCubit() : super(AuthInitial());

  Future<void> registeredWithEmail(String email, String password) async {
    emit(AuthLoading());

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await addUserToDatabase(userCredential);

      emit(AuthSuccess());
    } on FirebaseException catch (e) {
      if (e.code == firebaseExceptionUserAlreadyInUse) {
        emit(AuthUserAlreadyExists());
      } else {
        emit(AuthFailure(e.toString()));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    emit(AuthLoading());

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      emit(AuthSuccess());

      if (userCredential.user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(userNotFound));
      }
    } on FirebaseException catch (e) {
      if (e.code == firebaseExceptionUserNotFound) {
        emit(AuthUserNotFound());
      } else {
        emit(AuthFailure(e.toString()));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
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
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        final userCredential = await _auth.signInWithCredential(credential);
        await addUserToDatabase(userCredential);
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(googleSignInFailed));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message.toString()));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> addUserToDatabase(UserCredential userCredential) async {
    String userId = userCredential.user!.uid;
    String email = userCredential.user!.email ?? '';
    String name = userCredential.user!.displayName ?? '';

    UserModel newUser = UserModel(
      userId: userId,
      name: name,
      email: email,
      rating: 0,
      comments: [],
      isAdmin: false,
    );
    final DatabaseReference userRef = dataBase.ref().child(usersCollection);

    try {
      await userRef.child(userId).set(newUser.toMap());
      print('User added to database');
    } catch (e) {
      print('Error adding user to database: $e');
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
    emit(AuthSignOut());
  }
}
