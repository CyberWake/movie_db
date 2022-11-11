import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/utils/helpers/extensions.dart';
import 'package:movie_db/business_logic/view_models/splash_screen_view_model.dart';
import 'package:movie_db/services/service_locator.dart';
import 'package:movie_db/ui/base_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return BaseView<SplashScreenViewModel>(
      onModelReady: (model, _) => model.init(),
      builder: (context, state) {
        return Scaffold(
          backgroundColor: sizeConfig.style.seaGreen,
          body: Center(
            child: SizedBox.square(
              dimension: 180.w(),
              child: const Image(
                image: AssetImage(
                  'assets/logos/logo.png',
                  // height: 100.h(),
                  // width: 100.w(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
