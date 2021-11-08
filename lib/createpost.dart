import 'dart:convert';

import 'package:finall/main.dart';
import "package:flutter/material.dart";
import 'package:web_socket_channel/io.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  List post = [];

  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  String url = '';
  String Username = '';

  void createPost() {
    channel.stream.listen((posting) {
      final decodedMessage = jsonDecode(posting);
      print(decodedMessage);
      channel.sink.close();
    });

    channel.sink.add('{"type": "sign_in", "data": {"name": "{$widget.name}"}}');
    channel.sink.add(
        '{"type": "create_post", "data": {"title": "$title", "description": "$description", "image": "$url"}}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Post Title',
                    hintText: 'Inser Post Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your post title';
                    }
                    return null;
                  },
                  onChanged: (String? value) {
                    setState(() {
                      title = value!;
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    hintText: 'Insert Descriptions Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter description';
                    }
                    return null;
                  },
                  onChanged: (String? value) {
                    setState(() {
                      description = value!;
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Image URL',
                    hintText: 'URL image',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Image URL';
                    }
                    return null;
                  },
                  onChanged: (String? value) {
                    setState(() {
                      url = value!;
                    });
                  }),
            ),
            ElevatedButton(
              child: const Text('CREATE'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  createPost();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
