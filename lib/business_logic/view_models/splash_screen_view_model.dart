import 'package:movie_db/business_logic/utils/constants/enums.dart';
import 'package:movie_db/business_logic/view_models/base_view_model.dart';
import 'package:movie_db/services/service_locator.dart';
import 'package:movie_db/ui/post_auth/homepage.dart';
import 'package:movie_db/ui/pre_auth/login_signup.dart';

class SplashScreenViewModel extends BaseModel {
  SplashScreenViewModel(initialState) : super(initialState);

  void init() {
    Future.delayed(const Duration(seconds: 1)).then(
      (value) async {
        // await authService.signOut();
        if(await authService.isLoggedIn()){
          navigationService.pushReplacementScreen(HomePage.route,arguments: Homepage.allMovies);
        }else{
          navigationService.pushReplacementScreen(LoginSignupPage.route);
        }
      },
    );
  }
}
