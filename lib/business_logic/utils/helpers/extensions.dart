import 'package:movie_db/services/service_locator.dart';

extension SizeOnDouble on double {
  double h() {
    return sizeConfig.getPropHeight(this);
  }

  double w() {
    return sizeConfig.getPropWidth(this);
  }
}

extension SizeOnInt on int {
  double h() {
    return sizeConfig.getPropHeight(toDouble());
  }

  double w() {
    return sizeConfig.getPropWidth(toDouble());
  }
}