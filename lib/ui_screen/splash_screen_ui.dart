import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spectra_horus/ui_screen/process_screens.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: const PageOne(),
      duration: 5000,
      imageSize: 120,
      imageSrc: "assets/images/slogo.png",
      text: "Spectra Horus University",
      textType: TextType.TyperAnimatedText,
      textStyle: GoogleFonts.courgette(
        fontSize: 35.0,
        color: Colors.indigo[800],
      ),
      backgroundColor: Colors.white,
    );
  }
}
// spect app to the process
