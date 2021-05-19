import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/source.dart';
import '../../services/database.dart';
import '../../services/scraper.dart';
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

  Future<List<Source>> _getSources(int limit, int offset) {
    final database = context.read<Database>();
    return database.getSources(limit, offset);
  }

  void _removeSource(Source source) async {
    final database = context.read<Database>();
    await database.forgetSource(source);
  }

  void _goToSourceFeed(Source source) {
    Navigator.pushNamed(context, SourceFeed.routeName, arguments: source);
  }

  void _goToSourceSearch() async {
    await showSearch(
      context: context,
      delegate: SourceSearch(),
    );
  }

  void _goToSourceApiSearch() async {
    final source = await showSearch<Source?>(
      context: context,
      delegate: SourceAdd(),
    );

    if (source != null) {
      try {
        final database = context.read<Database>();
        final scraper = context.read<Scraper>();
        await database.addSource(source);
        _controller.refresh();
        final feed = await scraper.fetch(source.url);
        if (feed != null) await database.refreshSource(source, feed.articles);
      } catch (err) {
        print('Error adding source: $err');
      }
    }
  }

  Widget _buildEmpty(BuildContext context) {
    return EmptyIndicator(
      icon: Icons.menu_book,
      title: 'No source found.',
      message: 'You can tap the + button to add a new source.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackToTop(
        builder: (context, controller) => NestedScrollView(
          controller: controller,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            TopBar(title: 'Sources', onSearch: _goToSourceSearch),
          ],
          body: SourceLazyList(
            controller: _controller,
            onRequest: _getSources,
            onTap: _goToSourceFeed,
            onRemove: _removeSource,
            emptyBuilder: _buildEmpty,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _goToSourceApiSearch,
      ),
    );
  }
}
