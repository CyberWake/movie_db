import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/data_models/movie_model.dart';
import 'package:movie_db/business_logic/view_models/post_auth/homepage_view_model.dart';
import 'package:movie_db/ui/widgets/add_movie_to_playlist_sheet.dart';

class AllMovieList extends StatelessWidget {
  const AllMovieList({
    Key? key, required this.state,
  }) : super(key: key);
  final HomepageViewModel state;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MovieInfo>>(
      stream: state.movieStream.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.data != null) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  onChanged: state.searchMovie,
                ),
              ),
              if (snapshot.data!.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final movie = snapshot.data![index];
                      return ListTile(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape:
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                            ),
                            isScrollControlled: true,
                            builder: (context) {
                              return AddMovieToPlayListBottomSheet(
                                movie: movie,
                                myPlaylists:
                                state.myPlaylists,
                              );
                            },
                          );
                        },
                        title: Text(movie.name),
                        trailing: IconButton(
                          onPressed: ()=>state.updateVisibility(movie),
                          icon: Icon(movie.isPublic
                              ? Icons.lock_open_outlined
                              : Icons.lock_outline_rounded),
                        ),
                      );
                    },
                  ),
                ),
              if (snapshot.data!.isEmpty)
                TextButton(
                    onPressed: state.addMovie,
                    child: const Text('Add this to database'))
            ],
          );
        } else {
          return const Center(
            child: Text("Something went wrong"),
          );
        }
      },
    );
  }
}