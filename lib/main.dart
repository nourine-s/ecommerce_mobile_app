import 'package:flutter/material.dart';
import 'package:fmobile/screens/profile_screen.dart';
import 'firebase_options.dart';
import 'package:fmobile/auth.dart';
import 'package:fmobile/models/cart.dart';
import 'package:fmobile/screens/about.dart';
import 'package:fmobile/screens/cart_screen.dart';
import 'package:fmobile/screens/forget_screen.dart';
import 'package:fmobile/screens/haircare_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fmobile/screens/login_screen.dart';
import 'package:fmobile/screens/home_screen.dart';
import 'package:fmobile/screens/signup_screen.dart';
import 'package:fmobile/screens/products_screen.dart';
import 'package:fmobile/screens/skincare_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => Cart(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const Auth(),
          'HomeScreen': (context) => const HomeScreen(),
          'SignUpScreen': (context) => const SignUpScreen(),
          'LoginScreen': (context) => const LoginScreen(),
          'ForgetScreen': (context) => const ForgetScreen(),
          'ProductsScreen': (context) => const ProductsScreen(),
          'SkinCareScreen': (context) => const SkinCareScreen(),
          'HairCareScreen': (context) => const HairCareScreen(),
          'CartScreen': (context) => const CartScreen(),
          'ProfileScreen': (context) => const ProfileScreen(),
          'About': (context) => const About(),
        },
      );
    });
  }
}
