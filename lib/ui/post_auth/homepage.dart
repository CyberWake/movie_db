import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/utils/constants/enums.dart';
import 'package:movie_db/business_logic/utils/helpers/extensions.dart';
import 'package:movie_db/business_logic/view_models/post_auth/homepage_view_model.dart';
import 'package:movie_db/services/service_locator.dart';
import 'package:movie_db/ui/base_view.dart';
import 'package:movie_db/ui/post_auth/Components/all_movies.dart';
import 'package:movie_db/ui/post_auth/Components/playlist.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.tab}) : super(key: key);
  final Homepage tab;
  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    return BaseView<HomepageViewModel>(
      onModelReady: (model, vsync) => model.init(vsync),
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 60.h(),
                          child: TabBar(
                            controller: state.tabController,
                            indicatorColor: sizeConfig.style.white,
                            // onTap: state.switchTab,
                            tabs: [
                              Text(
                                "All Movies",
                                style: TextStyle(fontSize: 18.w()),
                              ),
                              Text(
                                "My Playlist",
                                style: TextStyle(fontSize: 18.w()),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: state.tabController,
                    children: [
                      AllMovieList(state: state,),
                      MyPlayList(model: state)
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: state.currentPage == 0
                ? null
                : FloatingActionButton(
                    onPressed: state.createPlaylistPopUp,
                    child: const Icon(Icons.add),
                  ),
          ),
        );
      },
    );
  }
}
