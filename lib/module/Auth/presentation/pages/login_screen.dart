
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahil/constants/app_color.dart';
import 'package:sahil/constants/app_constants.dart';
import 'package:sahil/constants/app_string.dart';
import 'package:sahil/custom_widgets/app_textfield_with_label.dart';
import 'package:sahil/custom_widgets/icon_custom_button.dart';
import 'package:sahil/custom_widgets/progress_button.dart';
import 'package:sahil/module/Auth/presentation/Bloc/auth_bloc.dart';
import 'package:sahil/routes/routes.dart';
import 'package:sahil/utils/global_value.dart';
import 'package:sahil/utils/navigator_service.dart';
import 'package:sahil/utils/size_utils.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: LoginScreen(),
    );
  }

  final formKey = GlobalKey<FormState>();
  bool? isEmailError = false;
  bool? isPasswordError = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: getPadding(all: 20),
              child: Column(
                children: [
                  _buildForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _buildForm() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthLoadedState) {
          NavigatorService.pushNamedAndRemoveUntil(AppRoutes.homeScreen);
        }
      },
      builder: (context, state) {
        var bloc = context.read<AuthBloc>();
        return Form(
          autovalidateMode: state.autoValidate!
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          key: formKey,
          child: Padding(
            padding: getPadding(left: 8, right: 8, top: 70, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    AppStrings.login,
                    style: TextStyle(
                      color: AppColors.blackFont,
                      fontSize: getSize(27),
                    ),
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(10),
                ),
                AppTextFieldWithLabel(
                  validator: (value) {
                    if (GlobalValue.regexForEmail.hasMatch(value!.trim())) {
                      ///return valid
                    } else if (value.trim().isEmpty) {
                      return AppStrings.emailRequired;
                    } else {
                      return AppStrings.notValidEmail;
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.emailAddress,
                  controller: bloc.emailCtrl,
                  textInputAction: TextInputAction.next,
                  onChanged: (p0) {},
                  labelText: "Email",
                  hintText: "Enter email",
                ),
                SizedBox(
                  height: getVerticalSize(10),
                ),
                AppTextFieldWithLabel(
                  validator: (value) {
                    if (GlobalValue.regexForPass.hasMatch(value!)) {
                    } else if (value.trim().isEmpty) {
                      return 'Password is required.';
                    }
                    return null;
                  },
                  controller: bloc.passCtrl,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.done,
                  onChanged: (p0) {},
                  suffixIcon: InkWell(
                    onTap: () {
                      context.read<AuthBloc>().add(AuthObscureText(
                            !state.isPasswordVisible!,
                          ));
                    },
                    child: Icon(
                      state.isPasswordVisible!
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.grey,
                    ),
                  ),
                  obscureText: state.isPasswordVisible! ? false : true,
                  labelText: AppStrings.password,
                  hintText: AppStrings.enterPassword,
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
                signInCustomButton(
                  state,
                  context,
                  onPressed: () {
                    hideKeyboard();
                    state.autoValidate = true;
                    context.read<AuthBloc>().add(LoginEmitEvent());
                    _validateForm(
                        context, bloc.emailCtrl.text, bloc.passCtrl.text);
                  },
                ),
                SizedBox(
                  height: getVerticalSize(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    InkWell(
                      onTap: () {
                        context.read<AuthBloc>().add(clearState());
                        NavigatorService.pushNamedAndRemoveUntil(
                            AppRoutes.registerScreen);
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: AppColors.brickButtonBG),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget signInCustomButton(AuthState state, BuildContext context,
      {Function? onPressed}) {
    return ProgressButton.icon(
      maxWidth: size.width,
      minWidth: getHorizontalSize(55.0),
      radius: state.signInButton == ButtonState.idle ? 5.0 : 100.0,
      textStyle: TextStyle(
          fontSize: getFontSize(20),
          letterSpacing: 0.2,
          color: AppColors.white),
      iconCustomButton: {
        ButtonState.idle: IconCustomButton(
            text: 'SIGN IN',
            icon: const Icon(
              Icons.send,
              color: Colors.transparent,
              size: 0,
            ),
            color: AppColors.sectionText),
        ButtonState.loading:
            IconCustomButton(text: "Loading", color: AppColors.sectionText),
        ButtonState.fail: const IconCustomButton(
            text: "Failed",
            icon: Icon(Icons.cancel, color: Colors.white),
            color: Colors.red),
        ButtonState.success: const IconCustomButton(
            text: 'Login Successful',
            icon: Icon(
              Icons.send,
              color: Colors.transparent,
              size: 0,
            ),
            color: Colors.green),
      },
      onPressed: onPressed,
      state: state.signInButton,
    );
  }

  _validateForm(BuildContext context, String email, String pass) async {
    if (formKey.currentState!.validate()) {
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }
      context.read<AuthBloc>().add(LoginButtonEvent());
    }
  }
}
