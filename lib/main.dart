import 'package:eshop/screens/panier/cart_provider.dart';
import 'package:eshop/size_config.dart';
import 'package:flutter/material.dart';
import 'package:eshop/loading.dart';
import 'package:eshop/routes.dart';
import 'package:eshop/theme.dart';
import 'package:intl/date_symbol_data_local.dart';
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
    WidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('fr_FR', null);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bambino-Shop',
      theme: AppTheme.lightTheme(context),
      initialRoute: LoadingScreen.routeName,
      routes: routes,
    );
  }
}
