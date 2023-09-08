import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_service/presentasion/pages/login/views/login_screen.dart';
import 'package:social_service/core/widgets/custom_button.dart';
import 'package:social_service/router/app_pages.dart';
import 'package:social_service/core/values/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: LottieBuilder.asset(
                'assets/lottie/welcome_lottie.json',
                height: 300,
              ),
            ),
            Text(
              "Welcome!",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 10),
            Text(
              "Social service! Ready to head to your location to repair your electronic item!",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: AppColors.black.withOpacity(0.5)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            CustomButtom(
              onPressed: () {
                AppRouter.pushAndRemoveUntil(context, const LoginScreen(), Routes.loginScreen);
              },
              hint: "Enter",
              width: 150,
            )
          ],
        ),
      ),
    );
  }
}
