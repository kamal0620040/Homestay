import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestay/providers/user_provider.dart';
import 'package:homestay/screens/post_detail.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../widgets/post_card.dart';
import '../widgets/text_field_input.dart';

class Favourite extends StatefulWidget {
  String currentUser;
  Favourite({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<String> fav = [];
  Future<void> getAllFavourite() async {
    final docRef = FirebaseFirestore.instance
        .collection('favourite')
        .where('userId', isEqualTo: widget.currentUser);
    final docSnapshot = await docRef.get();
    docSnapshot.docs.forEach(
      (doc) {
        setState(() {
          fav.add(
            doc.get('postId').toString(),
          );
        });
      },
    );
    print(fav);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllFavourite();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Favourites:",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                fav.length > 0
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('post')
                            .where("postId", whereIn: fav)
                            .where("")
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () => {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PostDetail(
                                      snap: snapshot.data!.docs[index].data(),
                                      currentUser: user.uid,
                                    ),
                                  ),
                                )
                              },
                              child: PostCard(
                                snap: snapshot.data!.docs[index].data(),
                                currentUser: user.uid,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.hourglass_empty),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                "Nothing to show.",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
