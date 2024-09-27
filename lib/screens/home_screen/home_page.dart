import 'dart:ui';

import 'package:comments/blocs/auth/auth_cubit.dart';
import 'package:comments/blocs/user_cubit/user_cubit.dart';
import 'package:comments/consts/colors.dart';
import 'package:comments/models/user_model.dart';
import 'package:comments/often_used/often_used_method.dart';
import 'package:comments/screens/auth_screen/login_screen/login_page.dart';
import 'package:comments/widgets/components/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../consts/strings.dart';

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

  String getName(String fullName) {
    final name = fullName.isNotEmpty ? fullName[0] : 'A';
    return name;
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
                      currentUser == null ? 'A' : getName(currentUser.email),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                  ),
                ),
              ),
              Text(currentUser == null ? 'Empty' : currentUser.email),
              // Text(currentUser.email),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              const SizedBox(height: 15),
              const Text('Rate'),
              const SizedBox(height: 15),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    'List Users',
                    style: TextStyle(color: mainColor),
                  )),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    'My Page',
                    style: TextStyle(color: mainColor),
                  )),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    'My comments',
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
        builder: (BuildContext context, state) => state.users.isEmpty
            ? const Center(child: Text(noUsersYet))
            : ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) => Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(state.users[index].email),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [Icon(Icons.star), Text('4,5')],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
