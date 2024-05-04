import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wp_woocommerce/woocommerce.dart';
import 'package:fmobile/models/cart.dart';
import 'package:fmobile/models/item.dart';
import 'package:fmobile/screens/cart_screen.dart';
import 'package:fmobile/screens/haircare_screen.dart';
import 'package:fmobile/screens/skincare_screen.dart';
import 'package:provider/provider.dart';
import 'package:fmobile/screens/mydrawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void openSkinCareScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkinCareScreen(),
      ),
    );
  }

  void openHairCareScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HairCareScreen(),
      ),
    );
  }

  final user = FirebaseAuth.instance.currentUser!;
  List<WooProduct> hairProducts = [];
  List<WooProduct> skinProducts = [];
  WooCommerce woocommerce = WooCommerce(
      baseUrl:
          'https://woo-fortunately-delightful-amphisbaena.wpcomstaging.com',
      consumerKey: 'ck_45a4b82e14d1bdebe2088441b5f3ddb89b6917b1',
      consumerSecret: 'cs_26591cb189f9bdd4ba40eee4fc9f8f350e10f1ab',
      isDebug: true);

  Future getProducts() async {
    hairProducts =
        await woocommerce.getProducts(tag: '1380', category: 1372.toString());
    skinProducts =
        await woocommerce.getProducts(tag: '1380', category: 1373.toString());
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
      if (hairProducts.isEmpty || skinProducts.isEmpty) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple[400],
            title: const Text(
              'Home',
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
                      color: Colors.white,
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
            'Home',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider(
                  items: [
                    Image.asset('assets/images/Clary3.jpg'),
                    Image.asset('assets/images/garnier.jpg'),
                    Image.asset('assets/images/sale1.jpg'),
                    Image.asset('assets/images/vitaminc2.jpg'),
                    Image.asset('assets/images/dermactive.png'),
                  ],
                  options: CarouselOptions(
                      height: 200,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      aspectRatio: 2.0,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 4),
                      enlargeCenterPage: true,
                      enlargeFactor: 1)),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Hair Products:',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    IconButton(
                        onPressed: openHairCareScreen,
                        icon: Icon(Icons.arrow_forward_ios_rounded))
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 9 / 17),
                      itemCount: hairProducts.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300, blurRadius: 2)
                              ]),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 3,
                              ),
                              Image.network(
                                '${hairProducts[index].images[0].src}',
                                width: 100,
                                height: 150,
                              ),
                              Text(
                                '${hairProducts[index].name}',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                removeHtmlTags(
                                    hairProducts[index].description.toString()),
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                '${hairProducts[index].price}\$',
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Item item = Item(
                                          '${hairProducts[index].name}',
                                          '${hairProducts[index].images[0].src}',
                                          removeHtmlTags(hairProducts[index]
                                              .description
                                              .toString()),
                                          1,
                                          double.parse(
                                              '${hairProducts[index].price}'),
                                        );
                                        cart.add(item, context);
                                      },
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        padding: const EdgeInsets.all(13),
                                        decoration: BoxDecoration(
                                            color: Colors.deepPurple[400],
                                            borderRadius:
                                                BorderRadius.circular(5)),
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
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Skin Products:',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    IconButton(
                        onPressed: openSkinCareScreen,
                        icon: Icon(Icons.arrow_forward_ios_rounded))
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 9 / 17),
                      itemCount: skinProducts.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300, blurRadius: 2)
                              ]),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 3,
                              ),
                              Image.network(
                                '${skinProducts[index].images[0].src}',
                                width: 100,
                                height: 150,
                              ),
                              Text(
                                '${skinProducts[index].name}',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                removeHtmlTags(
                                    skinProducts[index].description.toString()),
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                '${hairProducts[index].price}\$',
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Item item = Item(
                                          '${skinProducts[index].name}',
                                          '${skinProducts[index].images[0].src}',
                                          removeHtmlTags(skinProducts[index]
                                              .description
                                              .toString()),
                                          1,
                                          double.parse(
                                              '${skinProducts[index].price}'),
                                        );
                                        cart.add(item, context);
                                      },
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        padding: const EdgeInsets.all(13),
                                        decoration: BoxDecoration(
                                            color: Colors.deepPurple[400],
                                            borderRadius:
                                                BorderRadius.circular(5)),
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
            ],
          ),
        ),
      );
    }));
  }
}
