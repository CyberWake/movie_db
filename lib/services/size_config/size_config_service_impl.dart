import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/utils/helpers/stylings.dart';
import 'package:movie_db/services/size_config/size_config_service.dart';

class AppSizeConfigImpl implements SizeConfig {
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  double dp = 0.0;
  late Styling style;

  @override
  void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    dp = screenWidth / 160;
    style = Styling.instance;
    style.init();
  }

  double getPropHeight(double staticHeight) {
    return screenHeight * (staticHeight / 896);
  }

  double getPropWidth(double staticWidth) {
    return screenWidth * (staticWidth / 414);
  }
}
