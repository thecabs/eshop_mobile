import 'package:eshop/constants.dart';
import 'package:flutter/material.dart';

class ClientCarteAdded extends StatelessWidget {
  const ClientCarteAdded({super.key});
  static String routeName = "/clientcarteadded";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? "assets/Images/client_cart.png"
                    : "assets/Images/client_cart.png",
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              const Spacer(flex: 2),
              Text(
                "Commande complete",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: defaultPadding / 2),
              const Text(
                "Click the checkout button to show your client cart",
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                onPressed: () {},
                child: const Text("View  Client Cart"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
