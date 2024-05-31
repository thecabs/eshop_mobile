import 'package:eshop/screens/init_screen.dart';
import 'package:eshop/screens/admin/auth/sign_in/sign_in_screen.dart';
import 'package:eshop/screens/admin/auth/sign_up/sign_up_screen.dart';
import 'package:eshop/screens/panier/cart_provider.dart';
import 'package:eshop/size_config.dart';
import 'package:flutter/material.dart';
import 'package:eshop/loading.dart';
import 'package:eshop/routes.dart';
import 'package:eshop/theme.dart';
import 'package:provider/provider.dart';

// void main() {

//   runApp(const MyApp());
// }

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bambino-Shop',
      theme: AppTheme.lightTheme(context),
      initialRoute: LoadingScreen.routeName,
      routes: routes,
    );
  }
}
