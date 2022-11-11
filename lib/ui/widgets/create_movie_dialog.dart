import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/utils/helpers/extensions.dart';
import 'package:movie_db/services/service_locator.dart';
import 'package:movie_db/ui/widgets/rounded_button.dart';

class CreateMovieDialog extends StatefulWidget {
  const CreateMovieDialog({Key? key, required this.playlistId, required this.makeMoviePublic}) : super(key: key);
  final String playlistId;
  final bool makeMoviePublic;

  @override
  State<CreateMovieDialog> createState() => _CreateMovieDialogState();
}

class _CreateMovieDialogState extends State<CreateMovieDialog> {
  final TextEditingController controller = TextEditingController();
  bool creating = false;
  bool makeMoviePublic = false;

  @override
  void initState() {
    makeMoviePublic = widget.makeMoviePublic;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10.w()),
        height: sizeConfig.screenHeight * 0.225,
        width: sizeConfig.screenWidth * 0.8,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  controller: controller,
                  style: TextStyle(color: sizeConfig.style.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Enter movie name',
                  ),
                ),
                SwitchListTile.adaptive(
                  inactiveTrackColor: Colors.grey,
                  value: makeMoviePublic,
                  onChanged: (newState) {
                    setState(() {
                      makeMoviePublic = newState;
                    });
                  },
                  title: Text(
                    'Make playlist public',
                    style: TextStyle(color: sizeConfig.style.white),
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                          onTap: creating
                              ? null
                              : () async {
                            setState(() {
                              creating = true;
                            });
                            CollectionReference movies =
                            FirebaseFirestore.instance
                                .collection('movies');

                            final doc = await movies.add({
                              'name': controller.text,
                              'isPublic': makeMoviePublic,
                              'owner': authService.currentUser!.uid,
                            });

                            CollectionReference users = FirebaseFirestore
                                .instance
                                .collection('playlist');
                            await users
                                .doc(widget.playlistId)
                                .update({
                              "movies": FieldValue.arrayUnion([doc.id])
                            });
                            navigationService.pop(sendDataBack: doc.id);
                            setState(() {
                              creating = false;
                            });
                          },
                          buttonColor: sizeConfig.style.seaGreen,
                          buttonTitle: 'Add',
                          buttonTitleColor: sizeConfig.style.white,
                          titleFontSize: 18,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
