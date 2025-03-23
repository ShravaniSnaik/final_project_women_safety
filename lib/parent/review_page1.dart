import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/PrimaryButton.dart';
import 'package:flutter_application_2/components/custom_textfield.dart';
import 'package:flutter_application_2/parent/my_drawer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReviewPage1 extends StatefulWidget {
  const ReviewPage1({super.key});

  @override
  State<ReviewPage1> createState() => _ReviewPage1State();
}

class _ReviewPage1State extends State<ReviewPage1> {
  final TextEditingController locationC = TextEditingController();
  final TextEditingController viewsC = TextEditingController();
  bool isSaving = false;
  double ratings = 1.0; // Default rating

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          title: Text("Review your place"),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    hintText: 'Enter location',
                    controller: locationC,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: viewsC,
                    hintText: 'Enter your review',
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 15),
                RatingBar.builder(
                  initialRating: ratings,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  unratedColor: Color(0xFFECE1EE),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder:
                      (context, _) =>
                          const Icon(Icons.star, color: Color(0xFF43061E)),
                  onRatingUpdate: (rating) {
                    setState(() {
                      ratings = rating;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            PrimaryButton(
              title: "SAVE",
              onPressed: () {
                saveReview();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> saveReview() async {
  //   if (locationC.text.isEmpty || viewsC.text.isEmpty) {
  //     Fluttertoast.showToast(msg: 'Please enter all fields');
  //     return;
  //   }

  //   setState(() {
  //     isSaving = true;
  //   });

  //   await FirebaseFirestore.instance
  //       .collection('reviews')
  //       .add({
  //         'location': locationC.text,
  //         'views': viewsC.text,
  //         'ratings': ratings,
  //       })
  //       .then((value) {
  //         setState(() {
  //           isSaving = false;
  //           locationC.clear();
  //           viewsC.clear();
  //           ratings = 1.0; // Reset rating
  //         });
  //         Fluttertoast.showToast(msg: 'Review uploaded successfully');
  //       })
  //       .catchError((error) {
  //         setState(() {
  //           isSaving = false;
  //         });
  //         Fluttertoast.showToast(msg: 'Error uploading review');
  //       });
  // }
  Future<void> saveReview() async {
    if (locationC.text.isEmpty || viewsC.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter all fields');
      return;
    }

    setState(() {
      isSaving = true;
    });

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Convert location to lowercase for case-insensitive storage
    String locationKey = locationC.text.trim().toLowerCase();
    DocumentReference locationRef = firestore
        .collection('locations')
        .doc(locationKey);

    // Store review in 'reviews' collection
    await firestore.collection('reviews').add({
      'location': locationKey, // Store in lowercase
      'views': viewsC.text,
      'ratings': ratings,
    });

    // Update the average rating in 'locations' collection
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot locationSnapshot = await transaction.get(locationRef);

      if (!locationSnapshot.exists) {
        // If location doesn't exist, create it with first review data
        transaction.set(locationRef, {
          'averageRating': ratings,
          'reviewCount': 1,
        });
      } else {
        // If location exists, update its average rating
        double currentAvg = locationSnapshot['averageRating'];
        int count = locationSnapshot['reviewCount'];

        double newAvg = ((currentAvg * count) + ratings) / (count + 1);
        transaction.update(locationRef, {
          'averageRating': newAvg,
          'reviewCount': count + 1,
        });
      }
    });

    setState(() {
      isSaving = false;
      locationC.clear();
      viewsC.clear();
      ratings = 1.0;
    });

    Fluttertoast.showToast(msg: 'Review uploaded successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECE1EE),
      appBar: AppBar(
        backgroundColor: Color(0xFF43061E),
        title: Text(
          'Your Views Are Important For Us ',
          style: TextStyle(
            color: Color(0xFFECE1EE),
            fontSize: 20,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      drawer: MyDrawer(),
      body:
          isSaving
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Recent Reviews",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0C0000),
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream:
                            FirebaseFirestore.instance
                                .collection('reviews')
                                .snapshots(),
                        builder: (
                          context,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                        ) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(child: Text("No reviews yet."));
                          }

                          return ListView.separated(
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Card(
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "Location: ", // Bold "Location"
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Color(0xFF0C0000),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    data['location'], // Normal text
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xFF0C0000),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "Comments: ", // Bold "Comments"
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Color(0xFF0C0000),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    data['views'], // Normal text
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF0C0000),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        RatingBar.builder(
                                          initialRating:
                                              (data['ratings'] as num?)
                                                  ?.toDouble() ??
                                              1.0,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          itemCount: 5,
                                          ignoreGestures: true,
                                          unratedColor: Color(0xFFECE1EE),
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 4.0,
                                              ),
                                          itemBuilder:
                                              (context, _) => const Icon(
                                                Icons.star,
                                                color: Color(0xFF43061E),
                                              ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF43061E), // Changed background color
        onPressed: () {
          showAlert(context);
        },
        child: Icon(Icons.add, color: Color(0xFFECE1EE)),
      ),
    );
  }
}
