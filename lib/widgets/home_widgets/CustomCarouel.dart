// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_demo/utils/quotes.dart';
// import 'package:flutter_demo/widgets/home_widgets/safewebview.dart';

// class CustomCarousel extends StatelessWidget {
//   const CustomCarousel({Key? key}) : super(key: key);
//   void navigateToRoute(BuildContext context, Widget route) {
//     Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: CarouselSlider(
//         options: CarouselOptions(
//           aspectRatio: 2.0,
//           autoPlay: true,
//           enlargeCenterPage: true,
//         ),
//         items: List.generate(
//           imageSliders.length,
//           (index) => Card(
//             elevation: 5.0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: InkWell(
//               onTap: () {
//                 if (index == 0) {
//                   navigateToRoute(
//                     context,
//                     SafeWebView(
//                       url:
//                           "https://gulfnews.com/world/asia/pakistan/womens-day-10-pakistani-women-inspiring-the-country-1.77696239",
//                     ),
//                   );
//                 } else if (index == 1) {
//                   navigateToRoute(
//                     context,
//                     SafeWebView(
//                       url:
//                           "https://plan-international.org/ending-violence/16-ways-end-violence-girls",
//                     ),
//                   );
//                 } else if (index == 2) {
//                   navigateToRoute(
//                     context,
//                     SafeWebView(
//                       url:
//                           "https://www.healthline.com/health/womens-health/self-defense-tips-escape",
//                     ),
//                   );
//                 } else {
//                   navigateToRoute(
//                     context,
//                     SafeWebView(
//                       url:
//                           "https://www.healthline.com/health/womens-health/self-defense-tips-escape",
//                     ),
//                   );
//                 }
//               },

//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),

//                   image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(imageSliders[index]),
//                   ),
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),

//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.black.withOpacity(0.5),
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                   child: Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 8, left: 8),
//                       child: Text(
//                         articleTitle[index],
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: MediaQuery.of(context).size.width * 0.05,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_demo/utils/quotes.dart';
// import 'package:flutter_demo/widgets/home_widgets/safewebview.dart';

// class CustomCarouel extends StatelessWidget {
//   const CustomCarouel({Key? key}) : super(key: key);

//   void navigateToRoute(BuildContext context, Widget route) {
//     Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: CarouselSlider(
//         options: CarouselOptions(
//           aspectRatio: 2.0,
//           autoPlay: true,
//           enlargeCenterPage: true,
//         ),
//         items: List.generate(
//           imageSliders.length,
//           (index) => Card(
//             elevation: 5.0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: InkWell(
//               onTap: () {
//                 if (index == 0) {
//                   navigateToRoute(
//                     context,
//                     SafeWebView(
//                       url:
//                           "https://gulfnews.com/world/asia/pakistan/womens-day-10-pakistani-women-inspiring-the-country-1.77696239",
//                     ),
//                   );
//                 } else if (index == 1) {
//                   navigateToRoute(
//                     context,
//                     SafeWebView(
//                       url:
//                           "https://plan-international.org/ending-violence/16-ways-end-violence-girls",
//                     ),
//                   );
//                 } else if (index == 2) {
//                   navigateToRoute(
//                     context,
//                     SafeWebView(
//                       url:
//                           "https://www.healthline.com/health/womens-health/self-defense-tips-escape",
//                     ),
//                   );
//                 } else {
//                   navigateToRoute(
//                     context,
//                     SafeWebView(
//                       url:
//                           "https://www.healthline.com/health/womens-health/self-defense-tips-escape",
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(imageSliders[index]),
//                   ),
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.black.withOpacity(0.5),
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                   child: Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 8, left: 8),
//                       child: Text(
//                         articleTitle[index],
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: MediaQuery.of(context).size.width * 0.05,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/utils/quotes.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomCarouel extends StatelessWidget {
  const CustomCarouel({super.key});

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: "Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2.0,
          autoPlay: true,
          enlargeCenterPage: true,
        ),
        items: List.generate(
          imageSliders.length,
          (index) => Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                List<String> urls = [
                  "https://gulfnews.com/world/asia/pakistan/womens-day-10-pakistani-women-inspiring-the-country-1.77696239",
                  "https://plan-international.org/ending-violence/16-ways-end-violence-girls",
                  "https://www.healthline.com/health/womens-health/self-defense-tips-escape",
                  "https://www.healthline.com/health/womens-health/self-defense-tips-escape",
                ];
                _launchURL(urls[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(imageSliders[index]),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 8),
                      child: Text(
                        articleTitle[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
