import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:social_service/models/error_exception.dart';
import 'package:social_service/repositories/auth/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginProcess> {
  final AuthRepository _authRepository;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  LoginCubit(this._authRepository) : super(LoginProcess.inital());

  void initalState(){
    LoginProcess.inital();
  }

  void roleChanged(String value) {
    emit(
      state.copyWith(
        role: value,
        loginStatus: LoginStatus.inital,
      ),
    );
  }

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        loginStatus: LoginStatus.inital,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        loginStatus: LoginStatus.inital,
      ),
    );
  }

  void isObscureText() {
    emit(
      state.copyWith(
        isObscureText: !state.isObscureText,
      ),
    );
  }

  Future<void> loginFormSubmitted() async {
    if (state.loginStatus == LoginStatus.submitting) return;
    emit(state.copyWith(loginStatus: LoginStatus.submitting));
    try {
      if (state.role.isEmpty) {
        emit(
          LoginProcess(
                role: state.role,
                email: state.email,
              password: state.password,
              loginStatus: LoginStatus.error,
              errorMessage: "Choose Role!"),
        );

        return;
      }

      final emailIsAlreadyInRole = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: state.role)
          .where('email', isEqualTo: state.email)
          .get();

      if (emailIsAlreadyInRole.docs.isEmpty) {
        emit(
          LoginProcess(
            role: state.role,
            email: state.email,
            password: state.password,
            loginStatus: LoginStatus.error,
            errorMessage: "Email Or Password is wrong!",
          ),
        );

        return;
      }

      await _authRepository.loginUser(
          email: state.email, password: state.password);

      emit(state.copyWith(loginStatus: LoginStatus.success));
    } on ErrorException catch (e) {
      emit(
        LoginProcess(
          role: state.role,
          email: state.email,
          password: state.password,
          loginStatus: LoginStatus.error,
          errorMessage: e.message,
        ),
      );
    }
  }
}
