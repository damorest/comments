import 'package:comments/blocs/auth/auth_cubit.dart';
import 'package:comments/blocs/user_cubit/user_cubit.dart';
import 'package:comments/consts/colors.dart';
import 'package:comments/models/user_model.dart';
import 'package:comments/often_used/often_used_method.dart';
import 'package:comments/screens/auth_screen/login_screen/login_page.dart';
import 'package:comments/screens/user_details_screen/user_details_screen.dart';
import 'package:comments/widgets/components/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../consts/strings.dart';
import '../my_comments_screen/my_comments_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(allUsers),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          UserModel? currentUser = context.read<UserCubit>().getCurrentUser();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 14, left: 8, right: 8, bottom: 8),
                child: CircleAvatar(
                  backgroundColor: mainColor,
                  radius: 40,
                  child: CircleAvatar(
                    radius: 37,
                    backgroundColor: lightGrey,
                    child: Text(
                      currentUser == null ? 'A' : currentUser.email[0],
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
                  Text(currentUser == null ? userNotFound : currentUser.email),
                  currentUser!.isAdmin == true
                      ? const Icon(
                          Icons.local_police_outlined,
                          color: mainColor,
                        )
                      : const SizedBox()
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              const SizedBox(height: 15),
              Text(
                currentUser == null
                    ? '0'
                    : '$rating ${currentUser.rating.toString()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              RatingBar.builder(
                  initialRating: currentUser!.rating.toDouble(),
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  ignoreGestures: true,
                  itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: redColor,
                      ),
                  onRatingUpdate: (rating) {}),
              const SizedBox(height: 15),
              TextButton(
                  onPressed: () {
                    nextScreenReplace(context, const MyHomePage());
                  },
                  child: const Text(
                    allUsers,
                    style: TextStyle(color: mainColor),
                  )),
              TextButton(
                  onPressed: () {
                    nextScreenReplace(
                        context, UserDetailsPage(userId: currentUser.userId));
                  },
                  child: const Text(
                    myPage,
                    style: TextStyle(color: mainColor),
                  )),
              TextButton(
                  onPressed: () {
                    nextScreen(
                        context,
                        MyCommentsPage(
                          userModel: currentUser,
                        ));
                  },
                  child: const Text(
                    myComments,
                    style: TextStyle(color: mainColor),
                  )),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: myButton(
                        onPress: () async {
                          await context.read<AuthCubit>().signOut();
                          nextScreenReplace(context, const LoginPage());
                        },
                        textColor: whiteColor,
                        title: out,
                        color: mainColor),
                  ))
            ],
          );
        }),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          final currentUser = context.read<UserCubit>().getCurrentUser();
          return state.users.isEmpty
              ? const Center(child: Text(noUsersYet))
              : ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) => state.users[index].userId ==
                          currentUser?.userId
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () => nextScreen(
                              context,
                              UserDetailsPage(
                                  userId: state.users[index].userId)),
                          onLongPressStart: currentUser!.isAdmin == true
                              ? (details) {
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
                                          child: state.users[index].isAdmin ==
                                                  true
                                              ? const Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .cancel_outlined,
                                                            color: redColor),
                                                        Icon(
                                                            Icons
                                                                .local_police_outlined,
                                                            color: redColor),
                                                      ],
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(notAdmin),
                                                  ],
                                                )
                                              : const Row(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .local_police_outlined,
                                                        color: mainColor),
                                                    SizedBox(width: 8),
                                                    Text(makeAdmin),
                                                  ],
                                                ),
                                          onTap: () {
                                            print('delete comment');
                                            // context
                                            //     .read<ArgueCubit>()
                                            //     .deleteArgue(filteredArguesList[index].id);
                                            // Future.delayed(Duration.zero, () {
                                            //   showSnackBar(context, Colors.blue,
                                            //       '${filteredArguesList[index].name} $deleted');
                                          }),
                                    ],
                                  );
                                }
                              : (details) {},
                          child: Card(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(state.users[index].email),
                              ),
                              state.users[index].isAdmin == true
                                  ? const Icon(
                                      Icons.local_police_outlined,
                                      color: mainColor,
                                    )
                                  : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Icon(Icons.star, color: redColor),
                                    Text(state.users[index].rating.toString())
                                  ],
                                ),
                              )
                            ],
                          )),
                        ));
        },
      ),
    );
  }
}
