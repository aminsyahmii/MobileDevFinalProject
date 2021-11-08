import "package:flutter/material.dart";

class DetailPage extends StatelessWidget {
  DetailPage(
      {Key? key,
      required this.title,
      required this.postimage,
      required this.description})
      : super(key: key);
  final String title;
  final String postimage;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Image(image: NetworkImage(postimage)),
          ),
          Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                title,
                style: TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
              )),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              description,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }
}
