part of 'login_cubit.dart';

enum LoginStatus { inital, submitting, success, error }

class LoginProcess extends Equatable {
  final String role;
  final String email;
  final String password;
  final LoginStatus loginStatus;
  final String? errorMessage;
  final bool isObscureText;

  const LoginProcess({
    required this.role,
    required this.email,
    required this.password,
    required this.loginStatus,
    this.errorMessage,
    this.isObscureText = false,
  });

  factory LoginProcess.inital() {
    return const LoginProcess(
      role: "",
      email: "",
      password: "",
      loginStatus: LoginStatus.inital,
      errorMessage: "",
      isObscureText: true,
    );
  }

  LoginProcess copyWith({
    String? role,
    String? email,
    String? password,
    LoginStatus? loginStatus,
    String? errorMessage,
    bool? isObscureText,
  }) {
    return LoginProcess(
      role: role ?? this.role,
      email: email ?? this.email,
      password: password ?? this.password,
      loginStatus: loginStatus ?? this.loginStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isObscureText: isObscureText ?? this.isObscureText,
    );
  }

  @override
  List<Object?> get props =>
      [role, email, password, loginStatus, errorMessage, isObscureText];
}

@immutable
abstract class LoginState extends Equatable{
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginFailure extends LoginState {
  final String errorMessage;

  const LoginFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
