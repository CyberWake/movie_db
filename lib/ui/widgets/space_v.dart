import 'package:flutter/cupertino.dart';
import 'package:movie_db/business_logic/utils/helpers/extensions.dart';

class SpaceV extends StatelessWidget {
  const SpaceV(this.height,{Key? key}) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h(),
    );
  }
}
