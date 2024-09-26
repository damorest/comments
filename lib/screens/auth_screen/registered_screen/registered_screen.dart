import 'package:comments/consts/firebase_consts.dart';
import 'package:comments/screens/home_screen/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_cubit.dart';
import '../../../consts/colors.dart';
import '../../../consts/strings.dart';
import '../../../often_used/often_used_method.dart';
import '../../../widgets/components/my_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../login_screen/login_page.dart';

class RegisteredPage extends StatefulWidget {
  const RegisteredPage({super.key});

  @override
  State<RegisteredPage> createState() => _RegisteredPageState();
}

class _RegisteredPageState extends State<RegisteredPage> {
  FirebaseAuth _auth = auth;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var retypePasswordController = TextEditingController();

  Future<void> checkUserExist(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      showSnackBar(context, mainColor, userCreateMessage);
      nextScreen(context, const MyHomePage());
    } on FirebaseAuthException catch (e) {
      if (e.code == firebaseExceptionUserAlreadyInUse) {
        nextScreen(context, const LoginPage());
        showSnackBar(context, redColor, userAlreadyExist);
      }else {
        showSnackBar(context, redColor, e.toString());
      }
    } catch (e) {
      showSnackBar(context, redColor, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    retypePasswordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthCubit>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: whiteColor,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Text(logo),
                ),
              ),
            ),
            const SizedBox(height: 7),
            const Text('$join $logo',
                style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, top: 20, right: 15, bottom: 150),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: whiteColor,
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: customTextField(
                              lable: name,
                              hint: nameHint,
                              controller: nameController,
                              isPass: false),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: customTextField(
                              lable: email,
                              hint: emailHint,
                              controller: emailController,
                              isPass: false),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: customTextField(
                              lable: password,
                              hint: passwordHint,
                              controller: passwordController,
                              isPass: true),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: customTextField(
                              lable: retypePassword,
                              hint: passwordHint,
                              controller: retypePasswordController,
                              isPass: true),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: SizedBox(
                            width: double.infinity,
                            child: state is AuthLoading
                                ? const CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(mainColor),
                                  )
                                : myButton(
                                    color: nameController.text.isNotEmpty &&
                                            emailController.text.isNotEmpty &&
                                            passwordController
                                                .text.isNotEmpty &&
                                            retypePasswordController
                                                .text.isNotEmpty
                                        ? mainColor
                                        : lightGrey,
                                    title: signUp,
                                    textColor: whiteColor,
                                    onPress: () async {
                                      try {
                                        await checkUserExist(emailController.text, passwordController.text);
                                      } catch (e) {
                                        showSnackBar(context, mainColor, e);
                                      }
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            nextScreenReplace(context, const LoginPage());
                          },
                          child: RichText(
                              text: const TextSpan(
                            children: [
                              TextSpan(
                                text: alreadyHavenAccount,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkFontGrey,
                                ),
                              ),
                              TextSpan(
                                text: login,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                ),
                              ),
                            ],
                          )),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    retypePasswordController.dispose();
    super.dispose();
  }
}
