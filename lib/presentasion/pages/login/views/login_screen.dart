import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_service/blocs/auth/auth_bloc.dart';
import 'package:social_service/cubits/login/login_cubit.dart';
import 'package:social_service/presentasion/pages/engineer_home/engineer_home_screen.dart';
import 'package:social_service/presentasion/pages/home/home_screen.dart';
import 'package:social_service/presentasion/pages/register/views/register_screen.dart';
import 'package:social_service/core/widgets/base_app_bar.dart';
import 'package:social_service/core/widgets/custom_button.dart';
import 'package:social_service/core/widgets/custom_text_field.dart';
import 'package:social_service/router/app_pages.dart';
import 'package:social_service/core/values/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  void initState() {
    context.read<LoginCubit>().initalState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    final List<String> items = [
      'Customer',
      'Engineer',
    ];

    return Scaffold(
      appBar: const BaseAppBar(
        headerTitle: "Login",
      ),
      body: BlocListener<LoginCubit, LoginProcess>(
        listener: (context, state) {
          if (state.loginStatus == LoginStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.authStatus == AuthStatus.authenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login Success'),
                  backgroundColor: Colors.green,
                ),
              );

              if (state.user.role == "Customer") {
                AppRouter.pushAndRemoveUntil(
                  context,
                  const HomeScreen(),
                  Routes.homeScreen,
                );
              } else if (state.user.role == "Engineer") {
                AppRouter.pushAndRemoveUntil(
                  context,
                  const EngineerHomeScreen(),
                  Routes.engineerHomeScreen,
                );
              }
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome!",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    DropdownButtonHideUnderline(
                      child: BlocBuilder<LoginCubit, LoginProcess>(
                        buildWhen: (previous, current) =>
                            previous.role != current.role,
                        builder: (context, state) {
                          return DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'Select Role',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: items
                                .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: state.role.isNotEmpty ? state.role : null,
                            onChanged: (String? value) {
                              context.read<LoginCubit>().roleChanged(value!);
                            },
                            buttonStyleData: const ButtonStyleData(
                              height: 40,
                              width: 140,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                          );
                        },
                      ),
                    ),
                    BlocBuilder<LoginCubit, LoginProcess>(
                      buildWhen: (previous, current) =>
                          previous.email != current.email,
                      builder: (context, state) {
                        return CustomTextField(
                          hinText: "Email",
                          margin: const EdgeInsets.only(
                            top: 16,
                            bottom: 10,
                          ),
                          onChanged: (email) {
                            context.read<LoginCubit>().emailChanged(email);
                          },
                        );
                      },
                    ),
                    BlocBuilder<LoginCubit, LoginProcess>(
                      buildWhen: (previous, current) =>
                          previous.password != current.password ||
                          previous.isObscureText != current.isObscureText,
                      builder: (context, state) {
                        return CustomTextField(
                          hinText: "Password",
                          margin: const EdgeInsets.only(bottom: 10),
                          obscureText: state.isObscureText,
                          suffixCondition: SuffixCondition.showVisibility,
                          suffixOnPressed: () {
                            context.read<LoginCubit>().isObscureText();
                          },
                          onChanged: (password) {
                            context
                                .read<LoginCubit>()
                                .passwordChanged(password);
                          },
                        );
                      },
                    ),
                    Text(
                      "Forgot Password?",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: AppColors.purpleBackground),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButtom(
                            onPressed: () {
                              AppRouter.push(context, const RegisterScreem(),
                                  Routes.registerScreen);
                            },
                            hint: "Register",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: BlocBuilder<LoginCubit, LoginProcess>(
                            buildWhen: (previous, current) =>
                                previous.loginStatus != current.loginStatus ||
                                previous.role != current.role,
                            builder: (context, state) {
                              return state.loginStatus == LoginStatus.submitting
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : CustomButtom(
                                      width: width,
                                      onPressed: () {
                                        context
                                            .read<LoginCubit>()
                                            .loginFormSubmitted();
                                      },
                                      hint: "Login ${state.role}",
                                    );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
