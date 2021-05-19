import './source.dart' hide cSourceTitle;
import './article.dart';

final String tSourceAndArticle = 'source_and_article';
final String cForeignSourceUrl = 'source_url';
final String cForeignArticleGuid = 'article_guid';

class SourceAndArticle {
  String sourceUrl;
  String articleGuid;

  SourceAndArticle(Source s, Article a)
      : sourceUrl = s.url,
        articleGuid = a.guid;

  Map<String, dynamic> toMap() {
    return {
      cForeignSourceUrl: sourceUrl,
      cForeignArticleGuid: articleGuid,
    };
  }
}
