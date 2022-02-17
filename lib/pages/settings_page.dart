import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import '../destination.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ required Key key, required this.destination }) : super(key: key);

  final Destination destination;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.title),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('SECTION 1'),
            tiles: [
              SettingsTile(
                title: Text('Language'),
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: Text('Use System Theme'),
                leading: Icon(Icons.phone_android),
                onToggle: (value) {
                  setState(() {
                    _isSwitched = value;
                  });
                },
                initialValue: _isSwitched,
              ),
            ],
          ),
        ],
      ),
    );
  }
}