import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kgs_mobile_v2/pages/login.dart';
import 'package:kgs_mobile_v2/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivoryWhite,
      body: Center(
        child: Animate(
          effects: const [
            FadeEffect(duration: Duration(seconds: 3)),
          ],
          child: Center(
            child: Image.asset(
              "assets/images/kgs_logo.png",
              height: 150,
              width: 200,
            ),
          ),
        ),
      ),
    );
  }
}
