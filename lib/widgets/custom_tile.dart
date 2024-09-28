import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../consts/colors.dart';

Widget customTile (int initialRating, String content, String author, String time) {
 return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: mainColor,
              width: 1.0,
              style: BorderStyle.solid)),
      child: Column(
        children: [
          RatingBar.builder(
            initialRating: initialRating.toDouble(),
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 25,
            itemBuilder: (context, _) =>
            const Icon(
              Icons.star,
              color: redColor,
            ),
            ignoreGestures: true,
            onRatingUpdate: (
                double value) {},
          ),
          Text(content),
          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                        8.0),
                    child: Text(author),
                  )),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                        8.0),
                    child: Text(time),
                  )
              )
            ],
          )
        ],
      ),
    ),
  );
}