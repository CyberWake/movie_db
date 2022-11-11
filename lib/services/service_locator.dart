import 'package:get_it/get_it.dart';
import 'package:movie_db/business_logic/view_models/post_auth/homepage_view_model.dart';
import 'package:movie_db/business_logic/view_models/pre_auth/login_signup_view_model.dart';
import 'package:movie_db/business_logic/view_models/splash_screen_view_model.dart';
import 'package:movie_db/services/auth/auth_service_firebase.dart';
import 'package:movie_db/services/navigation/navigation_service_impl.dart';
import 'package:movie_db/services/size_config/size_config_service_impl.dart';

GetIt serviceLocator = GetIt.instance;
final navigationService = serviceLocator<AppNavigationServiceImpl>();
final sizeConfig = serviceLocator<AppSizeConfigImpl>();
final authService = serviceLocator<FirebaseAuthService>();

void setupServiceLocator() {
  serviceLocator.registerSingleton(AppSizeConfigImpl());
  serviceLocator.registerSingleton(AppNavigationServiceImpl());
  serviceLocator.registerSingleton(FirebaseAuthService());

  serviceLocator.registerFactory(() => SplashScreenViewModel(null));
  serviceLocator.registerFactory(() => LoginSignupViewModel(null));
  serviceLocator.registerFactory(() => HomepageViewModel(null));
}
