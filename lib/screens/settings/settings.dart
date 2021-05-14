import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rss_feed/services/repository.dart';
import 'package:rss_feed/widgets/pop_top_bar.dart';

class Settings extends StatefulWidget {
  static final routeName = '/settings';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _useExternalApps = true;
  bool _useDarkMode = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var repository = context.read<Repository>();
      var settings = await repository.getSettings();

      setState(() {
        _useExternalApps = settings.useExternalApps;
        _useDarkMode = settings.useDarkMode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var repository = context.read<Repository>();

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (i, j) => [PopTopBar(title: "Settings")],
          body: ListView(
            padding: EdgeInsets.only(top: 8.0),
            children: [
              SwitchListTile(
                secondary: Icon(Icons.apps),
                value: _useExternalApps,
                title: Text("Use external apps"),
                onChanged: (value) async {
                  await repository.toggleUseExternalApps(value);
                  setState(() {
                    _useExternalApps = value;
                  });
                },
              ),
              Divider(),
              SwitchListTile(
                secondary: Icon(Icons.nights_stay),
                value: _useDarkMode,
                title: Text("Dark mode"),
                onChanged: (value) async {
                  await repository.toggleUseDarkMode(value);
                  setState(() {
                    _useDarkMode = value;
                  });
                },
              ),
              Divider(),
            ],
          )),
    );
  }
}
