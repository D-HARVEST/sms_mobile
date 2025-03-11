import 'dart:async';
import 'package:sms_mobile_api/homepage/home.dart';
import 'package:flutter/material.dart';


class SplashScreenEDV extends StatefulWidget {
  const SplashScreenEDV({Key? key}) : super(key: key);

  @override
  State<SplashScreenEDV> createState() => _SplashScreenEDVState();
}

class _SplashScreenEDVState extends State<SplashScreenEDV>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Initialiser le contrôleur d'animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..forward(); 
    
    
    // Appliquer une animation de type 'easeIn'
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Transition vers la page d'accueil après 3 secondes
    Timer(Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Libérer les ressources de l'animation
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xff282828),
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animation du logo avec une transition d'opacité
              FadeTransition(
                opacity: _animation,
                // child: Image.asset(
                //   "assets/image/logo.png", 
                //   width: 200, 
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}