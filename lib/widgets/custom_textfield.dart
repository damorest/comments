import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../consts/colors.dart';

Widget customTextField({String? lable, String? hint, controller, bool isPass = false,}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(lable!, style: const TextStyle(color: mainColor, fontWeight: FontWeight.normal, fontSize: 16)),
      TextFormField(
        obscureText: isPass,
        controller: controller,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            color: darkFontGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: mainColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      const SizedBox(height: 5),
    ],
  );
}