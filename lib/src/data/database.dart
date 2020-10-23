import 'package:rss_feed/src/data/models.dart';
import 'package:sqflite/sqflite.dart';

const SUBSCRIPTION = 'subscription';
const ARTICLE = 'article';
const SUBSCRIPTION_AND_ARTICLE = 'subscription_and_article';

const S_URL = 'url';
const S_TITLE = 'title';
const S_WEBSITE = 'website';
const S_DESCRIPTION = 'description';
const S_ICON = 'icon';

const A_GUID = 'guid';
const A_TITLE = 'title';
const A_LINK = 'link';
const A_DESCRIPTION = 'description';
const A_IMAGE = 'image';
const A_DATE = 'date';

const S_A_SUBSCRIPTION_URL = 'subscription_url';
const S_A_ARTICLE_GUID = 'article_guid';

Map<String, dynamic> saMap(Subscription s, Article a) {
  return SubscriptionAndArticle(s, a).toMap();
}

class FeedDatabase {
  static Database _database;
  static FeedDatabase _instance = FeedDatabase._internal();

  FeedDatabase._internal();

  factory FeedDatabase() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }

    return _database;
  }

  Future<Database> _initDatabase() {
    return openDatabase('my_db.db', version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    return db.transaction((txn) async {
      await _createSubscriptionTable(txn);
      await _createArticleTable(txn);
      await _createSubscriptionAndArticleTable(txn);
    });
  }

  Future _createSubscriptionTable(Transaction txn) {
    final query = '''
      CREATE TABLE $SUBSCRIPTION (
        $S_URL TEXT PRIMARY KEY,
        $S_WEBSITE TEXT,
        $S_TITLE TEXT,
        $S_DESCRIPTION TEXT,
        $S_ICON TEXT
      )
    ''';

    return txn.execute(query);
  }

  Future _createArticleTable(Transaction txn) {
    final query = '''
      CREATE TABLE $ARTICLE (
        $A_GUID TEXT PRIMARY KEY,
        $A_TITLE TEXT,
        $A_LINK TEXT,
        $A_DESCRIPTION TEXT,
        $A_IMAGE TEXT,
        $A_DATE TEXT
      )
    ''';

    return txn.execute(query);
  }

  Future _createSubscriptionAndArticleTable(Transaction txn) {
    final query = '''
      CREATE TABLE $SUBSCRIPTION_AND_ARTICLE (
        $S_A_SUBSCRIPTION_URL TEXT,
        $S_A_ARTICLE_GUID TEXT,
        FOREIGN KEY ($S_A_SUBSCRIPTION_URL) REFERENCES $SUBSCRIPTION($S_URL),
        FOREIGN KEY ($S_A_ARTICLE_GUID) REFERENCES $ARTICLE($A_GUID),
        PRIMARY KEY ($S_A_SUBSCRIPTION_URL, $S_A_ARTICLE_GUID)
      )
    ''';

    return txn.execute(query);
  }

  Future<List<Subscription>> getSubscriptions() async {
    final db = await database;
    final subscriptions = await db.query(SUBSCRIPTION, orderBy: "$S_TITLE");
    return subscriptions.map((s) => Subscription.fromMap(s)).toList();
  }

  Future<List<Article>> getArticles() async {
    final db = await database;
    final articles = await db.query(ARTICLE, orderBy: "$A_DATE DESC");
    return articles.map((a) => Article.fromMap(a)).toList();
  }

  Future<List<Article>> getSubscriptionArticles(Subscription s) async {
    final query = '''
      SELECT * 
      FROM $ARTICLE 
      WHERE $A_GUID IN (
        SELECT $S_A_ARTICLE_GUID 
        FROM $SUBSCRIPTION_AND_ARTICLE 
        WHERE $S_A_SUBSCRIPTION_URL = ?
      )
      ORDER BY $A_DATE DESC
    ''';

    final db = await database;
    final dbSubscriptionArticles = await db.rawQuery(query, [s.url]);
    return dbSubscriptionArticles.map((a) => Article.fromMap(a)).toList();
  }

  Future addSubscription(Subscription s) async {
    return (await database).insert(SUBSCRIPTION, s.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future addSubscriptionArticles(Subscription s, List<Article> aa) async {
    return (await database).transaction((txn) async {
      var batch = txn.batch();

      aa.forEach((a) => batch.insert(ARTICLE, a.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore));

      aa.forEach((a) => batch.insert(SUBSCRIPTION_AND_ARTICLE, saMap(s, a),
          conflictAlgorithm: ConflictAlgorithm.ignore));

      return batch.commit();
    });
  }
}
