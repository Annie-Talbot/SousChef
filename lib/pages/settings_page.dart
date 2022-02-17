import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../destination.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ required Key key, required this.destination }) : super(key: key);

  final Destination destination;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

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