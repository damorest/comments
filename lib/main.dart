import 'package:comments/blocs/auth/auth_cubit.dart';
import 'package:comments/screens/auth_screen/registered_screen/registered_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthInitial()))
      ],
      child: const MyApp())
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RegisteredPage(),
    );
  }
}

