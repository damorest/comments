import 'package:comments/blocs/auth/auth_cubit.dart';
import 'package:comments/often_used/often_used_method.dart';
import 'package:comments/screens/auth_screen/login_screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('All users'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Comments'),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async{
                  await context.read<AuthCubit>().signOut();
                  nextScreenReplace(context, const LoginPage());
                },
                child: Text('Out'))
          ],
        )
      ),
    );
  }
}
