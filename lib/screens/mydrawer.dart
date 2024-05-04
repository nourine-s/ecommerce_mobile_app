import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    void openHomeScreen() {
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed('HomeScreen');
    }

    void openProfileScreen() {
      Navigator.of(context).pushReplacementNamed('ProfileScreen');
    }

    void openCartScreen() {
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed('CartScreen');
    }

    void openProductsScreen() {
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed('ProductsScreen');
    }

    void openSkinCareScreen() {
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed('SkinCareScreen');
    }

    void openHairCareScreen() {
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed('HairCareScreen');
    }

    void openAbout() {
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed('About');
    }

    Future<void> signOut() async {
      FirebaseAuth.instance.signOut();
    }

    final user = FirebaseAuth.instance.currentUser!;
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: null,
            accountEmail: Text(
              user.email!,
              style: TextStyle(fontSize: 20),
            ),
            currentAccountPicture: CircleAvatar(
                child: Icon(
              Icons.person,
              size: 30,
            )),
            decoration: BoxDecoration(color: Colors.deepPurple[400]),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: openHomeScreen,
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('All Products'),
            onTap: openProductsScreen,
          ),
          ListTile(
            leading: Icon(Icons.arrow_right),
            title: Text('Skincare Products'),
            onTap: openSkinCareScreen,
          ),
          ListTile(
            leading: Icon(Icons.arrow_right),
            title: Text('Haircare Products'),
            onTap: openHairCareScreen,
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Cart'),
            onTap: openCartScreen,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: openProfileScreen,
          ),
          ListTile(
            leading: Icon(Icons.logout_rounded),
            title: Text('Log out'),
            onTap: signOut,
          ),
          Divider(color: Colors.grey[300]),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('About'),
            onTap: openAbout,
          )
        ],
      ),
    );
  }
}
