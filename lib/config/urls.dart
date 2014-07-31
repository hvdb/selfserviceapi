
library self_service_config_urls;

import 'package:route/url_pattern.dart';

class Urls {

  final applicationsUrl = new UrlPattern(r'/applications\/?');

  // Pattern for a single post('/post/24', for example).
  final postUrl = new UrlPattern(r'/post/(\d+)\/?');

  final createRepoUrl = new UrlPattern(r'/gitrepo/(\w+)/(\w+)');



}
