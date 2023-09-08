part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unAuthenticated, loading }

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final User user;

  const AuthState._({required this.authStatus, this.user = User.empty});

  const AuthState.authenticated(User user)
      : this._(authStatus: AuthStatus.authenticated, user: user);

  const AuthState.unAuthenticated()
      : this._(
          authStatus: AuthStatus.unAuthenticated,
        );

  const AuthState.loading() : this._(authStatus: AuthStatus.loading);

  @override
  List<Object?> get props => [authStatus, user];
}
