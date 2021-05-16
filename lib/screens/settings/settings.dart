import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/preferences.dart';
import '../../widgets/pop_top_bar.dart';

class SettingsControls extends StatelessWidget {
  static final routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    var prefs = context.watch<Preferences>();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (i, j) => [PopTopBar(title: 'Settings')],
        body: ListView(
          padding: EdgeInsets.only(top: 8.0),
          children: [
            SwitchListTile(
              secondary: Icon(Icons.apps),
              value: prefs.useExternalApps,
              title: Text('Use external apps'),
              onChanged: (value) => prefs.toggleUseExternalApps(value),
            ),
            Divider(),
            SwitchListTile(
              secondary: Icon(Icons.nights_stay),
              value: prefs.useDarkMode,
              title: Text('Dark mode'),
              onChanged: (value) => prefs.toggleUseDarkMode(value),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
