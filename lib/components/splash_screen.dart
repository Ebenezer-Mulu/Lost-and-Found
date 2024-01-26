import 'package:flutter/material.dart';
import 'package:lf/pages/auth/auth_page.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute:
          const AuthPage(), // Replace HomeScreen() with your main app screen
      duration: 3000, // Duration of the splash screen in milliseconds
      imageSize: 150,
      imageSrc:
          "./lib/images/logo.jpg", // Replace with the path to your app logo
      text: "Lost and Found App",
      textType:
          TextType.ColorizeAnimationText, // You can customize the text type
      textStyle: const TextStyle(
        fontSize: 30.0,
      ),
      colors: const [
        Colors.blue,
        Colors.green,
        Colors.orange,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );
  }
}
