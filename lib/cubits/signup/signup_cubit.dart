import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_service/models/error_exception.dart';
import 'package:social_service/repositories/auth/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupProcess> {
  final AuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(SignupProcess.inital());

  void roleChanged(String value) {
    emit(
      state.copyWith(
        role: value,
        signupStatus: SignupStatus.inital,
      ),
    );
  }

  void nameChanged(String value) {
    emit(
      state.copyWith(
        name: value,
        signupStatus: SignupStatus.inital,
      ),
    );
  }

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        signupStatus: SignupStatus.inital,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        signupStatus: SignupStatus.inital,
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

  Future<void> signupFormSubmitted() async {
    if (state.signupStatus == SignupStatus.submitting) return;
    emit(state.copyWith(signupStatus: SignupStatus.submitting));
    if (state.role.isEmpty) {
      return emit(state.copyWith(
        signupStatus: SignupStatus.error,
        errorMessage: "Role is empty",
      ));
    }

    if (state.name.isEmpty) {
      return emit(state.copyWith(
        signupStatus: SignupStatus.error,
        errorMessage: "Name is empty",
      ));
    }

    try {
      await _authRepository.signupUser(
        role: state.role,
        name: state.name,
        email: state.email,
        password: state.password,
      );

      emit(state.copyWith(signupStatus: SignupStatus.success));
    } on ErrorException catch (e) {
      emit(
        SignupProcess(
          role: state.role,
          name: state.name,
          email: state.email,
          password: state.password,
          signupStatus: SignupStatus.error,
          errorMessage: e.message,
        ),
      );
    }
  }
}
