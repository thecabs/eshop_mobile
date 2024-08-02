import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eshop/models/client_carte.dart';
import 'package:eshop/services/user/user_service.dart';
import 'package:eshop/screens/client_card/client_card_screen.dart';
import 'package:eshop/screens/client_card/components/client_cart_screen.dart';

class CheckingCardScreen extends StatefulWidget {
  const CheckingCardScreen({Key? key}) : super(key: key);

  @override
  _CheckingCardScreenState createState() => _CheckingCardScreenState();
}

class _CheckingCardScreenState extends State<CheckingCardScreen> {
  final ApiService _apiService = ApiService();
  Client? _clientInfo;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _checkSavedMatrAndMobile();
  }

  Future<void> _checkSavedMatrAndMobile() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedMatr = prefs.getString('savedMatr');
    String? savedMobile = prefs.getString('savedMobile');
    bool rememberMatr = savedMatr != null && savedMobile != null;

    if (rememberMatr) {
      final apiResponse = await _apiService.fetchClient(savedMatr, savedMobile);

      if (apiResponse.data != null) {
        if (!mounted)
          return; // Prevent calling setState if the widget is disposed
        setState(() {
          _clientInfo = apiResponse.data as Client;
          loading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ClientCardScreen(
              client: _clientInfo!,
              rememberMatr: rememberMatr,
            ),
          ),
        );
      } else {
        if (!mounted) return;
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apiResponse.error ?? 'Error')),
        );
      }
    } else {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      // Optionally, navigate to another screen if no savedMatr and savedMobile are found
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => InitScreen(), // Or any other screen
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ClientCarteScreen(),
    );
  }
}
