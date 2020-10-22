import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/api.dart';
import '../data/models.dart';
import '../widgets/subscription_list.dart';

class SubscriptionApiSearch extends SearchDelegate<Subscription> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        color: Colors.black87,
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.black87,
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Subscription>>(
        future: Api.searchSubscriptions(this.query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SubscriptionList(
                subscriptions: snapshot.data, onTap: (s) => close(context, s));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error searching for subsciptions'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
