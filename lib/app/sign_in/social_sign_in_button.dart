import 'package:flutter/material.dart';
import 'package:timeTracker/common/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String assetName,
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(assetName != null),
        assert(text != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetName),
              Text(text, style: TextStyle(fontSize: 15, color: textColor)),
              Opacity(
                opacity: 0,
                child: Image.asset(assetName),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
          borderRadius: 8,
        );
}
