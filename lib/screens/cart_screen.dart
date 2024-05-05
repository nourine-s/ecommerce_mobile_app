import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmobile/models/cart.dart';
import 'package:fmobile/screens/checkout.dart';
import 'package:fmobile/screens/mydrawer.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}
class _CartScreenState extends State<CartScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple[400],
            title: const Text(
              'Cart',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          drawer: MyDrawer(),
          body: cart.basketItems.length == 0
              ? Center(
                  child: Text('Your cart is empty'),
                )
              : ListView.builder(
                  itemCount: cart.basketItems.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                            '${cart.basketItems[index].imageSrc}'),
                        title: Text('${cart.basketItems[index].name}'),
                        subtitle: Row(
                          children: [
                            Text(cart.basketItems[index].price.toString()),
                            SizedBox(
                              width: 30,
                            ),
                            IconButton(
                                onPressed: () {
                                  cart.removeOne(cart.basketItems[index]);
                                },
                                icon: Icon(Icons.remove_circle)),
                            Text('${cart.basketItems[index].quantity}'),
                            IconButton(
                                onPressed: (() {
                                  cart.addOne(cart.basketItems[index]);
                                }),
                                icon: Icon(Icons.add_circle)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            cart.remove(cart.basketItems[index]);
                          },
                        ),
                      ),
                    );
                  })),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price:  ${cart.totalPrice} \$',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () async {
                    if (cart.basketItems.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutSheet(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Your cart is empty.')),
                      );
                    }
                  },
                  child: Text('Check out',
                      style: TextStyle(color: Colors.black54)),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
