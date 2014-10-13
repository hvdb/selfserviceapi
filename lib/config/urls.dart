
library self_service_config_urls;

import 'package:route/url_pattern.dart';

class Urls {

  final applicationsUrl = new UrlPattern(r'/applications\/?');
  final applicationDetailsUrl = new UrlPattern(r'/application/(\w+)/?');
  final applicationMergeEnv = new UrlPattern(r'/application/(\w+)/merge\/?');

  final applicationCreatePR = new UrlPattern(r'/application/(\w+)/pullrequest/create\/?');
  final applicationApprovePR = new UrlPattern(r'/application/(\w+)/pullrequest/approve\/?');
  final applicationCheckPR = new UrlPattern(r'/application/(\w+)/pullrequest/check\/?');
  final applicationMergePR = new UrlPattern(r'/application/(\w+)/pullrequest/merge\/?');



  // Pattern for a single post('/post/24', for example).
  final postUrl = new UrlPattern(r'/post/(\d+)\/?');


  final stashRepoChangedPost = new UrlPattern(r'/stash/commit\/?');
  final buildInformationBuildIndicator = new UrlPattern(r'/build/information/id/(\w+)\/?');
  final buildInformationApplicationId = new UrlPattern(r'/build/information/application/(\w+)\/?');

}
