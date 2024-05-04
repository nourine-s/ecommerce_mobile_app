import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('HomeScreen');
            },
          ),
          backgroundColor: Colors.deepPurple[400],
          title: const Text(
            'About',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Mobile app using flutter made by:'),
              Text('Nourine Sameh'),
              Text('Ebtissam Khaled'),
              Text('Yasmin Tarek')
            ],
          ),
        ));
  }
}
