import 'database.dart';

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
    url = map[S_URL];
    title = map[S_TITLE];
    website = map[S_WEBSITE];
    icon = map[S_ICON];
    description = map[S_DESCRIPTION];
  }

  Map<String, dynamic> toMap() {
    return {
      S_URL: url,
      S_TITLE: title,
      S_WEBSITE: website,
      S_ICON: icon,
      S_DESCRIPTION: description,
    };
  }
}

class Article {
  String guid;
  String title;
  String link;
  String image;
  String description;
  DateTime date;
  bool isBookmarked = false;

  Article({
    this.guid,
    this.title,
    this.link,
    this.image,
    this.description,
    this.date,
  });

  Article.fromMap(Map<String, dynamic> map) {
    guid = map[A_GUID];
    title = map[A_TITLE];
    link = map[A_LINK];
    image = map[A_IMAGE];
    description = map[A_DESCRIPTION];
    date = DateTime.parse(map[A_DATE]);
    isBookmarked = map[A_IS_BOOKMARKED] == 1;
  }

  Map<String, dynamic> toMap() {
    return {
      A_GUID: guid,
      A_TITLE: title,
      A_LINK: link,
      A_IMAGE: image,
      A_DESCRIPTION: description,
      A_DATE: date.toIso8601String(),
      A_IS_BOOKMARKED: isBookmarked ? 1 : 0
    };
  }
}

class SourceAndArticle {
  String sourceUrl;
  String articleGuid;

  SourceAndArticle(Source s, Article a)
      : sourceUrl = s.url,
        articleGuid = a.guid;

  Map<String, dynamic> toMap() {
    return {S_A_SOURCE_URL: sourceUrl, S_A_ARTICLE_GUID: articleGuid};
  }
}
