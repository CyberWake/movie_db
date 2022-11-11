import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/utils/constants/enums.dart';
import 'package:movie_db/business_logic/utils/helpers/extensions.dart';
import 'package:movie_db/business_logic/view_models/pre_auth/login_signup_view_model.dart';
import 'package:movie_db/services/service_locator.dart';
import 'package:movie_db/ui/base_view.dart';
import 'package:movie_db/ui/widgets/rounded_button.dart';
import 'package:movie_db/ui/widgets/space_v.dart';

class LoginSignupPage extends StatelessWidget {
  const LoginSignupPage({Key? key}) : super(key: key);
  static const String route = '/auth';

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginSignupViewModel>(
      onModelReady: (model, _) => model.init(),
      builder: (context, state) {
        // state.setState(ViewState.idle);
        return DefaultTabController(
          length: 2,
          child: Scaffold(
              body: SafeArea(
            child: Form(
              key: state.formKey,
              autovalidateMode: state.validateMode,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          height: 180.w(), color: sizeConfig.style.seaGreen),
                      SizedBox.square(
                        dimension: 180.w(),
                        child: const Image(
                          image: AssetImage(
                            'assets/logos/logo.png',
                            // height: 100.h(),
                            // width: 100.w(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Container(
                      color: Colors.green,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 60.h(),
                            child: TabBar(
                              indicatorColor: sizeConfig.style.white,
                              onTap: state.switchTab,
                              tabs: [
                                Text(
                                  "Signup",
                                  style: TextStyle(fontSize: 18.w()),
                                ),
                                Text(
                                  "Login",
                                  style: TextStyle(fontSize: 18.w()),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: state.scrollController,
                      padding: EdgeInsets.all(15.w()),
                      children: [
                        AnimatedCrossFade(
                          firstChild: Padding(
                            padding: EdgeInsets.only(top: 10.h()),
                            child: TextFormField(
                              controller: state.name,
                              focusNode: state.nameFocus,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: state.submit,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: 'Enter your name',
                                hintText: "Let's know your good name",
                                suffixIcon: state.name.text.isEmpty
                                    ? null
                                    : IconButton(
                                        onPressed: state.clearName,
                                        icon: const Icon(Icons.clear),
                                      ),
                              ),
                            ),
                          ),
                          secondChild: const SizedBox(),
                          crossFadeState:
                              state.currentPage == LoginSignupState.signup
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 250),
                        ),
                        const SpaceV(20),
                        TextFormField(
                          validator: state.validateEmail,
                          controller: state.email,
                          focusNode: state.emailFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: state.submit,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Enter your email',
                            hintText: "Provide a email to continue",
                            suffixIcon: state.email.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: state.clearEmail,
                                    icon: const Icon(Icons.clear),
                                  ),
                          ),
                        ),
                        const SpaceV(20),
                        TextFormField(
                          controller: state.password,
                          focusNode: state.passwordFocus,
                          validator: state.validatePassword,
                          textInputAction:
                              state.currentPage == LoginSignupState.signup
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                          obscureText: state.obSecurePassword,
                          onFieldSubmitted: state.submit,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Enter your password',
                            hintText: "Choose a strong password",
                            suffixIcon: state.email.text.isEmpty
                                ? IconButton(
                                    onPressed: state.togglePasswordObSecure,
                                    icon: Icon(state.obSecurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_rounded),
                                  )
                                : SizedBox(
                                    width: 105.w(),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed:
                                              state.togglePasswordObSecure,
                                          icon: Icon(state.obSecurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_rounded),
                                        ),
                                        IconButton(
                                          onPressed: state.clearPassword,
                                          icon: const Icon(Icons.clear),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        const SpaceV(10),
                        AnimatedCrossFade(
                          firstCurve: Curves.bounceIn,
                          firstChild: Padding(
                            padding: EdgeInsets.only(top: 10.h()),
                            child: TextFormField(
                              controller: state.confirmPassword,
                              focusNode: state.confirmPasswordFocus,
                              validator: state.validateConfirmPassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: state.submit,
                              obscureText: state.obSecureConfirmPassword,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: 'Confirm your password',
                                hintText: "Re-enter your password",
                                suffixIcon: state.email.text.isEmpty
                                    ? IconButton(
                                        onPressed:
                                            state.toggleConfirmPasswordObSecure,
                                        icon: Icon(state.obSecureConfirmPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_rounded),
                                      )
                                    : SizedBox(
                                        width: 105.w(),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: state
                                                  .toggleConfirmPasswordObSecure,
                                              icon: Icon(state
                                                      .obSecureConfirmPassword
                                                  ? Icons
                                                      .visibility_off_outlined
                                                  : Icons.visibility_rounded),
                                            ),
                                            IconButton(
                                              onPressed:
                                                  state.clearConfirmPassword,
                                              icon: const Icon(Icons.clear),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          secondChild: const SizedBox(),
                          crossFadeState:
                              state.currentPage == LoginSignupState.signup
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 250),
                        ),
                        const SpaceV(20),
                        SizedBox(
                          height: 50.h(),
                          width: 200.w(),
                          child: RoundedButton(
                            onTap: state.isBusy
                                ? null
                                : state.currentPage == LoginSignupState.signup
                                    ? state.signUp
                                    : state.login,
                            buttonColor: sizeConfig.style.seaGreen,
                            buttonTitle:
                                state.currentPage == LoginSignupState.signup
                                    ? 'Signup'
                                    : 'Login',
                            buttonTitleColor: sizeConfig.style.white,
                            titleFontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
        );
      },
    );
  }
}
