import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../access_contacts.dart';
import '../constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to Access Page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AccessCallLogsPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:
              Colors.transparent, // Transparent background for the status bar
          statusBarIconBrightness:
              Brightness.dark, // Change icons to dark (black)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Bottom Circle (Light Blue)
              Align(
                alignment: const AlignmentDirectional(0, 1.5),
                child: Container(
                  height: 600,
                  width: 600,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lightBlue.withOpacity(0.2),
                  ),
                ),
              ),
              // Top Left Circle (Primary Blue)
              Align(
                alignment: const AlignmentDirectional(-1.2, -1.0),
                child: Container(
                  height: 500,
                  width: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryBlue.withOpacity(0.2),
                  ),
                ),
              ),
              // Top Right Circle (Secondary Blue)
              Align(
                alignment: const AlignmentDirectional(1.2, -1.0),
                child: Container(
                  height: 500,
                  width: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondaryBlue.withOpacity(0.2),
                  ),
                ),
              ),
              // Blur effect over the circles
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 150.0, sigmaY: 150.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
              // Centered Image
              Center(
                child: Image.asset(
                  'assets/images/company_logo.png', // Path to your image file
                  width: 784, // Adjust size of the image
                  height: 764,
                  fit: BoxFit.contain,
                ),
              ),
              // Bottom Center Image
              Align(
                alignment: const Alignment(0, 1),
                child: Image.asset(
                  'assets/images/Communication_devices.png', // Path to your bottom image file
                  width: 110, // Adjust size of the image
                  height: 110,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
