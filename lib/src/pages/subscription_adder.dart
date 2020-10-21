import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/store.dart';
import '../data/parser.dart';
import '../widgets/top_bar.dart';

class SubscriptionAdder extends StatefulWidget {
  final Store store;

  SubscriptionAdder({Key key, this.store}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubscriptionAdderState();
}

class _SubscriptionAdderState extends State<SubscriptionAdder> {
  TextEditingController _controller;
  Future<FeedDocument> _document;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkSubscription(String url) {
    setState(() {
      _document = widget.store.fetch(url);
    });
  }

  void addSubscription(BuildContext context) async {
    var document = await _document;

    if (document != null) {
      widget.store.addSubscription(document.subscription);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PopTopBar(title: "Add a subscription"),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onSubmitted: (url) => checkSubscription(url),
            ),
            FutureBuilder<FeedDocument>(
                future: _document,
                initialData: null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: [
                      Text(snapshot.data.subscription.title),
                      Text(snapshot.data.subscription.url),
                      Text(snapshot.data.subscription.description),
                    ]);
                  }

                  if (snapshot.hasError) {
                    return Text("Error while loading subscription");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return Container();
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () => addSubscription(context),
      ),
    );
  }
}
