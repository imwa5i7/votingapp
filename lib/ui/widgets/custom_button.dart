import 'package:disney_voting/config/palette.dart';
import 'package:flutter/material.dart';

import '../../config/values.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final double marginHorizontal;
  final double paddingVeritical;
  final double paddingHorizontal;
  final bool loading;

  final Color color;
  final Color textColor;
  final double elevalion;
  final double? width;
  final bool isDisabled;
  final bool showBorder;

  const CustomButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = Palette.primary,
    this.textColor = Palette.white,
    this.elevalion = 1,
    this.marginHorizontal = 0.0,
    this.paddingHorizontal = Sizes.s16,
    this.width,
    this.paddingVeritical = Sizes.s16,
    this.showBorder = false,
    this.isDisabled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
      child: SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            shape: showBorder
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.s4),
                    side: const BorderSide(
                      color: Colors.black26, // Border color
                      width: 2.0, // Border width
                    ),
                  )
                : null,
            backgroundColor: isDisabled ? Colors.grey : color,
            elevation: elevalion,
            padding: EdgeInsets.symmetric(
                vertical: paddingVeritical, horizontal: paddingHorizontal),
            foregroundColor: isDisabled ? Colors.white : textColor,
            textStyle: const TextStyle(fontSize: Sizes.s16),
          ),
          child: child,
        ),
      ),
    );
  }
}
