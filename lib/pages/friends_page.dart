import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../destination.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({ required Key key, required this.destination }) : super(key: key);

  final Destination destination;

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Text("I am the ${widget.destination.title} display.")
        ),
      ),
    );
  }
}