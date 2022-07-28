import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final Color? textcolor;
  final double? height;

  final VoidCallback? onPressed;
  const CustomElevatedButton({
    Key? key,
    this.child,
    this.color,
    this.onPressed,
    this.height = 50.0,
    this.textcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          foregroundColor: MaterialStateProperty.all(textcolor),
        ),
      ),
    );
  }
}
