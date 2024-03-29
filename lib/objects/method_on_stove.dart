

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sous_chef/database_handler.dart';
import 'package:sous_chef/objects/method.dart';
import 'package:sous_chef/theme_manager.dart';

class MethodOnStove {

  static String methodDone = "done";
  static String methodStartTime = "startTime";
  static String methodDuration = "method";
  static String methodDescription = "description";
  static String methodOrderKey = "orderKey";

  bool done;
  String startTime;
  int duration;
  String description;
  int orderKey;

  MethodOnStove({ required Method method,
                  required this.done,
                  required this.startTime}) : description = method.description,
                                              duration = method.duration,
                                              orderKey = method.orderKey;


  MethodOnStove.fromMethod({required Method method,
    required TimeOfDay eatTime, required int timeTaken}) :
        done = false,
        duration = method.duration,
        description = method.description,
        orderKey = method.orderKey,
        startTime = calculateStartTime(eatTime, method.duration, timeTaken);

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


  static String calculateStartTime(TimeOfDay eatTime, int duration,
      int timeTaken) {
    duration += timeTaken;
    int hours = eatTime.hour;
    int minutes = eatTime.minute;

    while(duration > 0) {
      if (minutes >= duration) {
        minutes -= duration;
        break;
      }
      // Subtracting an hour
      hours = hours > 0 ? hours - 1 : 23;
      duration -= minutes;
      minutes = 59;
    }
    return "$hours:$minutes";
  }
}



class MethodOnStoveWidget extends StatefulWidget {
  const MethodOnStoveWidget({
    Key? key,
    required this.method
  }) : super(key: key);

  final MethodOnStove method;

  @override
  State<MethodOnStoveWidget> createState() => _MethodOnStoveWidgetState();
}

class _MethodOnStoveWidgetState extends State<MethodOnStoveWidget> {
  Color _cardColor = ThemeNotifier.darkGreen;


  @override
  Widget build(BuildContext context) {
    return Card(
      color: getCardColor(widget.method.done),
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.method.startTime.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(widget.method.description),
            Checkbox(
                value: widget.method.done,
                onChanged: (done) {
                  setState(() {
                    widget.method.done = done!;
                  });

                })
          ],
        ),
      ),
    );
  }

  Color getCardColor(bool done) {
    if (done) {
      return Theme.of(context).backgroundColor;
    } else {
      return ThemeNotifier.mediumGreen;
    }
  }
}