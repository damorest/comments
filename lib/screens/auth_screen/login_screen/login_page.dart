import 'package:comments/consts/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_cubit.dart';
import '../../../consts/colors.dart';
import '../../../often_used/often_used_method.dart';
import '../../../widgets/components/circular_tile.dart';
import '../../../widgets/components/my_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../registered_screen/registered_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            const Text('$loginInTo $logo',
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
                      builder: (context, state) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: customTextField(
                              lable: email,
                              hint: emailHint,
                              isPass: false,
                              controller: emailController
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: customTextField(
                              lable: password,
                              hint: passwordHint,
                              isPass: true,
                              controller: passwordController),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  forgetPass,
                                  style: TextStyle(
                                      color: darkFontGrey
                                  ),
                                ))),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child:
                          state is AuthLoading
                              ? const CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation(mainColor),
                          )
                              :
                          myButton(
                              color: emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty
                                  ? mainColor
                              :lightGrey,
                              title: login,
                              textColor: whiteColor,
                              onPress: () async {
                                try {
                                //   авторизация юзера
                                }catch (error) {
                                  showSnackBar(context, redColor, error.toString());
                                  print("ERROR : ${error.toString()}");
                                }
                              }),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(createNewAccount,
                                  style: TextStyle(color: darkFontGrey)),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: myButton(
                              color: mainColor,
                              title: signUp,
                              textColor: whiteColor,
                              onPress: () {
                                nextScreen(context, const RegisteredPage());
                              }),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(loginWith,
                                  style: TextStyle(color: darkFontGrey)),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        CircularTile(
                            imagePath: 'assets/icons/google_new.png',
                            onTap: () {}),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}