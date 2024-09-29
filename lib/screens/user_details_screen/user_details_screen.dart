import 'package:comments/consts/firebase_consts.dart';
import 'package:comments/models/user_model.dart';
import 'package:comments/often_used/often_used_method.dart';
import 'package:comments/screens/home_screen/home_page.dart';
import 'package:comments/widgets/components/my_button.dart';
import 'package:comments/widgets/custom_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../blocs/user_cubit/user_cubit.dart';
import '../../consts/colors.dart';
import '../../consts/strings.dart';

class UserDetailsPage extends StatefulWidget {
  final String userId;

  const UserDetailsPage({super.key, required this.userId});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            nextScreenReplace(context, const MyHomePage());
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(comment),
        centerTitle: true,
      ),
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        final user = context.read<UserCubit>().getUserById(widget.userId);
        UserModel? currentUser = context.read<UserCubit>().getCurrentUser();

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
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
                        user == null ? 'A' : user.email[0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(),
                    Text(user == null ? '' : user.email),
                    user.isAdmin == true
                        ? const Icon(
                            Icons.local_police_outlined,
                            color: mainColor,
                          )
                        : const SizedBox()
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Divider(),
                ),
                const SizedBox(height: 10),
                Text(user == null ? '' : '$rating ${user.rating.toString()}'),
                RatingBar.builder(
                  initialRating: user.rating.toDouble(),
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ignoreGestures: true,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: redColor,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                const Text(comment),
                const SizedBox(height: 5),
                currentUser?.userId != user.userId
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: myButton(
                              onPress: () => _showCommentDialog(context, user),
                              color: mainColor,
                              textColor: whiteColor,
                              title: add),
                        ),
                      )
                    : const SizedBox(),
                user.comments.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: user.comments.length,
                            itemBuilder: (context, index) => GestureDetector(
                                  onLongPressStart:
                                      currentUser!.isAdmin == true ?
                                      (details) {
                                    showMenu(
                                      context: context,
                                      position: RelativeRect.fromLTRB(
                                        details.globalPosition.dx,
                                        details.globalPosition.dy,
                                        details.globalPosition.dx,
                                        details.globalPosition.dy,
                                      ),
                                      items: [
                                        PopupMenuItem(
                                            child: const Row(
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors.red),
                                                SizedBox(width: 8),
                                                Text(delete),
                                              ],
                                            ),
                                            onTap: () {
                                              context
                                                  .read<UserCubit>()
                                                  .deleteCommentToUser(
                                                      user.userId,
                                                      user.comments[index]);
                                              Future.delayed(Duration.zero, () {
                                                showSnackBar(
                                                    context,
                                                    Colors.blue,
                                                    '$comment $deleted');
                                              });
                                            })
                                      ],
                                    );
                                  }
                                  : (details) {},
                                  child: customTile(
                                      user.comments[index].rating,
                                      user.comments[index].content,
                                      user.comments[index].userId[0],
                                      user.comments[index].timestamp
                                          .toString()
                                          .split('.')[0]),
                                )),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showCommentDialog(BuildContext context, UserModel user) {
    final commentController = TextEditingController();
    int selectedRating = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(inputComment),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: redColor,
                ),
                onRatingUpdate: (rating) {
                  selectedRating = rating.toInt();
                },
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
                style: TextStyle(color: redColor),
              ),
            ),
            TextButton(
              onPressed: () {
                if (selectedRating != 0) {
                  _addComment(
                      context, commentController.text, selectedRating, user);
                  commentController.clear();
                  Navigator.pop(context);
                } else {
                  showSnackBar(context, redColor, ratingEmpty);
                }
              },
              child: const Text(
                add,
                style: TextStyle(color: mainColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addComment(
      BuildContext context, String content, int rating, UserModel userModel) {
    if (rating == 0) return;
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      final newComment = Comment(
        commentId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser.uid,
        content: content ?? '',
        rating: rating,
        timestamp: DateTime.now(),
      );

      context
          .read<UserCubit>()
          .addCommentToUser(userModel.userId, newComment)
          .then((_) => setState(() {
                userModel.comments.add(newComment);
              }));
      context.read<UserCubit>().updateUserRating(userModel.userId);
    }
  }
}
