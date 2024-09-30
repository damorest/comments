import 'package:comments/blocs/user_cubit/user_cubit.dart';
import 'package:comments/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/custom_tile.dart';

class MyCommentsPage extends StatelessWidget {
  final UserModel userModel;

  const MyCommentsPage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final myPersonalCommentsList =
        context.read<UserCubit>().getCommentsByCurrentUser(userModel);
    return Scaffold(
        appBar: AppBar(
          title: Text(userModel.email.isEmpty ? '' : userModel.email),
        ),
        body: myPersonalCommentsList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: myPersonalCommentsList.length,
                    itemBuilder: (context, index) {
                      final commentData = myPersonalCommentsList[index];
                      final comment = commentData['comment'] as Comment;
                      final user = commentData['user'] as UserModel;

                      return customTile(
                        comment.rating,
                        comment.content,
                        user.email,
                        comment.timestamp.toString().split('.')[0],
                      );
                    })
        )
            : const SizedBox());
  }
}
