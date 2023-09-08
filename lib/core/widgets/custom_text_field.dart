import 'package:flutter/material.dart';
import 'package:social_service/core/values/app_colors.dart';

enum SuffixCondition {
  showVisibility,
  showAnotherIcon,
  showButton,
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hinText,
    this.controller,
    this.margin,
    this.obscureText = false,
    this.suffixCondition,
    this.suffixOnPressed,
    this.suffixText = "",
    this.onChanged,
  });

  final String hinText;
  final TextEditingController? controller;
  final EdgeInsets? margin;
  final bool obscureText;
  final SuffixCondition? suffixCondition;
  final VoidCallback? suffixOnPressed;
  final String suffixText;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: margin,
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.purpleBackground,
              ),
            ),
            hintText: hinText,
            suffix: _buildSuffix(context)),
        style: const TextStyle(
          fontSize: 16.0,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildSuffix(BuildContext context) {
    switch (suffixCondition) {
      case SuffixCondition.showVisibility:
        return IconButton(
          onPressed: suffixOnPressed,
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: AppColors.purpleBackground,
          ),
        );
      case SuffixCondition.showAnotherIcon:
        return IconButton(
          onPressed: suffixOnPressed,
          icon: const Icon(Icons.star),
        );
      case SuffixCondition.showButton:
        return ElevatedButton(
          onPressed: suffixOnPressed,
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Colors.white),
            shape: const MaterialStatePropertyAll(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  side:
                      BorderSide(color: AppColors.purpleBackground, width: 2)),
            ),
            overlayColor: MaterialStateProperty.resolveWith(
              (states) {
                return states.contains(MaterialState.pressed)
                    ? Colors.grey
                    : null;
              },
            ),
          ),
          child: Text(
            suffixText,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: AppColors.purpleBackground),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
