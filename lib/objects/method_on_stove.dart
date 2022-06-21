

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/database_handler.dart';
import 'package:sous_chef/objects/method.dart';

class MethodOnStove {

  static String methodDone = "done";
  static String methodStartTime = "startTime";
  static String methodDuration = "method";
  static String methodDescription = "description";
  static String methodOrderKey = "orderKey";

  bool done;
  int startTime;
  int duration;
  String description;
  int orderKey;

  MethodOnStove({ required Method method,
                  required this.done,
                  required this.startTime}) : description = method.description,
                                              duration = method.duration,
                                              orderKey = method.orderKey;

  Map<String, Object> toMap() {
    return {
      MethodOnStove.methodDone: done,
      MethodOnStove.methodStartTime: startTime,
      MethodOnStove.methodDuration: duration,
      MethodOnStove.methodDescription: description,
      MethodOnStove.methodOrderKey: orderKey,
    };
  }

  MethodOnStove.fromMap(Map<String, dynamic> res):
      done = res[MethodOnStove.methodDone],
      startTime = res[MethodOnStove.methodStartTime],
      duration = res[MethodOnStove.methodDuration],
      description = res[MethodOnStove.methodDescription],
      orderKey = res[MethodOnStove.methodOrderKey];
}



class MethodOnStoveWidget extends StatelessWidget {
  const MethodOnStoveWidget({
    Key? key,
    required this.method
  }) : super(key: key);

  final MethodOnStove method;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12.0),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              method.startTime.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text(method.description),
            Checkbox(
                value: method.done,
                onChanged: //TODO
                    (done) {})
          ],
        ),
      ),
    );
  }
}