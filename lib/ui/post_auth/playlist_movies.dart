import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/data_models/movie_model.dart';
import 'package:movie_db/business_logic/data_models/playlist_model.dart';
import 'package:movie_db/business_logic/utils/helpers/extensions.dart';
import 'package:movie_db/business_logic/view_models/post_auth/homepage_view_model.dart';
import 'package:movie_db/services/service_locator.dart';
import 'package:movie_db/ui/widgets/create_movie_dialog.dart';
import 'package:movie_db/ui/widgets/rounded_button.dart';
import 'package:movie_db/ui/widgets/space_v.dart';

class PlaylistMovies extends StatefulWidget {
  const PlaylistMovies({
    Key? key,
    required this.playlist,
    required this.model,
  }) : super(key: key);
  final PlaylistInfo playlist;
  final HomepageViewModel model;
  static const String route = '/playlist';

  @override
  State<PlaylistMovies> createState() => _PlaylistMoviesState();
}

class _PlaylistMoviesState extends State<PlaylistMovies> {
  late Future<List<MovieInfo>> future;
  late List<String> movieIds;
  bool updating = false;
  bool movieAdded = false;

  @override
  void initState() {
    movieIds = widget.playlist.movies.map((e) => e.toString()).toList();
    if (movieIds.isNotEmpty) {
      future = widget.model.getPlaylistMovies(movieIds);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist.name),
        leading: IconButton(
          onPressed: () => navigationService.pop(sendDataBack: movieAdded),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: movieIds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No Movies Added'),
                  const SpaceV(30),
                  SizedBox(
                    width: 150.w(),
                    height: 50.h(),
                    child: RoundedButton(
                      onTap: () {
                        navigationService
                            .pushDialog(CreateMovieDialog(
                          playlistId: widget.playlist.id,
                          makeMoviePublic: widget.playlist.visibility,
                        ))
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              movieIds.add(value);
                              movieAdded = true;
                              future = widget.model.getPlaylistMovies(movieIds);
                            });
                          }
                        });
                      },
                      buttonColor: sizeConfig.style.seaGreen,
                      buttonTitle: 'Add',
                      buttonTitleColor: sizeConfig.style.white,
                      titleFontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : FutureBuilder<List<MovieInfo>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final movie = snapshot.data![index];
                      return ListTile(
                        onTap: () {
                          navigationService.pushDialog(
                            AlertDialog(
                              title: const Text('Update Movie visibility'),
                              content: Text(
                                'Make moive ${movie.isPublic ? 'private' : 'public'}',
                              ),
                              actions: [
                                SizedBox(
                                  width: sizeConfig.screenWidth * 0.25,
                                  height: sizeConfig.screenHeight * 0.05,
                                  child: RoundedButton(
                                    onTap: navigationService.pop,
                                    buttonColor: sizeConfig.style.seaGreen,
                                    buttonTitle: 'Cancel',
                                    buttonTitleColor: sizeConfig.style.white,
                                    titleFontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  width: sizeConfig.screenWidth * 0.25,
                                  height: sizeConfig.screenHeight * 0.05,
                                  child: RoundedButton(
                                    onTap: updating
                                        ? null
                                        : () async {
                                      setState(() {
                                        updating = true;
                                      });
                                      final DocumentReference movieRef =
                                      FirebaseFirestore.instance
                                          .collection('movies').doc(movie.id);

                                      await movieRef.update({
                                        'isPublic': !movie.isPublic,
                                      });
                                      navigationService.pop();
                                      setState(() {
                                        updating = false;
                                        future = widget.model
                                            .getPlaylistMovies(movieIds);
                                      });
                                    },
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
                        title: Text(movie.name),
                        trailing: Icon(movie.isPublic
                            ? Icons.lock_open_outlined
                            : Icons.lock_outline_rounded),
                      );
                    },
                  );
                } else if (snapshot.error.toString() ==
                    Exception('No Movies added').toString()) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(snapshot.error.toString()),
                        const SpaceV(30),
                        SizedBox(
                          width: 150.w(),
                          height: 50.h(),
                          child: RoundedButton(
                            onTap: () {
                              navigationService
                                  .pushDialog(CreateMovieDialog(
                                playlistId: widget.playlist.id,
                                makeMoviePublic: widget.playlist.visibility,
                              ))
                                  .then((value) {
                                if (value != null) {
                                  setState(() {
                                    movieIds.add(value);
                                    movieAdded = true;
                                    future = widget.model
                                        .getPlaylistMovies(movieIds);
                                  });
                                }
                              });
                            },
                            buttonColor: sizeConfig.style.seaGreen,
                            buttonTitle: 'Add',
                            buttonTitleColor: sizeConfig.style.white,
                            titleFontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text('Something went wrong');
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigationService
              .pushDialog(CreateMovieDialog(
            playlistId: widget.playlist.id,
            makeMoviePublic: widget.playlist.visibility,
          ))
              .then((value) {
            if (value != null) {
              setState(() {
                movieIds.add(value);
                movieAdded = true;
                future = widget.model.getPlaylistMovies(movieIds);
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
