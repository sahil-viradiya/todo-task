part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  bool isLoading;
  bool? isPasswordVisible;
  final ButtonState signInButton;
  bool? autoValidate;

  AuthState(
      {this.isLoading = false,
      this.isPasswordVisible = false,
      this.signInButton = ButtonState.idle,
      this.autoValidate = false});
}

class AuthInitial extends AuthState {
  AuthInitial({ButtonState? signInButton, super.autoValidate = null})
      : super(signInButton: signInButton!);
}

class AuthLoadingState extends AuthState {
  AuthLoadingState(
      {bool? isLoading,
      super.isPasswordVisible = null,
      super.autoValidate = null,
      ButtonState? signInButton})
      : super(
            isLoading: isLoading!,
            signInButton: signInButton!);
}

class AuthSuccessState extends AuthState {
  AuthSuccessState(
      {bool? isLoading,
      super.isPasswordVisible = null,
      super.autoValidate = null,
      ButtonState? signInButton})
      : super(
            isLoading: isLoading!,
            signInButton: signInButton!);
}

class AuthLoadedState extends AuthState {
  // LoginAuthParent? AuthParentData;

  AuthLoadedState({
    bool? isLoading,
    super.isPasswordVisible = null,
    super.autoValidate = null,
    ButtonState? signInButton,
    /*this.AuthParentData*/
  }) : super(
            isLoading: isLoading!,
            signInButton: signInButton!);
}

class AuthRegisterState extends AuthState {
  // LoginAuthParent? AuthParentData;

  AuthRegisterState({
    bool? isLoading,
    super.isPasswordVisible = null,
    super.autoValidate = null,
    ButtonState? signInButton,
    /*this.AuthParentData*/
  }) : super(
            isLoading: isLoading!,
            signInButton: signInButton!);
}

class AuthErrorState extends AuthState {
  AuthErrorState(
      {bool? isLoading,
      super.autoValidate = null,
      super.isPasswordVisible = null,
      ButtonState? signInButton})
      : super(
            isLoading: isLoading!,
            signInButton: signInButton!);
}
