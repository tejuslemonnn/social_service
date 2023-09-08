import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_service/cubits/signup/signup_cubit.dart';
import 'package:social_service/presentasion/pages/login/views/login_screen.dart';
import 'package:social_service/core/widgets/base_app_bar.dart';
import 'package:social_service/core/widgets/custom_button.dart';
import 'package:social_service/core/widgets/custom_text_field.dart';
import 'package:social_service/router/app_pages.dart';

class RegisterScreem extends StatefulWidget {
  const RegisterScreem({super.key});

  @override
  State<RegisterScreem> createState() => _RegisterScreemState();
}

class _RegisterScreemState extends State<RegisterScreem> {
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
        headerTitle: "Register",
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: BlocListener<SignupCubit, SignupProcess>(
          listener: (context, state) {
            if (state.signupStatus == SignupStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'An error occurred.'),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state.signupStatus == SignupStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Register Success'),
                  backgroundColor: Colors.green,
                ),
              );

              AppRouter.pushAndRemoveUntil(
                context,
                const LoginScreen(),
                Routes.loginScreen,
              );
            }
          },
          child: Column(
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
                      child: BlocBuilder<SignupCubit, SignupProcess>(
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
                              context.read<SignupCubit>().roleChanged(value!);
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
                    BlocBuilder<SignupCubit, SignupProcess>(
                      buildWhen: (previous, current) =>
                          previous.name != current.name,
                      builder: (context, state) {
                        return CustomTextField(
                          hinText: "Name",
                          margin: const EdgeInsets.only(
                            top: 16,
                            bottom: 10,
                          ),
                          onChanged: (name) {
                            context.read<SignupCubit>().nameChanged(name);
                          },
                        );
                      },
                    ),
                    BlocBuilder<SignupCubit, SignupProcess>(
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
                            context.read<SignupCubit>().emailChanged(email);
                          },
                        );
                      },
                    ),
                    BlocBuilder<SignupCubit, SignupProcess>(
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
                            context.read<SignupCubit>().isObscureText();
                          },
                          onChanged: (password) {
                            context
                                .read<SignupCubit>()
                                .passwordChanged(password);
                          },
                        );
                      },
                    ),
                    // CustomTextField(
                    //   hinText: "NIK",
                    //   controller: TextEditingController(),
                    //   margin: const EdgeInsets.only(bottom: 10),
                    //   suffixCondition: SuffixCondition.showButton,
                    //   suffixOnPressed: () {},
                    //   suffixText: "Validate",
                    // ),
                    const SizedBox(height: 20),
                    BlocBuilder<SignupCubit, SignupProcess>(
                      buildWhen: (previous, current) =>
                          previous.signupStatus != current.signupStatus,
                      builder: (context, state) {
                        return state.signupStatus == SignupStatus.submitting
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButtom(
                                width: width,
                                onPressed: () {
                                  context
                                      .read<SignupCubit>()
                                      .signupFormSubmitted();
                                },
                                hint: "Register",
                              );
                      },
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
