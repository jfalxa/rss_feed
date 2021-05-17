import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/source.dart';
import '../../services/repository.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/back_to_top.dart';
import '../../widgets/empty_indicator.dart';
import '../../widgets/source_lazy_list.dart';
import './source_search.dart';
import './source_add.dart';
import './source_feed.dart';

class Sources extends StatefulWidget {
  @override
  _SourcesState createState() => _SourcesState();
}

class _SourcesState extends State<Sources> {
  final PagingController<int, Source> _controller =
      PagingController(firstPageKey: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToSourceFeed(BuildContext context, Source source) {
    Navigator.pushNamed(context, SourceFeed.routeName, arguments: source);
  }

  void _goToSourceSearch(BuildContext context) async {
    await showSearch(
      context: context,
      delegate: SourceSearch(),
    );
  }

  void _goToSourceApiSearch(BuildContext context) async {
    final source = await showSearch<Source?>(
      context: context,
      delegate: SourceAdd(),
    );

    if (source != null) {
      try {
        var repository = context.read<Repository>();
        await repository.addSource(source);
        _controller.refresh();
        await repository.fetchSource(source);
      } catch (err) {
        print('Error adding source: $err');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var repository = context.read<Repository>();

    return Scaffold(
      body: BackToTop(
        builder: (context, controller) => NestedScrollView(
          controller: controller,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            TopBar(
              title: 'Sources',
              onSearch: () => _goToSourceSearch(context),
            ),
          ],
          body: SourceLazyList(
            controller: _controller,
            onRequest: repository.getSources,
            onTap: (source) => _goToSourceFeed(context, source),
            onRemove: (source) => repository.removeSource(source),
            indicatorBuilder: (context) => EmptyIndicator(
              icon: Icons.menu_book,
              title: 'No source found.',
              message: 'You can tap the + button to add a new source.',
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _goToSourceApiSearch(context),
      ),
    );
  }
}
