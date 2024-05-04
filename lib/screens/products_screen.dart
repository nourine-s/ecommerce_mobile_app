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

  List<Item> items = [
    Item('Raw African', 'assets/images/rawafrican.jpg', 'Hair growth oil', 0,
        250),
    Item('Shaan', 'assets/images/shaan.jpg', 'Moisturizing Gel', 0, 120),
    Item('Sun Screen', 'assets/images/sunscreen.jpg',
        'Protect the skin from UV', 0, 200),
    Item('Hyaluronic acid ', 'assets/images/hylnacid.jpg',
        'Moisturize the skin ', 0, 300),
    Item(
      'Argento',
      'assets/images/argento.jpg',
      'Face Cleanser',
      0,
      150,
    ),
    Item(
      'Clary scalp scrub',
      'assets/images/clary.jpg',
      ' Exfoliates the scalp',
      0,
      300,
    ),
    Item(
      'Bless',
      'assets/images/bless.jpg',
      ' Hair shampoo ',
      0,
      140,
    ),
    Item(
      'Avon',
      'assets/images/avon.jpg',
      ' Hair shampoo ',
      0,
      200,
    ),
    Item(
      'Dr Rashel ',
      'assets/images/drrashel.jpg',
      'Moisturize the skin ',
      0,
      400,
    ),
    Item('Dermactive Acti-White', 'assets/images/dermactiveeye.jpg',
        'Brightening serum', 0, 250),
    Item('Clary Hair serum', 'assets/images/claryserum.jpeg',
        'Anti-frizz effect', 0, 400),
    Item(
      'Fair and lovely',
      'assets/images/fairandlovely.jpg',
      'Whitening cream',
      0,
      70,
    ),
    Item('Azha Vitamin C Serum', 'assets/images/azha.jpg',
        'Reduce pigmentation ', 0, 100),
    Item('Faster hair spray', 'assets/images/faster.jpg',
        'Speed up hair growth', 0, 150),
    Item('Clary Hair Mask', 'assets/images/claryhairmask.jpeg',
        'Repair your hair', 0, 350),
    Item('Dermactive Anti-clear', 'assets/images/dermactiveserum.jpg',
        'Correcting serum', 0, 250),
  ];
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
