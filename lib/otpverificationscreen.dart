import 'dart:async';
import 'package:dealsdray/homescreen.dart';
import 'package:dealsdray/loginscreen.dart';
import 'package:dealsdray/userdetailsscreen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  OtpVerificationScreen({required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final Dio _dio = Dio();
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());
  int secondsRemaining = 117;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  String getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    final otp = getOtp();
    final url = "http://devapiv4.dealsdray.com/api/v2/user/otp/verification";
    final data = {
      "otp": otp,
      "deviceId": await _getDeviceId(),
      "userId": "user_id_here" // Replace with the actual userId if required
    };

    try {
      final response = await _dio.post(url, data: data);

      if (response.statusCode == 200) {
        bool isNewUser = response.data['isNewUser'] ?? false;

        if (isNewUser) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UserDetailsScreen())); // Navigate to register screen for new users
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen())); // Navigate to home screen for existing users
        }
      } else {
        print("OTP verification failed: ${response.statusCode}");
      }
    } catch (error) {
      print("Error verifying OTP: $error");
    }
  }

  Future<String> _getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('deviceId') ?? 'unknown_device_id';
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/otp_image.png', // Replace with your image path
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'OTP Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We have sent a unique OTP number to your mobile +91-${widget.phoneNumber}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _otpControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTime(secondsRemaining),
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: secondsRemaining == 0 ? _resendOtp : null,
                  child: Text(
                    'SEND AGAIN',
                    style: TextStyle(
                      color: secondsRemaining == 0 ? Colors.red : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'VERIFY OTP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resendOtp() async {
    setState(() {
      secondsRemaining = 117;
    });
    _startTimer();
    // Re-trigger the OTP send request to backend (you can call _requestOtp method from LoginScreen here)
  }
}
