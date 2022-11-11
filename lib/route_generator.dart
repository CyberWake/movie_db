import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/data_models/playlist_model.dart';
import 'package:movie_db/business_logic/utils/constants/enums.dart';
import 'package:movie_db/business_logic/view_models/post_auth/homepage_view_model.dart';
import 'package:movie_db/ui/post_auth/homepage.dart';
import 'package:movie_db/ui/post_auth/playlist_movies.dart';
import 'package:movie_db/ui/pre_auth/login_signup.dart';
import 'package:movie_db/ui/splash_screen.dart';

class RouteGenerator {
  RouteGenerator();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    switch (settings.name) {
      case SplashScreen.route:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case LoginSignupPage.route:
        return MaterialPageRoute(
          builder: (_) => const LoginSignupPage(),
        );
      case HomePage.route:
        final argument = settings.arguments as Homepage;
        return MaterialPageRoute(
          builder: (_) => HomePage(
            tab: argument,
          ),
        );
      case PlaylistMovies.route:
        final argument = settings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (_) => PlaylistMovies(
            playlist: argument[0] as PlaylistInfo,
            model: argument[1] as HomepageViewModel,
          ),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
            backgroundColor: Theme.of(_).scaffoldBackgroundColor,
          ),
          body: const Center(
            child: Text('Something went wrong!'),
          ),
        );
      },
    );
  }
}
