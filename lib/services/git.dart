library selfservice_services_git;

import 'dart:io';
import '../config/urls.dart';
import "package:json_object/json_object.dart";
import '../providers/gitrepo.dart';

class Git {
  Urls urls = new Urls();

// Callback for a single post('/post/24', for example).
    servePost(req) {
      var postId = urls.postUrl.parse(req.uri.path)[0];
      req.response.write('Blog post $postId');
      req.response.close();
    }

    createRepo(req) {
      //Check to see which kind of git repo is used.
      var urlParams = urls.createRepoUrl.parse(req.uri.path);
      var gitRepoInstance = urlParams[0];
      var gitRepoName = urlParams[1];



      GitRepo.createRepo(gitRepoInstance, gitRepoName);

      req.response.write('createrepo.');
      req.response.write('girepo ' +gitRepoInstance );
      req.response.write('gitreponame ' +gitRepoName);
      req.response.close();

    }






}
