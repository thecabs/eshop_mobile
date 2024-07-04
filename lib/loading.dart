import 'package:eshop/screens/init_screen.dart';
import 'package:eshop/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  static String routeName = "/";

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun) {
      await prefs.setBool('isFirstRun', false);
      // Navigate to your SplashScreen or IntroScreen
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SplashScreen()));
      //MaterialPageRoute(builder: (context) => const SplashScreen()));
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => InitScreen()),
        (route) => false,
      );

      // MaterialPageRoute(builder: (context) => const InitScreen()),
      // (route) => false,
      //);
    }
  }

  // void _loadUserInfo() async {
  //   String token = await getToken();

  //   if (token.isEmpty) {
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => SignInScreen()),
  //       (route) => false,
  //     );
  //   } else {
  //     ApiResponse response = await getUserDetail();
  //     if (response.error == null) {
  //       Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => HomeScreen()),
  //         (route) => false,
  //       );
  //     } else if (response.error == unauthorized) {
  //       Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => LoginScreen()),
  //         (route) => false,
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           duration: Duration(seconds: 3),
  //           content: Container(
  //             height: 30.0,
  //             child: Text(
  //               '${response.error}',
  //               style:
  //                   TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
