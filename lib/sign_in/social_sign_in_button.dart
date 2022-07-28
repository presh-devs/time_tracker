import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_ElevatedButton.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    Key? key,
    required String? text,
    required String assetName,
    Color? color,
    Color? textColor,
    VoidCallback? onPressed,
  })  : assert(text != null),
        super(
          key: key,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetName),
              Text(
                text!,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(assetName),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
          textcolor: textColor,
        );
}
