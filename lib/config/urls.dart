
library self_service_config_urls;

import 'package:route/url_pattern.dart';

class Urls {

  final applicationsUrl = new UrlPattern(r'/applications\/?');
  final applicationDetailsUrl = new UrlPattern(r'/application/(\w+)/?');

  // Pattern for a single post('/post/24', for example).
  final postUrl = new UrlPattern(r'/post/(\d+)\/?');


  final stashRepoChangedPost = new UrlPattern(r'/stash/commit\/?');

}
