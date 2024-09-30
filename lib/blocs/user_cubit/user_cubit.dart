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
      emit(const UserState());
    }
  }

  UserModel? getUserById(String userId) {
    try {
      return state.users.firstWhere((user) => user.userId == userId);
    } catch (e) {
      print('User not found');
      return null;
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

  Future<void> addCommentToUser(String targetUserId, Comment newComment) async {
    try {
      final userRef = _userRef.child(targetUserId);

      final snapshot = await userRef.once();
      final userData = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (userData != null) {
        final user = UserModel.fromMap(userData);

        final updatedComments = List<Comment>.from(user.comments)
          ..add(newComment);

        await userRef.update({
          'comments': updatedComments.map((c) => c.toMap()).toList(),
        });

        final updatedUsers = state.users.map((u) {
          return u.userId == targetUserId ? u.copyWith(
              comments: updatedComments) : u;
        }).toList();

        emit(UserState(users: updatedUsers));
      }
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  Future<void> deleteCommentToUser(String targetUserId, Comment comment) async {
    try {
      final userRef = _userRef.child(targetUserId);

      final snapshot = await userRef.once();
      final userData = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (userData != null) {
        final user = UserModel.fromMap(userData);

        final updatedComments = List<Comment>.from(user.comments)
          ..removeWhere((c) => c.commentId == comment.commentId);

        await userRef.update({
          'comments': updatedComments.map((c) => c.toMap()).toList(),
        });

        final updatedUsers = state.users.map((u) {
          return u.userId == targetUserId ? u.copyWith(
              comments: updatedComments) : u;
        }).toList();

        updateUserRating(targetUserId);

        emit(UserState(users: updatedUsers));
      }
    } catch (e) {
      print('Error delete comment: $e');
    }
  }


  Future<void> updateUserRating(String userId) async {
    final userRef = dataBase.ref('$usersCollection/$userId');

    final comments = await fetchUserComments(userId);

    print('COMMENTS LENGTH : ${comments.length}');

      int totalRating = comments.fold(
          0, (sum, comment) => sum + comment.rating);

      print('TOTAL RATING : $totalRating');

    int averageRating = comments.isNotEmpty
        ? (totalRating / comments.length).round()
        : 0;

    print('AVERAGE RATING : $averageRating');

        await userRef.update({'rating': averageRating});
        fetchUsers();

  }

  Future<List<Comment>> fetchUserComments(String userId) async {
    try {
      final userRef = dataBase.ref('$usersCollection/$userId');

      final snapshot = await userRef.once();
      final userData = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (userData != null && userData.containsKey('comments')) {
        final commentsData = userData['comments'] as List<dynamic>;

        final comments = commentsData.map((commentData) {
          return Comment.fromMap(commentData);
        }).toList();
        return comments;
      } else {
        return [];
      }
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  List<Map<String, dynamic>> getCommentsByCurrentUser(UserModel currentUser) {
    List<Map<String, dynamic>> currentUserCommentsWithUser = [];

    for (var user in state.users) {
      List<Comment> currentUserComments = user.comments
          .where((comment) => comment.userId == currentUser.userId)
          .toList();

      for (var comment in currentUserComments) {
        currentUserCommentsWithUser.add({
          'comment': comment,
          'user': user, // Це користувач, якому був написаний коментар
        });
      }
    }

    return currentUserCommentsWithUser;
  }

  Future<void> updateUserAdminRole(String targetUserId, bool isAdmin) async {
    try {
      final userRef = _userRef.child(targetUserId);

      await userRef.update({
        'isAdmin' : isAdmin
      });

        final updatedUsers = state.users.map((u) {
          return u.userId == targetUserId ? u.copyWith(
              isAdmin: isAdmin) : u;
        }).toList();

        emit(UserState(users: updatedUsers));

    } catch (e) {
      print('Error updating user role $e');
    }
  }

  void clearUser(User user) {
    emit(const UserState());
  }
}
