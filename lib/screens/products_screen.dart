import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmobile/models/cart.dart';
import 'package:fmobile/models/item.dart';
import 'package:fmobile/screens/cart_screen.dart';
import 'package:fmobile/screens/mydrawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_wp_woocommerce/woocommerce.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  List<WooProduct> products = [];
  WooCommerce woocommerce = WooCommerce(
      baseUrl:
          'https://woo-fortunately-delightful-amphisbaena.wpcomstaging.com',
      consumerKey: 'ck_45a4b82e14d1bdebe2088441b5f3ddb89b6917b1',
      consumerSecret: 'cs_26591cb189f9bdd4ba40eee4fc9f8f350e10f1ab',
      isDebug: true);
  getProducts() async {
    products = await woocommerce.getProducts(perPage: 18);
    setState(() {});
  }

  void initState() {
    super.initState();
    getProducts();
  }

  String removeHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

 
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: ((context, cart, child) {
      if (products.isEmpty) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple[400],
            title: const Text(
              'All Products',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('CartScreen');
                      },
                      icon: Icon(Icons.shopping_cart),
                    ),
                    Text(
                      cart.count.toString(),
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
            iconTheme: IconThemeData(color: Colors.white),
          ),
          drawer: MyDrawer(),
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple[400],
            ),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          title: const Text(
            'All Products',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.shopping_cart),
                  ),
                  Text(
                    cart.count.toString(),
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: MyDrawer(),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.49),
                itemCount: products.length,
                itemBuilder: (context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade300, blurRadius: 2)
                        ]),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Image.network(
                          '${products[index].images[0].src}',
                          width: 100,
                          height: 150,
                        ),
                        Text(
                          '${products[index].name}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${removeHtmlTags(products[index].description.toString())}',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          ' ${products[index].price}\$',
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Item item = Item(
                                    '${products[index].name}',
                                    '${products[index].images[0].src}',
                                    removeHtmlTags(
                                        products[index].description.toString()),
                                    1,
                                    double.parse('${products[index].price}'),
                                  );
                                  cart.add(item, context);
                                },
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: const EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurple[400],
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                })),
      );
    }));
  }
}
