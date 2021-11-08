import 'dart:convert';
import 'package:finall/about.dart';
import 'package:finall/createpost.dart';
import 'package:finall/postdetail.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:web_socket_channel/io.dart';

final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
List post = [];

class PostingPage extends StatelessWidget {
  PostingPage({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(name: name),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void getPost() {
    channel.stream.listen((posting) {
      final decodedMessage = jsonDecode(posting);

      setState(() {
        post = decodedMessage['data']['posts'];
        post.sort((b, a) {
          var aDate = a['date'];
          var bDate = b['date'];

          return aDate.compareTo(bDate);
        });
      });
      print(post);
      channel.sink.close();
    });

    channel.sink.add('{"type": "get_posts"}');
  }

  @override
  void initState() {
    super.initState();
    getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posting Page'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AboutPage()));
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewPostPage(name: widget.name)));
                        },
                      ),
                      Text('Create New Post',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Icon(Icons.sort),
                  Icon(Icons.favorite_border_outlined)
                ],
              ),
            ],
          ),
          post.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: post.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                          title: post[index]["title"],
                                          postimage: post[index]["image"],
                                          description: post[index]
                                              ["description"],
                                        )));
                          },
                          child: Card(
                              child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  child: Expanded(
                                flex: 2,
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Image.network(
                                    '${post[index]["image"]}',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )),
                              Container(
                                child: Expanded(
                                    flex: 4,
                                    child: Container(
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${post[index]["title"]}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${post[index]["description"]}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${post[index]["author"]}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Text(
                                              '${post[index]["date"].toString().characters.take(10)}',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    )),
                              ),
                              Container(
                                  child: Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.favorite),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          )),
                        );
                      }),
                )
              : Container()
        ],
      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
