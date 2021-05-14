import 'package:sqflite/sqflite.dart';

import './source.dart' hide cTitle;
import './article.dart';

final String tSourceAndArticle = 'source_and_article';
final String cSourceUrl = 'source_url';
final String cArticleGuid = 'article_guid';

class SourceAndArticle {
  String sourceUrl;
  String articleGuid;

  SourceAndArticle(Source s, Article a)
      : sourceUrl = s.url,
        articleGuid = a.guid;

  Map<String, dynamic> toMap() {
    return {
      cSourceUrl: sourceUrl,
      cArticleGuid: articleGuid,
    };
  }

  static Future createTable(Transaction tx) {
    final sql = '''
      CREATE TABLE $tSourceAndArticle (
        $cSourceUrl TEXT,
        $cArticleGuid TEXT,
        FOREIGN KEY ($cSourceUrl) REFERENCES $tSource($cUrl),
        FOREIGN KEY ($cArticleGuid) REFERENCES $tArticle($cGuid),
        PRIMARY KEY ($cSourceUrl, $cArticleGuid)
      )
    ''';

    return tx.execute(sql);
  }

  static Future addSourceArticles(
    Transaction tx,
    Source s,
    List<Article> al,
  ) async {
    var batch = tx.batch();

    al.forEach(
      (a) => batch.insert(
        tSourceAndArticle,
        SourceAndArticle(s, a).toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      ),
    );

    return batch.commit();
  }

  static Future<List<Article>> getSourceArticles(
    Database db,
    Source s,
    int limit,
    int offset,
  ) async {
    final sql = '''
      SELECT *
      FROM $tArticle
      WHERE $cGuid IN (
        SELECT $cArticleGuid
        FROM $tSourceAndArticle
        WHERE $cSourceUrl = ?
      )
      ORDER BY $cDate DESC
      LIMIT ? OFFSET ?
    ''';

    final sourceArticles = await db.rawQuery(sql, [s.url, limit, offset]);
    return sourceArticles.map((a) => Article.fromMap(a)).toList();
  }

  static Future<List<Article>> findSourceArticles(
    Database db,
    Source s,
    String query,
    int limit,
    int offset,
  ) async {
    final sql = '''
      SELECT *
      FROM $tArticle
      WHERE $cTitle LIKE ?
      AND $cGuid IN (
        SELECT $cArticleGuid
        FROM $tSourceAndArticle
        WHERE $cSourceUrl = ?
      )
      ORDER BY $cDate DESC
      LIMIT ? OFFSET ?
    ''';

    final foundArticles = await db.rawQuery(sql, [
      '%$query%',
      s.url,
      limit,
      offset,
    ]);

    return foundArticles.map((a) => Article.fromMap(a)).toList();
  }

  static Future removeSourceAndArticle(Transaction tx, Source s) async {
    await tx.delete(
      tSourceAndArticle,
      where: '$cSourceUrl = ?',
      whereArgs: [s.url],
    );
  }
}
