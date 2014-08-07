library selfservice_services_application;

import 'dart:io';
import 'dart:convert';
import '../config/urls.dart';
import "package:json_object/json_object.dart";
import '../config/urls.dart';

class Application {
  Urls urls = new Urls();



  mergeBranches(){

  }





  get(req) {

    var application = new JsonObject();

    var gitConfiguration = new JsonObject();
    gitConfiguration.repoInstance = 'stash';
    gitConfiguration.repoUrl = 'http://stash.europe.intranet/';

    application.id =  urls.applicationDetailsUrl.parse(req.uri.path)[0];;
    application.name = 'pManagePaymentAccountsWA';
    application.gitConfiguration = gitConfiguration;
    application.cmdbId = '2223';

    addCorsHeaders(req);

    req.response.write(JSON.encode(application));
    req.response.close();
  }


  addCorsHeaders(req) {
    req.response.headers.add("Access-Control-Allow-Methods", "POST, OPTIONS, GET");
    req.response.headers.add("Access-Control-Allow-Origin", "*");
    req.response.headers.add('Access-Control-Allow-Headers', '*');

  }


}
