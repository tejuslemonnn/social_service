import 'package:flutter/material.dart';
import 'package:social_service/core/values/app_colors.dart';

class CustomButtom extends StatelessWidget {
  const CustomButtom({
    super.key,
    required this.onPressed,
    required this.hint,
    this.width,
    this.height = 50,
    this.color = AppColors.purpleBackground,
    this.iconData,
  });

  final VoidCallback onPressed;
  final String hint;
  final double? height;
  final double? width;
  final Color? color;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              color,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)))),
        child: iconData != null ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: AppColors.white),
            const SizedBox(width: 10),
            Text(hint),
          ],
        ) : Text(hint),
      ),
    );
  }
}
