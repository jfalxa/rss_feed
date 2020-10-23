import 'package:http/http.dart' as http;

Future<String> resolveRedirects(String url) async {
  var redirectUrl = url;

  try {
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(redirectUrl))
      ..followRedirects = false;

    var response = await client.send(request);

    while (response.isRedirect) {
      redirectUrl = response.headers['location'];

      var request = http.Request('GET', Uri.parse(redirectUrl))
        ..followRedirects = false;

      response = await client.send(request);
    }

    return redirectUrl;
  } catch (error) {
    print(error);
  }

  return null;
}
