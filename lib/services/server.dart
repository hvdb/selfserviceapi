library self_service_services_http;
import 'dart:io';
import 'package:route/server.dart';
import 'dart:async';
import 'dart:convert';

import 'package:self_service_api/config/urls.dart';
import 'package:self_service_api/services/applications.dart';
import 'package:dart_jwt/dart_jwt.dart';

import 'package:self_service_api/services/application.dart';
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/build/stash_repo_changed.dart';
import 'package:self_service_api/build/application_dependencies.dart';
import 'package:self_service_api/services/authentication.dart';
class Server {


  start(String stashIp) {
print('server is started! using stash Ip $stashIp');

    STASH_IP = stashIp;

    Urls urls = new Urls();
    Applications applications = new Applications();
    Application application = new Application();
    StashRepoChanged stashRepoChanged = new StashRepoChanged();
    ApplicationDependencies applicationDependencies = new ApplicationDependencies();
    Authentication authentication = new Authentication();
    // Callback to handle illegal urls.
    serveNotFound(req) {
      req.response.statusCode = HttpStatus.NOT_FOUND;
      req.response.write('Not found');
      req.response.close();
    }


    HttpServer.bind('0.0.0.0', 9090).then((server) {

      var router = new Router(server)
      // Associate callbacks with URLs.
        ..serve(urls.loginUrl, method: 'OPTIONS').listen(applications.optionsOk)
        ..serve(urls.loginUrl, method: 'POST').listen(authentication.login)

        ..filter(new RegExp(r'^.*$'), addCorsHeaders)
        ..filter(new RegExp(r'^.*$'), requestFromSelfServiceApi)
        ..serve(urls.applicationsUrl, method: 'GET').listen(applications.get)
        ..serve(urls.applicationDetailsUrl, method: 'GET').listen(application.get)
        ..serve(urls.applicationBranchConfig, method: 'GET').listen(application.getBranchConfiguration)
        ..serve(urls.applicationBranchConfig, method: 'OPTIONS').listen(applications.optionsOk)
        ..serve(urls.applicationBranchConfig, method: 'POST').listen(application.postBranchConfiguration)

        ..serve(urls.applicationPullRequests, method: 'GET').listen(application.getListOfPullRequests)
        ..serve(urls.applicationsUrl, method: 'POST').listen(applications.createNew)
        ..serve(urls.applicationsUrl, method: 'OPTIONS').listen(applications.optionsOk)
        ..serve(urls.applicationMergeEnv, method: 'POST').listen(application.mergeBranche)
        ..serve(urls.applicationMergeEnv, method: 'OPTIONS').listen(applications.optionsOk)
        ..serve(urls.stashRepoChangedPost, method: 'OPTIONS').listen(applications.optionsOk)
        ..serve(urls.stashRepoChangedPost, method: 'POST').listen(stashRepoChanged.handleRepoChange)
        ..serve(urls.buildInformationBuildIndicator, method: 'GET').listen(stashRepoChanged.retrieveBuildInformationWithBuildindicator)
        ..serve(urls.buildInformationApplicationId, method: 'GET').listen(stashRepoChanged.retrieveBuildInformationWithApplicationId)
        ..serve(urls.dependencyInformationForApplicationWithEnv, method:'GET').listen(applicationDependencies.retrieveDependenciesForApplicationWithEnv)
        ..defaultStream.listen(serveNotFound);
    });

  }



  Future<bool> requestFromSelfServiceApi(HttpRequest req) {

    String jwtStr = req.headers.value('authorization');

    if (req.requestedUri.path.contains('login')) {
      return new Future.sync(() => true);
    } else {

      if (req.method == 'OPTIONS') {
        return new Future.sync(() => true);
      }

      JsonWebToken jwt = new JsonWebToken.decode(jwtStr);
      var settings = JSON.decode(new File('settings.json').readAsStringSync());
      String sharedSecret = settings["sharedSecret"];
      Set<ConstraintViolation> violations = jwt.validate(new JwtValidationContext.withSharedSecret(sharedSecret));

      if (violations.isNotEmpty) {
        return new Future.sync(() => false);
      } else {
        print('jwt ok');
        return new Future.sync(() => true);
      }
    }
  }




  Future<bool> addCorsHeaders(HttpRequest req) {
    req.response.headers.add("Access-Control-Allow-Methods", "*");
    req.response.headers.add("Access-Control-Allow-Origin", "http://localhost:8080");
    req.response.headers.add("Access-Control-Allow-Credentials", "true");
    req.response.headers.add("Access-Control-Expose-Headers", "authorization");

    req.response.headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, authorization");
    return new Future.sync(() => true);
  }



}

