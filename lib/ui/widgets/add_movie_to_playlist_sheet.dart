import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/data_models/movie_model.dart';
import 'package:movie_db/business_logic/data_models/playlist_model.dart';
import 'package:movie_db/services/service_locator.dart';

class AddMovieToPlayListBottomSheet extends StatelessWidget {
  const AddMovieToPlayListBottomSheet({
    Key? key,
    required this.movie,
    required this.myPlaylists,
  }) : super(key: key);

  final MovieInfo movie;
  final List<PlaylistInfo> myPlaylists;

  @override
  Widget build(BuildContext context) {

    void onTap(int index) async {
      await FirebaseFirestore.instance
          .collection('playlist')
          .doc(myPlaylists[index].id)
          .update({
        'movies': FieldValue.arrayUnion([movie.id])
      });
      navigationService.pop();
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
      child: SizedBox(
        height: sizeConfig.screenHeight * 0.5,
        child: ListView.builder(
          itemCount: myPlaylists.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: ()=>onTap(index),
              title: Text(myPlaylists[index].name),
              trailing: Icon(myPlaylists[index].visibility
                  ? Icons.lock_open_outlined
                  : Icons.lock_outline_rounded),
            );
          },
        ),
      ),
    );
  }
}