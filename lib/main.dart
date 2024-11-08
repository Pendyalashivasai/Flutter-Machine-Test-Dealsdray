import 'package:dealsdray/homescreen.dart';
import 'package:dealsdray/loginscreen.dart';
import 'package:dealsdray/otpverificationscreen.dart';
import 'package:dealsdray/splashscreen.dart';
import 'package:dealsdray/userdetailsscreen.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/otp': (context) => OtpVerificationScreen(phoneNumber: '1234567890'),
        '/userDetails': (context) => UserDetailsScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
