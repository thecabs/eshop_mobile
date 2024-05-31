import 'package:eshop/screens/cart/cart_screen.dart';
import 'package:eshop/screens/details/details_screen.dart';
import 'package:eshop/screens/detailso/details_screen.dart';
import 'package:eshop/screens/home/home_screen.dart';
import 'package:eshop/screens/init_screen.dart';
import 'package:eshop/screens/panier/cart_screen.dart';
import 'package:eshop/screens/panier/check.dart';
//import 'package:eshop/screens/panier/checkout.dart';
import 'package:eshop/screens/products/products_screen.dart';
import 'package:eshop/screens/admin/auth/sign_in/sign_in_screen.dart';
import 'package:eshop/screens/admin/auth/sign_up/sign_up_screen.dart';
import 'package:eshop/screens/splash/splash_screen.dart';
import 'package:flutter/widgets.dart';

import 'loading.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  LoadingScreen.routeName: (context) => const LoadingScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ProductsScreen.routeName: (context) => const ProductsScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  DetailsScreeno.routeName: (context) => const DetailsScreeno(),
  CartScreen.routeName: (context) => const CartScreen(),
  CartScreeno.routeName: (context) => CartScreeno(),
};
