import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/data_models/movie_model.dart';
import 'package:movie_db/services/service_locator.dart';
import 'package:movie_db/ui/widgets/rounded_button.dart';

class ChangeMovieVisibilityDialog extends StatelessWidget {
  const ChangeMovieVisibilityDialog({
    Key? key,
    required this.movie,
    required this.isBusy,
    required this.onTapUpdate,
  }) : super(key: key);

  final MovieInfo movie;
  final bool isBusy;
  final void Function() onTapUpdate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(movie.owner == authService.currentUser!.uid
          ? 'Update Movie visibility'
          : "Oops looks you don't have this permission"),
      content: Text(
        'Make movie ${movie.isPublic ? 'private' : 'public'}',
      ),
      actions: [
        SizedBox(
          width: sizeConfig.screenWidth * 0.25,
          height: sizeConfig.screenHeight * 0.05,
          child: RoundedButton(
            onTap: navigationService.pop,
            buttonColor: sizeConfig.style.seaGreen,
            buttonTitle: movie.owner != authService.currentUser!.uid
                ? 'Close'
                : 'Cancel',
            buttonTitleColor: sizeConfig.style.white,
            titleFontSize: 18,
          ),
        ),
        if (movie.owner == authService.currentUser!.uid)
          SizedBox(
            width: sizeConfig.screenWidth * 0.25,
            height: sizeConfig.screenHeight * 0.05,
            child: RoundedButton(
              onTap: isBusy ? null : onTapUpdate,
              buttonColor: sizeConfig.style.seaGreen,
              buttonTitle: 'Update',
              buttonTitleColor: sizeConfig.style.white,
              titleFontSize: 18,
            ),
          )
      ],
    );
  }
}