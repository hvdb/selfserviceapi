library self_service_services_http;
import 'dart:io';
import 'package:route/server.dart';

import 'package:self_service_api/config/urls.dart';
import 'package:self_service_api/services/applications.dart';

import 'package:self_service_api/services/application.dart';


class Server {


  start() {


    Urls urls = new Urls();
    Applications applications = new Applications();
    Application application = new Application();

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
        ..serve(urls.applicationDetailsUrl, method: 'GET').listen(application.get)
        ..serve(urls.applicationsUrl, method: 'POST').listen(applications.createNew)
        ..serve(urls.applicationsUrl, method: 'OPTIONS').listen(applications.optionsOk)
        ..defaultStream.listen(serveNotFound);
    });

  }
}
