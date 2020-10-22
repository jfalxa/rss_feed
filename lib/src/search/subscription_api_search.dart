import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/api.dart';
import '../data/models.dart';
import '../widgets/loader.dart';
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
    return Loader<List<Subscription>>(
      future: Api.searchSubscriptions(this.query),
      error: 'Error searching for subscriptions',
      builder: (context, subscriptions) => SubscriptionList(
        subscriptions: subscriptions,
        onTap: (s) => close(context, s),
      ),
    );
  }
}
