import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_ElevatedButton.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    Key? key,
    @required String? text,
    required VoidCallback? onPressed,
  }) : super(
          key: key,
          child: Text(
            text!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          color: Colors.indigo,
          onPressed: onPressed,
        );
}
