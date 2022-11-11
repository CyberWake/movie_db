import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/data_models/movie_model.dart';
import 'package:movie_db/business_logic/data_models/playlist_model.dart';
import 'package:movie_db/business_logic/utils/constants/enums.dart';
import 'package:movie_db/business_logic/view_models/base_view_model.dart';
import 'package:movie_db/services/service_locator.dart';
import 'package:movie_db/ui/widgets/create_playlist_dialog.dart';
import 'package:movie_db/ui/widgets/movie_visibility_update_dialog.dart';

class HomepageViewModel extends BaseModel {
  HomepageViewModel(super.initialState);
  late TabController tabController;
  int currentPage = 0;
  final movieStream = StreamController<List<MovieInfo>>.broadcast();
  final playListStream = StreamController<List<PlaylistInfo>>.broadcast();
  List<PlaylistInfo> myPlaylists = [];
  List<MovieInfo> allMovies = [];
  String searchString = "";

  void init(TickerProviderStateMixin vsync) {
    tabController = TabController(length: 2, vsync: vsync);
    tabController.addListener(() {
      currentPage = tabController.index;
      if(currentPage == 1){
        getMyPlaylist();
      }else{
        getMoviesList();
      }
      emit(currentPage);
    });
    emit(tabController);
    getMoviesList();
    getMyPlaylist();
  }

  Future<void> getMoviesList() async {
    final CollectionReference movies =
        FirebaseFirestore.instance.collection('movies');
    final movieSnap = await movies.orderBy('name').get();
    movieSnap.docs.removeWhere((movieQueryDocumentSnapshot) {
      final movie = MovieInfo.fromDocumentSnapshot(movieQueryDocumentSnapshot);
      return movie.isPublic || movie.owner == authService.currentUser!.uid;
    });
    allMovies =
        movieSnap.docs.map((e) => MovieInfo.fromDocumentSnapshot(e)).toList();
    movieStream.add(allMovies);
  }

  Future<void> getMyPlaylist() async {
    final myPlaylistIDs = await FirebaseFirestore.instance
        .collection('users')
        .doc(authService.currentUser!.uid)
        .get();
    if(myPlaylistIDs.data()!['playlist'] != null && (myPlaylistIDs.data()!['playlist'] as List).isNotEmpty ) {
      final documents = await FirebaseFirestore.instance
          .collection('playlist')
          .where(FieldPath.documentId,
          whereIn: myPlaylistIDs.data()!['playlists'])
          .get();
      myPlaylists = documents.docs
          .map((e) => PlaylistInfo.fromDocumentSnapshot(e))
          .toList();
      playListStream.add(myPlaylists);
    }else{
      playListStream.add([]);
    }
  }

  Future<List<MovieInfo>> getPlaylistMovies(
      List<dynamic>? playlistId) async {
    if (playlistId == null) {
      throw Exception('No Movies added');
    } else {
      return (await FirebaseFirestore.instance
          .collection('movies')
          .where(FieldPath.documentId,
              whereIn: playlistId.map((e) => e.toString()).toList())
          .get()).docs.map((e) => MovieInfo.fromDocumentSnapshot(e)).toList();
    }
  }

  void updateMovieVisibility(MovieInfo movie) async {
    if(movie.owner != authService.currentUser!.uid) return;
    setState(ViewState.busy);
    final DocumentReference movieRef =
    FirebaseFirestore.instance
        .collection('movies').doc(movie.id);

    await movieRef.update({
      'isPublic': !movie.isPublic,
    });
    navigationService.pop();
    await getMoviesList();
    setState(ViewState.idle);
  }
  
  void searchMovie(String? value)async{
    if(value == null ||value.isEmpty){
      searchString = "";
      getMoviesList();
      return;
    }
    searchString = value;
    final CollectionReference movies =
    FirebaseFirestore.instance.collection('movies');
    final movieSnap = await movies.orderBy('name').get();
    allMovies = movieSnap.docs.map((e) => MovieInfo.fromDocumentSnapshot(e)).toList();
    allMovies.removeWhere((element) => !element.name.startsWith(value));
    movieStream.add(allMovies);
  }

  void addMovie()async{
    if(searchString.isEmpty) return;
    await FirebaseFirestore.instance.collection('movies').doc().set({'name': searchString,'isPublic':true,'owner':authService.currentUser!.uid});
    searchMovie(searchString);
  }

  void createPlaylistPopUp(){
    navigationService.pushDialog(
      const CreatePlaylistDialog(),
      isDismissible: true,
    );
  }

  void updateVisibility(MovieInfo movie) {
    navigationService.pushDialog(
      ChangeMovieVisibilityDialog(
        movie: movie,
        isBusy: isBusy,
        onTapUpdate: () => updateMovieVisibility(
            movie),
      ),
    );
  }
}
