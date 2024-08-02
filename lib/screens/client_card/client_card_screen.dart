import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eshop/constants.dart';
import 'package:eshop/screens/client_card/components/client_card_form.dart';

class ClientCarteScreen extends StatelessWidget {
  const ClientCarteScreen({super.key});

  Future<void> _clearSavedMatr(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedMatr');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Matricule effacé')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Carte'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? "assets/images/client_cart.png"
                    : "assets/images/client_cart.png",
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Text(
                "View Your Loyalty Card",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: defaultPadding / 2),
              const Text(
                "Below, enter the registration number received by SMS to consult your loyalty card",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: defaultPadding),
              const ClientCardForm(),
              // const Spacer(),
              // const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
