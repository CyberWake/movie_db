import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/data_models/movie_model.dart';
import 'package:movie_db/business_logic/data_models/playlist_model.dart';
import 'package:movie_db/business_logic/view_models/post_auth/homepage_view_model.dart';
import 'package:movie_db/services/service_locator.dart';
import 'package:movie_db/ui/post_auth/playlist_movies.dart';
import 'package:movie_db/ui/widgets/rounded_button.dart';

class MyPlayList extends StatefulWidget {
  const MyPlayList({Key? key, required this.model}) : super(key: key);
  final HomepageViewModel model;

  @override
  State<MyPlayList> createState() => _MyPlayListState();
}

class _MyPlayListState extends State<MyPlayList> {
  bool updating = false;

  void onTap(PlaylistInfo playlist) async{
    setState(() {
      updating = true;
    });
    final docRef = FirebaseFirestore.instance
        .collection('playlist')
        .doc(playlist.id);
    await docRef.update({
      'visibility': !playlist.visibility
    });
    final updatedPlaylist = PlaylistInfo.fromDocumentSnapshot(await docRef.get());
    for (String movieId in updatedPlaylist.movies) {
      final movieDocRef = FirebaseFirestore.instance
          .collection('movies')
          .doc(movieId);
      final movie = MovieInfo.fromDocumentSnapshot(await movieDocRef.get());
      if(movie.owner == authService.currentUser!.uid) {
        movieDocRef.update({
          'isPublic': updatedPlaylist.visibility
        });
      }
    }
    setState(() {
      updating = false;
    });
    navigationService.pop();
    widget.model.getMyPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PlaylistInfo>>(
        stream: widget.model.playListStream.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasData) {
            if(snapshot.data!.isEmpty){
              return const Center(
                child: Text('Create a playlist to view'),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final playlist = snapshot.data![index];
                  return ListTile(
                    onTap: () {
                      navigationService.pushScreen(
                        PlaylistMovies.route,
                        arguments: [playlist, widget.model],
                      ).then((value) {
                        if (value) {
                          setState(() {});
                        }
                      });
                    },
                    title: Text(playlist.name),
                    trailing: IconButton(
                      onPressed: () {
                        navigationService.pushDialog(
                          AlertDialog(
                            title: Text(playlist.owner ==
                                    authService.currentUser!.uid
                                ? 'Update Movie visibility'
                                : "Oops looks you don't have this permission"),
                            content: Text(
                              'Make movie ${playlist.visibility ? 'private' : 'public'}',
                            ),
                            actions: [
                              SizedBox(
                                width: sizeConfig.screenWidth * 0.25,
                                height: sizeConfig.screenHeight * 0.05,
                                child: RoundedButton(
                                  onTap: navigationService.pop,
                                  buttonColor: sizeConfig.style.seaGreen,
                                  buttonTitle: 'Close',
                                  buttonTitleColor: sizeConfig.style.white,
                                  titleFontSize: 18,
                                ),
                              ),
                              if(playlist.owner ==
                                  authService.currentUser!.uid)
                              SizedBox(
                                width: sizeConfig.screenWidth * 0.25,
                                height: sizeConfig.screenHeight * 0.05,
                                child: RoundedButton(
                                  onTap: updating
                                      ? null
                                      : ()=>onTap(playlist),
                                  buttonColor: sizeConfig.style.seaGreen,
                                  buttonTitle: 'Update',
                                  buttonTitleColor: sizeConfig.style.white,
                                  titleFontSize: 18,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      icon: Icon(playlist.visibility == true
                          ? Icons.lock_open_outlined
                          : Icons.lock_outline_rounded),
                    ),
                  );
                });
          } else {
            return Text(snapshot.hasError ? snapshot.error.toString() : '');
          }
        });
  }
}
