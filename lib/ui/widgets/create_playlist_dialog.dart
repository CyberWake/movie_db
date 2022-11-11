import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/utils/helpers/extensions.dart';
import 'package:movie_db/services/service_locator.dart';
import 'package:movie_db/ui/widgets/rounded_button.dart';

class CreatePlaylistDialog extends StatefulWidget {
  const CreatePlaylistDialog({Key? key}) : super(key: key);

  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final TextEditingController controller = TextEditingController();
  bool creating = false;
  bool playlistPublic = false;

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
                    labelText: 'Enter playlist name',
                  ),
                ),
                SwitchListTile.adaptive(
                  inactiveTrackColor: Colors.grey,
                  value: playlistPublic,
                  onChanged: (newState) {
                    setState(() {
                      playlistPublic = newState;
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
                                  CollectionReference playlist =
                                      FirebaseFirestore.instance
                                          .collection('playlist');

                                  final doc = await playlist.add({
                                    'name': controller.text,
                                    'ownner': authService.currentUser!.uid,
                                    'visibility': playlistPublic
                                  });

                                  CollectionReference users = FirebaseFirestore
                                      .instance
                                      .collection('users');
                                  await users
                                      .doc(authService.currentUser!.uid)
                                      .update({
                                    "playlists": FieldValue.arrayUnion([doc.id])
                                  });
                                  navigationService.pop();
                                  setState(() {
                                    creating = false;
                                  });
                                },
                          buttonColor: sizeConfig.style.seaGreen,
                          buttonTitle: 'Create',
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
