import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({ required Key key}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oh no, there has been an error!"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
            child: Text("Error!"),
        ),
      ),
    );
  }
}