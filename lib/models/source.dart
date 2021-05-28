import 'package:sqflite/sqflite.dart';
import 'package:webfeed/webfeed.dart';

final String tSource = 'source';
final String cSourceUrl = 'url';
final String cSourceTitle = 'title';
final String cSourceDescription = 'description';
final String cSourceWebsite = 'website';
final String cSourceIcon = 'icon';

class Source {
  String url;
  String title;
  String website;
  String description;
  String? icon;

  Source({
    required this.url,
    required this.title,
    required this.website,
    required this.icon,
    required this.description,
  });

  Source.fromMap(Map<String, dynamic> map)
      : url = map[cSourceUrl],
        title = map[cSourceTitle],
        website = map[cSourceWebsite],
        icon = map[cSourceIcon],
        description = map[cSourceDescription];

  Source.fromRss(RssFeed rss, [String? url])
      : website = rss.link ?? '',
        url = url ?? rss.link ?? '',
        title = rss.title ?? '',
        description = rss.description ?? '' {
    icon = rss.image?.url;
  }

  Source.fromAtom(AtomFeed atom, [String? url])
      : website = atom.links?[0].href ?? '',
        url = url ?? atom.links?[0].href ?? '',
        title = atom.title ?? '',
        description = atom.subtitle ?? '' {
    icon = atom.icon;
  }

  Map<String, dynamic> toMap() {
    return {
      cSourceUrl: url,
      cSourceTitle: title,
      cSourceWebsite: website,
      cSourceIcon: icon,
      cSourceDescription: description,
    };
  }
}

class SourceDao {
  final Future<Database> db;

  SourceDao({required this.db});

  static Future createSourceTable(Transaction tx) {
    return tx.execute('''
      CREATE TABLE $tSource (
        $cSourceUrl TEXT PRIMARY KEY,
        $cSourceTitle TEXT,
        $cSourceDescription TEXT,
        $cSourceWebsite TEXT,
        $cSourceIcon TEXT
      )
    ''');
  }

  Future addSource(Source source) async {
    return (await db).insert(tSource, source.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Source>> getSources([int? limit, int? offset]) async {
    final sources = await (await db).query(
      tSource,
      orderBy: '$cSourceTitle',
      limit: limit,
      offset: offset,
    );

    return sources.map((source) => Source.fromMap(source)).toList();
  }

  Future<List<Source>> findSources(String query, int limit, int offset) async {
    final foundSources = await (await db).query(
      tSource,
      where: '$cSourceTitle LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '$cSourceTitle',
      limit: limit,
      offset: offset,
    );

    return foundSources.map((source) => Source.fromMap(source)).toList();
  }

  Future removeSource(Source source, [Transaction? tx]) async {
    return (tx ?? await db).delete(
      tSource,
      where: '$cSourceUrl = ?',
      whereArgs: [source.url],
    );
  }
}
