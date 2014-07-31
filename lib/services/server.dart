library self_service_services_http;
import 'dart:io';
import 'package:route/server.dart';

import '../config/urls.dart';
import 'git.dart';
import 'applications.dart';

class Server {

  start() {

    Git git = new Git();
    Urls urls = new Urls();
    Applications applications = new Applications();

    // Callback to handle illegal urls.
    serveNotFound(req) {
      req.response.statusCode = HttpStatus.NOT_FOUND;
      req.response.write('Not found');
      req.response.close();
    }

    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 9090).then((server) {

      var router = new Router(server)
      // Associate callbacks with URLs.
        ..serve(urls.applicationsUrl, method: 'GET').listen(applications.get)
        ..serve(urls.postUrl, method: 'GET').listen(git.servePost)
        ..serve(urls.createRepoUrl, method: 'GET').listen(git.createRepo)
        ..defaultStream.listen(serveNotFound);
    });

  }
}
