import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_service/presentasion/pages/welcome/welcome_screen.dart';
import 'package:social_service/repositories/geolocation/geolocation_repository.dart';
import "dart:math" as math;

import 'package:social_service/router/app_pages.dart';
import 'package:social_service/core/values/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      AppRouter.pushAndRemoveUntil(
          context, const WelcomeScreen(), Routes.welcomeScreen);
    });
    super.initState();
    GeolocationRepository().requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purpleBackground,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset('assets/images/rectangle-3.png'),
          ),
          Center(
            child: Image.asset('assets/images/group-12.png'),
          ),
          Center(
            child: Transform.rotate(
              angle: 5 * math.pi / 100,
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
            ),
          ),
          const Center(
            child: Text(
              "hi",
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7210FF)),
            ),
          ),
          Positioned(
            bottom: 100,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Text(
                "Social service! We are on our way to your location to repair your electronic device!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
