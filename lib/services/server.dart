library self_service_services_http;
import 'dart:io';
import 'package:route/server.dart';

import 'package:self_service_api/config/urls.dart';
import 'package:self_service_api/services/applications.dart';

import 'package:self_service_api/services/application.dart';
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/build/stash_repo_changed.dart';

class Server {


  start(String stashIp) {
print('server is started! using stash Ip $stashIp');

    STASH_IP = stashIp;

    Urls urls = new Urls();
    Applications applications = new Applications();
    Application application = new Application();
    StashRepoChanged stashRepoChanged = new StashRepoChanged();
    // Callback to handle illegal urls.
    serveNotFound(req) {
      req.response.statusCode = HttpStatus.NOT_FOUND;
      req.response.write('Not found');
      req.response.close();
    }

    HttpServer.bind('0.0.0.0', 9090).then((server) {

      var router = new Router(server)
      // Associate callbacks with URLs.
        ..serve(urls.applicationsUrl, method: 'GET').listen(applications.get)
        ..serve(urls.applicationDetailsUrl, method: 'GET').listen(application.get)
        ..serve(urls.applicationsUrl, method: 'POST').listen(applications.createNew)
        ..serve(urls.applicationsUrl, method: 'OPTIONS').listen(applications.optionsOk)
        ..serve(urls.applicationMergeEnv, method: 'POST').listen(application.mergeBranche)
        ..serve(urls.applicationMergeEnv, method: 'OPTIONS').listen(applications.optionsOk)
        ..serve(urls.stashRepoChangedPost, method: 'OPTIONS').listen(applications.optionsOk)
        ..serve(urls.stashRepoChangedPost, method: 'POST').listen(stashRepoChanged.handleRepoChange)
        ..serve(urls.buildInformationBuildIndicator, method: 'GET').listen(stashRepoChanged.retrieveBuildInformationWithBuildindicator)
        ..serve(urls.buildInformationApplicationId, method: 'GET').listen(stashRepoChanged.retrieveBuildInformationWithApplicationId)

        ..defaultStream.listen(serveNotFound);
    });

  }
}
