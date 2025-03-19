import 'package:flutter/material.dart';
// import 'package:flutter_demo/child/child_login_screen.dart';
import 'package:lottie/lottie.dart';

class OnboardingItem {
  final String lottieAsset;
  final String title;     // ✅ Add title
  final String subtitle;  // ✅ Add subtitle

  OnboardingItem({
    required this.lottieAsset,
    required this.title,
    required this.subtitle,
  });
}

List<OnboardingItem> onboardintItems = [
  OnboardingItem(
    lottieAsset: "assets/animations/intro.json",
    title: "Welcome to Our App",
    subtitle: "Move fearlessly! Stay safe, stay connected—because your security matters.",
  ),
  OnboardingItem(
    lottieAsset: "assets/animations/homepage.json",
    title: "Home Page",
    subtitle: "Inspire. Stay Safe. Explore. Get daily motivation, one-tap emergency help, instant location sharing, and career opportunities—all in one place!",
  ),
   OnboardingItem(
    lottieAsset: "assets/animations/contact.json",
    title: "Contact-Page",
    subtitle: "Instant Help, Just a Shake Away! Add trusted contacts to receive emergency alerts with a quick shake.",
  ),
  
  OnboardingItem(
    lottieAsset: "assets/animations/chat.json",
    title: "Chat-Page",
    subtitle: "Stay Connected, Stay Secure! Chat with guardians safely—your data is backed up on the cloud, protecting crucial evidence even if your phone is lost." ,
  ),
  OnboardingItem(
    lottieAsset: "assets/animations/maps_page.json",
    title: "Maps",
    subtitle: "Stay Aware, Stay Safe! View alerted areas on the map and navigate with confidence.",
  ),
  OnboardingItem(
    lottieAsset: "assets/animations/reviewpage.json",
    title: "Review Page",
    subtitle: "Share Your Experience! Rate and review places you visit to help others stay informed and safe.",
  ),
  OnboardingItem(
    lottieAsset: "assets/animations/profile_update.json",
    title: "Profile Page",
    subtitle: "Your Identity, Your Control! Update your credentials and profile picture anytime to keep your information up to date." ,
  ),
];

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  final PageController pageController=PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFECE1EE),
      body: Stack(
        children: [
          CustomPaint(
            painter: ArcPaint(),
            size: Size(size.width, size.height / 1.35),
          ),
          Positioned(
   top: 70,
   left: 0,
   right: 0,
   child: SizedBox(
     height: size.height * 0.4, // Adjust height dynamically
     width: size.width * 0.8,  // Adjust width dynamically
       child: Lottie.asset(
       onboardintItems[currentIndex].lottieAsset,
       fit: BoxFit.contain, // Ensure it scales properly
     ),
   ),
 ),

           Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height:270,
                child: Column(
                  children: [
                    Flexible(
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: onboardintItems.length ,
                        itemBuilder: (context,index){
                          
                          final items=onboardintItems[index];
                  return Column(
                    children: [
                       const SizedBox(height: 16),
                        Text(
                              items.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Color(0xFF0C0000),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding
                           (
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              items.subtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF43061E),
                              ),
                            ),),
                    ],
                    );
                    },
                    onPageChanged: (value){
                     setState(() {
                       currentIndex=value;
                     });
                    },
                    ),
                    ),
                    //dot indicator
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for(int index=0;index<onboardintItems.length;index++)
                        dotIndicator(isSelected: index==currentIndex ),
                      ],),
                      const SizedBox(height:50),
                    ],
                    )
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed:(){
 if (currentIndex <onboardintItems.length - 1) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear,
            );
          } else {
            Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Container()));// ✅ Navigate to Login
          }      } ,
      elevation: 0,
      backgroundColor: Color(0xFFECE1EE),
      child: Icon(Icons.arrow_forward_ios,color: Color(0xFF43061E),),
      ),
    );
  }
  Widget dotIndicator({required bool isSelected}){
    return Padding(padding: EdgeInsets.only(right:7),
    child: AnimatedContainer(duration: Duration(microseconds: 500),
    height: isSelected?8:6,
    width: isSelected?8:6,
    decoration: BoxDecoration(shape: BoxShape.circle,
    color: isSelected?Color(0xFF43061E):Colors.black26,),
    ));
  }

}

class ArcPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path orangeArc = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 175)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 175)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(orangeArc, Paint()..color = Color(0xFF43061E));

    Path whiteArc = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 180)
      ..quadraticBezierTo(size.width / 2, size.height - 60, size.width, size.height - 180)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(whiteArc, Paint()..color = Color(0xFF9F80A7));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}