import 'package:eshop/screens/admin/auth/sign_in/sign_in_screen.dart';
import 'package:eshop/screens/panier/cart_provider.dart';
import 'package:eshop/screens/panier/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SearchField()),
          const SizedBox(width: 16),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Cart Icon.svg",
            numOfitem: cartProvider.cartItems.length,
            press: () => Navigator.pushNamed(context, CartScreeno.routeName),
          ),
          const SizedBox(width: 8),
          // IconBtnWithCounter(
          //   svgSrc: "assets/icons/User.svg",
          //   // numOfitem: 0,
          //   press: () => Navigator.pushNamed(context, SignInScreen.routeName),
          // ),
        ],
      ),
    );
  }
}
