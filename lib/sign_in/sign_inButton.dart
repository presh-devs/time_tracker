import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_ElevatedButton.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    Key? key,
    String? text,
    Color? color,
    Color? textColor,
    VoidCallback? onPressed,
  })  : assert(text != null),
        super(
          key: key,
          child: Text(
            text!,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          color: color,
          onPressed: onPressed,
          textcolor: textColor,
        );
}
