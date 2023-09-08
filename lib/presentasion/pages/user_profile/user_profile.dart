import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_service/blocs/auth/auth_bloc.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/core/widgets/base_app_bar.dart';
import 'package:social_service/cubits/login/login_cubit.dart';
import 'package:social_service/presentasion/pages/history_order/history_order_screen.dart';
import 'package:social_service/presentasion/pages/login/views/login_screen.dart';
import 'package:social_service/router/app_pages.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc authBloc) => authBloc.state.user);

    return Scaffold(
      appBar: const BaseAppBar(
        headerTitle: "Profile",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                backgroundColor: AppColors.purpleBackground,
                minRadius: 50,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                user.name ?? "User Name",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () {
                AppRouter.push(context, const HistoryOrderScreen(), Routes.historyOrderScreen);
              },
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                        (states) => AppColors.palePurple),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "History Order",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppColors.purpleBackground,
                  )
                ],
              ),
            ),
            const Divider(color: AppColors.black, thickness: 2),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());

                context.read<LoginCubit>().initalState();

                AppRouter.pushAndRemoveUntil(
                    context, const LoginScreen(), Routes.loginScreen);
              },
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => AppColors.palePurple),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Logout",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Icon(
                    Icons.logout,
                    color: AppColors.purpleBackground,
                  )
                ],
              ),
            ),
            const Divider(color: AppColors.black, thickness: 2),
          ],
        ),
      ),
    );
  }
}
