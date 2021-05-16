import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyIndicator extends StatelessWidget {
  final String _title;
  final String? _message;
  final IconData? _icon;

  const EmptyIndicator(
      {Key? key, required String title, String? message, IconData? icon})
      : _title = title,
        _message = message,
        _icon = icon,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: Column(
        children: [
          if (_icon != null) Icon(_icon, size: 64),
          if (_icon != null) const SizedBox(height: 16),
          Text(
            _title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          if (_message != null) const SizedBox(height: 16),
          if (_message != null) Text(_message!, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
