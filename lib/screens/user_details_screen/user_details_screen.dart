import 'package:comments/consts/firebase_consts.dart';
import 'package:comments/models/user_model.dart';
import 'package:comments/widgets/components/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user_cubit/user_cubit.dart';
import '../../consts/colors.dart';
import '../../consts/strings.dart';

class UserDetailsPage extends StatefulWidget {
  final UserModel user;

  const UserDetailsPage({super.key, required this.user});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? userNotFound : widget.user.email),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: CircleAvatar(
                  backgroundColor: mainColor,
                  radius: 40,
                  child: CircleAvatar(
                    radius: 37,
                    backgroundColor: lightGrey,
                    child: Text(
                      widget.user == null ? 'A' : widget.user.email[0],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                  ),
                ),
              ),
              Text(widget.user == null ? '' : widget.user.email),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Divider(),
              ),
              const SizedBox(height: 10),
              const Text(rating),
              Text(widget.user == null ? '' : widget.user.rating.toString()),
              const Icon(
                Icons.star,
                color: redColor,
              ),
              const Text(comment),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: myButton(
                      onPress: () => _showCommentDialog(context),
                      color: mainColor,
                      textColor: whiteColor,
                      title: add),
                ),
              ),
              widget.user.comments.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: widget.user.comments.length,
                          itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: mainColor,
                                          width: 1.0,
                                          style: BorderStyle.solid)),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: redColor,
                                      ),
                                      Text(widget.user.comments[index].content),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(widget
                                                    .user
                                                    .comments[index]
                                                    .userId
                                                    .isEmpty
                                                ? anonymous
                                                : 'User with ID : ${widget.user.comments[index].userId}'),
                                          )),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(widget
                                                .user.comments[index].timestamp
                                                .toString()),
                                          ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(inputComment),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                  Icons.star,
                color: redColor,
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(hintText: commentHint),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                  cancel,
                style: TextStyle(
                  color: redColor
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _addComment(context, commentController.text);
                Navigator.pop(context);
              },
              child: const Text(
                  add,
                style: TextStyle(
                  color: mainColor
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addComment(BuildContext context, String content) {
    if (content.isEmpty) return;

    final currentUser = auth.currentUser;
    if (currentUser != null) {
      final newComment = Comment(
        commentId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser.uid,
        content: content,
        timestamp: DateTime.now(),
      );
      context
          .read<UserCubit>()
          .addCommentToUser(widget.user.userId, newComment)
          .then((_) => setState(() {
                widget.user.comments.add(newComment);
              }));
    }
  }
}
