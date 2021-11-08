import "package:flutter/material.dart";

class AboutPage extends StatelessWidget {
  AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ABOUT'),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Image.asset('assets/besquare_logo.png')),
            Text('Mobile Dev Final Project')
          ]),
    );
  }
}
