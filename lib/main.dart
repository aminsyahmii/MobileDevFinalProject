import 'dart:convert';

import 'package:finall/posts.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => HomePage();
}

class HomePage extends State<MyHomePage> {
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

  String name = '';

  void login(name) {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      print(decodedMessage);
      channel.sink.close();
    });

    channel.sink.add('{"type": "sign_in", "data": {"name": "$name"}}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
        body: ListView(
          children: [
            Padding(padding: EdgeInsets.all(20)),
            Column(
              mainAxisAlignment: (MainAxisAlignment.center),
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter your username'),
                  onChanged: (String? value) {
                    setState(() {
                      name = value!;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('Enter App'),
              onPressed: () {
                login(name);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostingPage(name: name)),
                );
              },
            ),
          ],
        ));
  }
}
