part of 'signup_cubit.dart';

enum SignupStatus { inital, submitting, success, error }

class SignupProcess extends Equatable {
  final String role;
  final String name;
  final String email;
  final String password;
  final SignupStatus signupStatus;
  final String? errorMessage;
  final bool isObscureText;

  const SignupProcess({
    required this.role,
    required this.name,
    required this.email,
    required this.password,
    required this.signupStatus,
    this.errorMessage,
    this.isObscureText = true,
  });

  factory SignupProcess.inital() {
    return const SignupProcess(
        role: "",
        name: "",
        email: "",
        password: "",
        signupStatus: SignupStatus.inital,
        errorMessage: "",
        isObscureText: true);
  }

  SignupProcess copyWith({
    String? role,
    String? name,
    String? email,
    String? password,
    SignupStatus? signupStatus,
    String? errorMessage,
    bool? isObscureText,
  }) {
    return SignupProcess(
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      signupStatus: signupStatus ?? this.signupStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isObscureText: isObscureText ?? this.isObscureText,
    );
  }

  @override
  List<Object?> get props => [
        role,
        name,
        email,
        password,
        signupStatus,
        errorMessage,
        isObscureText,
      ];
}

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => [];
}

class SignupFailure extends SignupState {
  final String errorMessage;

  const SignupFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
