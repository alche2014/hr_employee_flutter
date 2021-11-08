import 'package:flutter/material.dart';

class MyHomeGif extends StatefulWidget {
  @override
  _MyHomeGifState createState() => new _MyHomeGifState();
}

class _MyHomeGifState extends State<MyHomeGif> {
  String url = "https://media.giphy.com/media/hIfDZ869b7EHu/giphy.gif";

  void _evictImage() {
    final NetworkImage provider = NetworkImage(url);
    provider.evict().then<void>((bool success) {
      if (success) debugPrint('removed image!');
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(url),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _evictImage,
        child: Icon(Icons.remove),
      ),
    );
  }
}
