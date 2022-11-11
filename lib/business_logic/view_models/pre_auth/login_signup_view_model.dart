import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/utils/constants/enums.dart';
import 'package:movie_db/business_logic/view_models/base_view_model.dart';
import 'package:movie_db/services/service_locator.dart';
import 'package:movie_db/ui/post_auth/homepage.dart';
import 'package:movie_db/ui/splash_screen.dart';

class LoginSignupViewModel extends BaseModel {
  LoginSignupViewModel(super.initialState);
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  AutovalidateMode validateMode = AutovalidateMode.disabled;
  LoginSignupState currentPage = LoginSignupState.signup;
  bool obSecurePassword = true;
  bool obSecureConfirmPassword = true;

  void init() {
    confirmPasswordFocus.addListener(() {
      if (confirmPasswordFocus.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100))
            .then((value) => scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear,
                ));
      }
    });
  }

  void switchTab(int currentTabIndex) {
    validateMode = AutovalidateMode.disabled;
    emit(validateMode);
    if (currentTabIndex == 0 && currentPage != LoginSignupState.signup) {
      currentPage = LoginSignupState.signup;
      emit(currentPage);
      if (emailFocus.hasFocus || passwordFocus.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500)).then(
          (value) =>
              FocusScope.of(navigationService.navigatorKey.currentContext!)
                  .requestFocus(name.text.isEmpty
                      ? nameFocus
                      : email.text.isEmpty
                          ? emailFocus
                          : password.text.isEmpty
                              ? passwordFocus
                              : confirmPassword.text.isEmpty
                                  ? confirmPasswordFocus
                                  : null),
        );
      }
    } else if (currentTabIndex == 1 && currentPage != LoginSignupState.login) {
      currentPage = LoginSignupState.login;
      emit(currentPage);
      if (nameFocus.hasFocus ||
          emailFocus.hasFocus ||
          passwordFocus.hasFocus ||
          confirmPasswordFocus.hasFocus) {
        if (emailFocus.hasFocus || passwordFocus.hasFocus) {
          Future.delayed(const Duration(milliseconds: 500)).then((value) =>
              FocusScope.of(navigationService.navigatorKey.currentContext!)
                  .requestFocus(email.text.isEmpty
                      ? emailFocus
                      : password.text.isEmpty
                          ? passwordFocus
                          : null));
        }
      }
    }
  }

  void submit(String? value){
    if(currentPage == LoginSignupState.signup){
      if(name.text.isEmpty){
        Future.delayed(const Duration(milliseconds: 250)).then((value) => FocusScope.of(navigationService.navigatorKey.currentContext!)
            .requestFocus(nameFocus));
      }else if(email.text.isEmpty){
        Future.delayed(const Duration(milliseconds: 250)).then((value) => FocusScope.of(navigationService.navigatorKey.currentContext!)
            .requestFocus(emailFocus));
      }else if(password.text.isEmpty){
        Future.delayed(const Duration(milliseconds: 250)).then((value) => FocusScope.of(navigationService.navigatorKey.currentContext!)
            .requestFocus(passwordFocus));
      }else if(confirmPassword.text.isEmpty){
        Future.delayed(const Duration(milliseconds: 250)).then((value) => FocusScope.of(navigationService.navigatorKey.currentContext!)
            .requestFocus(confirmPasswordFocus));
      }else{
        signUp();
      }
    }else{
      if(email.text.isEmpty){
        Future.delayed(const Duration(milliseconds: 250)).then((value) => FocusScope.of(navigationService.navigatorKey.currentContext!)
            .requestFocus(emailFocus));
      }else if(password.text.isEmpty){
        Future.delayed(const Duration(milliseconds: 250)).then((value) => FocusScope.of(navigationService.navigatorKey.currentContext!)
            .requestFocus(passwordFocus));
      }else{
        login();
      }
    }
  }

  void clearName() {
    name.text = "";
    emit(name);
    Future.delayed(const Duration(milliseconds: 250)).then((value) => FocusScope.of(navigationService.navigatorKey.currentContext!)
        .requestFocus(nameFocus));
  }

  void clearEmail() {
    email.text = "";
    emit(email);
    Future.delayed(const Duration(milliseconds: 250)).then((value) => FocusScope.of(navigationService.navigatorKey.currentContext!)
        .requestFocus(emailFocus));
  }

  void clearPassword() {
    password.text = "";
    emit(password);
    Future.delayed(const Duration(milliseconds: 250)).then((value) => FocusScope.of(navigationService.navigatorKey.currentContext!)
        .requestFocus(passwordFocus));
  }

  void clearConfirmPassword() {
    confirmPassword.text = "";
    emit(confirmPassword);
    Future.delayed(const Duration(milliseconds: 250)).then((value) => FocusScope.of(navigationService.navigatorKey.currentContext!)
        .requestFocus(confirmPasswordFocus));
  }

  void togglePasswordObSecure(){
    obSecurePassword = !obSecurePassword;
    emit(obSecurePassword);
  }

  void toggleConfirmPasswordObSecure(){
    obSecureConfirmPassword = !obSecureConfirmPassword;
    emit(obSecureConfirmPassword);
  }

  String? validateEmail(String? value) {
    return email.text.contains(
      RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ),
    )
        ? null
        : 'Enter a valid email address';
  }

  String? validatePassword(String? value) {
    return password.text.length >= 8
        ? null
        : 'Enter a strong 8 character password';
  }

  String? validateConfirmPassword(String? value) {
    return confirmPassword.text == password.text
        ? null
        : currentPage == LoginSignupState.signup ? "Confirm password doesn't match": null;
  }

  void login() async{
    FocusScope.of(navigationService.navigatorKey.currentContext!)
        .requestFocus();
    setState(ViewState.busy);
    validateMode = AutovalidateMode.onUserInteraction;
    if(formKey.currentState?.validate() == true){
      final loginSuccess = await authService.login(password: password.text, emailAddress: email.text);
      if(loginSuccess){
        navigationService.removeAllAndPush(HomePage.route, SplashScreen.route,arguments: Homepage.allMovies);
      }
    }
    setState(ViewState.idle);
  }

  void signUp() async{
    FocusScope.of(navigationService.navigatorKey.currentContext!)
        .requestFocus();
    setState(ViewState.busy);
    validateMode = AutovalidateMode.onUserInteraction;
    if(formKey.currentState?.validate() == true){
      final signupSuccess = await authService.signup(name: name.text,password: password.text, emailAddress: email.text);
      if(signupSuccess){
        navigationService.removeAllAndPush(HomePage.route, SplashScreen.route,arguments: Homepage.allMovies);
      }
    }
    setState(ViewState.idle);
  }
}
