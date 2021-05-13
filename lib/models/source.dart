import 'package:sqflite/sqflite.dart';

final String tSource = 'source';
final String cUrl = 'url';
final String cTitle = 'title';
final String cWebsite = 'website';
final String cDescription = 'description';
final String cIcon = 'icon';

class Source {
  String url;
  String title;
  String website;
  String icon;
  String description;

  Source({
    this.url,
    this.title,
    this.website,
    this.icon,
    this.description,
  });

  Source.fromMap(Map<String, dynamic> map) {
    url = map[cUrl];
    title = map[cTitle];
    website = map[cWebsite];
    icon = map[cIcon];
    description = map[cDescription];
  }

  Map<String, dynamic> toMap() {
    return {
      cUrl: url,
      cTitle: title,
      cWebsite: website,
      cIcon: icon,
      cDescription: description,
    };
  }

  static Future createTable(Transaction tx) {
    return tx.execute('''
      CREATE TABLE $tSource (
        $cUrl TEXT PRIMARY KEY,
        $cWebsite TEXT,
        $cTitle TEXT,
        $cDescription TEXT,
        $cIcon TEXT
      )
    ''');
  }

  static Future addSource(Database db, Source s) async {
    return db.insert(tSource, s.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<Source>> getSources(
    Database db,
    int limit,
    int offset,
  ) async {
    final sources = await db.query(
      tSource,
      orderBy: '$cTitle',
      limit: limit,
      offset: offset,
    );

    return sources.map((s) => Source.fromMap(s)).toList();
  }

  static Future<List<Source>> findSources(
    Database db,
    String query,
    int limit,
    int offset,
  ) async {
    final foundSources = await db.query(
      tSource,
      where: '$cTitle LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '$cTitle',
      limit: limit,
      offset: offset,
    );

    return foundSources.map((s) => Source.fromMap(s)).toList();
  }

  static Future removeSource(Transaction tx, Source s) async {
    return tx.delete(
      tSource,
      where: '$cUrl = ?',
      whereArgs: [s.url],
    );
  }
}