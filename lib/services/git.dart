library selfservice_services_git;

import 'dart:io';
import '../config/urls.dart';
import "package:json_object/json_object.dart";


class Git {
  Urls urls = new Urls();

// Callback for a single post('/post/24', for example).
    servePost(req) {
      var postId = urls.postUrl.parse(req.uri.path)[0];
      req.response.write('Blog post $postId');
      req.response.close();
    }



}
