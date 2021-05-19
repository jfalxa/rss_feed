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
