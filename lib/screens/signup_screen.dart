import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_wp_woocommerce/woocommerce.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final baseUrl =
      'https://woo-fortunately-delightful-amphisbaena.wpcomstaging.com';
  final consumerKey = 'ck_45a4b82e14d1bdebe2088441b5f3ddb89b6917b1';
  final consumerSecret = 'cs_26591cb189f9bdd4ba40eee4fc9f8f350e10f1ab';
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  Future<void> createUserInWooCommerce(
    String email,
    String firstName,
    String lastName,
    String phoneNumber,
  ) async {
    // Create a WooCommerce instance
    WooCommerce wooCommerce = WooCommerce(
      baseUrl: baseUrl,
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
      isDebug: true,
    );

    // Prepare user data
    final Map<String, dynamic> userData = {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'username': email,
      'billing': {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phoneNumber,
      },
      'shipping': {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phoneNumber,
      },
    };

    // Create user in WooCommerce using userdata
    await wooCommerce.post('customers', userData);
  }

  Future signUp() async {
    try {
      if (passwordConfirmed() &&
          _fnameController.text.isNotEmpty &&
          _lnameController.text.isNotEmpty &&
          _phoneNumberController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty) {
        //create user auth
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        //create  ll user collection bl data bt3tao
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.email)
            .set({
          'first name': _fnameController.text.trim(),
          'last name': _lnameController.text.trim(),
          'phone number': _phoneNumberController.text.trim(),
        });
        //create user 3l woo commerce
        await createUserInWooCommerce(
          userCredential.user!.email!,
          _fnameController.text.trim(),
          _lnameController.text.trim(),
          _phoneNumberController.text.trim(),
        );
        Navigator.of(context).pushReplacementNamed('HomeScreen');
      } else if (_fnameController.text.isEmpty) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Please enter your first name.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      } else if (_lnameController.text.isEmpty) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Please enter your last name.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      } else if (_phoneNumberController.text.isEmpty) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Please enter your phone number.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      } else if (_passwordController.text.isEmpty) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Please enter your password.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      } else if (_confirmPasswordController.text.isEmpty) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Please confirm your password.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      } else if (_emailController.text.isEmpty) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Please enter your email address.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Weak password'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      } else if (e.code == 'email-already-in-use') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('User already exists'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      }
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      if (_passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(' Passwords do not match'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      }
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    _phoneNumberController.dispose();
  }

  void openSigninScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 87, 194),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Sign up',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Sign up',
                style: TextStyle(
                    color: Color.fromARGB(255, 126, 87, 194),
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
              Divider(endIndent: 90, indent: 90),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(11)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: TextField(
                      controller: _fnameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'First Name',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(11)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: TextField(
                    controller: _lnameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Last Name',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(11)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(11)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Phone number',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(11)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(11)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Comfirm Password',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: GestureDetector(
                  onTap: signUp,
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 126, 87, 194),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Already have an account ? ',
                style: TextStyle(color: Colors.grey[600]),
              ),
              GestureDetector(
                  onTap: openSigninScreen,
                  child: Text(
                    'Sign in here',
                    style: TextStyle(color: Colors.grey[500]),
                  ))
            ]),
          ),
        ),
      )),
    );
  }
}
