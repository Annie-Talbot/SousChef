import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sous_chef/destinations/settings_destination.dart';
import 'package:sous_chef/storage_manager.dart';
import 'package:sous_chef/theme_manager.dart';
import '../destination.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ required Key key, required this.destination,
    }) : super(key: key);

  final Destination destination;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) =>
      Scaffold(
        appBar: AppBar(
          title: Text(widget.destination.title),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: Text('SECTION 1'),
              tiles: [
                SettingsTile(
                  title: const Text('Language'),
                  leading: const Icon(Icons.language),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile.switchTile(
                  title: const Text('Use dark mode?'),
                  leading: const Icon(Icons.phone_android),
                  onToggle: (value) {
                    if (Theme.of(context).brightness == Brightness.light) {
                      theme.setDarkMode();
                    } else {
                      theme.setLightMode();
                    }
                    setState() {}
                  },
                  initialValue: Theme.of(context).brightness == Brightness.dark,
                ),
              ],
            ),
          ],
        ),
      )
    );
  }


}