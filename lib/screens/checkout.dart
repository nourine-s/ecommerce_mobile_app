import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fmobile/models/cart.dart';
import 'package:provider/provider.dart';

class CheckoutSheet extends StatefulWidget {
  const CheckoutSheet({super.key});

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}
class _CheckoutSheetState extends State<CheckoutSheet> {
  final user = FirebaseAuth.instance.currentUser!;
  final _addressController = TextEditingController();
  String? selectedPaymentMethod;
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple[400],
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left_rounded,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Check Out',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Your order is',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cart.basketItems.map((item) {
                      return ListTile(
                        title: Text('${item.name}'),
                        subtitle: Row(
                          children: [
                            Text(item.price.toString()),
                            SizedBox(width: 30),
                            Text('x ${item.quantity}'),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Total price :  ${cart.totalPrice}\$',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.red[300],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Enter your address',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Address',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/images/payment/visa.png',
                                width: 23,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Visa'),
                            ],
                          ),
                          value: 'Visa',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/images/payment/cash.png',
                                width: 23,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Cash'),
                            ],
                          ),
                          value: 'Cash',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: () async {
                        if (_addressController.text.isNotEmpty &&
                            selectedPaymentMethod != null) {
                          //prepare order data
                          Map<String, dynamic> orderData = {
                            'timestamp': DateTime.now(),
                            'total price': cart.totalPrice,
                            'payment method': selectedPaymentMethod,
                            'address': _addressController.text,
                            'items': cart.basketItems.map((item) {
                              return {
                                'name': item.name,
                                'image': item.imageSrc,
                                'price': item.price,
                                'quantity': item.quantity,
                              };
                            }).toList(),
                          };
                          //add order data to firestore gowa el email bta3 el user
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(user.email)
                              .collection('Orders')
                              .add(orderData);
                          //b2ol ll user en el order placed w yrg3o ll home page
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Order Placed'),
                                content: Text(
                                  'Your order has been placed successfully.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      cart.clearCart();
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        'HomeScreen',
                                      );
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          if (_addressController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                'Please enter your address.',
                              )),
                            );
                          } else if (selectedPaymentMethod == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                'Please select payment method.',
                              )),
                            );
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[400],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Check out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
