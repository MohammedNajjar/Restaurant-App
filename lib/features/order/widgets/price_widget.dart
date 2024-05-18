import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class PriceWidget extends StatelessWidget {
  final String title;
  final String value;
  final double fontSize;
  const PriceWidget(
      {super.key,
      required this.title,
      required this.value,
      required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title,
          style: robotoRegular.copyWith(
              fontSize: fontSize, fontWeight: FontWeight.bold)),
      Text(value,
          style: robotoMedium.copyWith(
              fontSize: fontSize, fontWeight: FontWeight.bold)),
    ]);
  }
}
