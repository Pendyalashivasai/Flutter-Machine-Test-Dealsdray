import 'package:dealsdray/otpverificationscreen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPhoneSelected = true;
  final TextEditingController _phoneController = TextEditingController();
  final Dio _dio = Dio();

 Future<void> _requestOtp() async {
  final url = "http://devapiv4.dealsdray.com/api/v2/user/otp";
  final data = {
    "mobileNumber": _phoneController.text,
    "deviceId": await _getDeviceId(),
  };

  try {
    final response = await _dio.post(url, data: data);

    if (response.statusCode == 200) {
      print("OTP sent successfully");
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=> OtpVerificationScreen(phoneNumber: _phoneController.text)));
    } else {
      print("Failed to send OTP: ${response.statusCode}");
    }
  } on DioError catch (error) {
    if (error.response?.statusCode == 502) {
      print("Server error: ${error.response?.statusMessage}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server error. Please try again later.")),
      );
    } else {
      print("Error sending OTP: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }
}


  Future<String> _getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('deviceId') ?? 'unknown_device_id';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              SizedBox(height: 60),
              Center(
                child: Image.asset(
                  'assets/logo1.png', // Replace with your logo image
                  height: 200,
                ),
              ),
              SizedBox(height: 30),
              // Toggle between Phone and Email with outlined buttons
              Center(
                child: Container(
                  width: 200,
                  height: 51,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 200),
                        left: isPhoneSelected ? 0 : 100,
                        child: Container(
                          width: 99,
                          height: 49,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPhoneSelected = true;
                                });
                              },
                              child: Center(
                                child: Text(
                                  'Phone',
                                  style: TextStyle(
                                    color: isPhoneSelected ? Colors.white : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPhoneSelected = false;
                                });
                              },
                              child: Center(
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                    color: isPhoneSelected ? Colors.red : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Glad to see you!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Please provide your ${isPhoneSelected ? 'phone number' : 'email address'}',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextField(
                controller: _phoneController,
                keyboardType: isPhoneSelected ? TextInputType.phone : TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: isPhoneSelected ? 'Phone' : 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _requestOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'SEND CODE',
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
      ),
    );
  }
}
