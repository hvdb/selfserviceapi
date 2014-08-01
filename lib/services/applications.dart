library selfservice_services_git;

import 'dart:io';
import 'dart:convert';
import '../config/urls.dart';
import "package:json_object/json_object.dart";


class Applications {

// Callback for all posts (plural).
  get(req) {


    var data = new List();

    var application = new JsonObject();


    var gitConfiguration = new JsonObject();
    gitConfiguration.repoInstance = 'stash';
    gitConfiguration.repoUrl = 'http://stash.europe.intranet/';

    application.name = 'pManagePaymentAccountsWA';
    application.gitConfiguration = gitConfiguration;
    application.cmdbId = '2223';

    data.add(application);

    addCorsHeaders(req);

    req.response.write(JSON.encode(data));
    req.response.close();
  }


  addCorsHeaders(req) {
    req.response.headers.add("Access-Control-Allow-Methods", "POST, OPTIONS, GET");
    req.response.headers.add("Access-Control-Allow-Origin", "*");
    req.response.headers.add('Access-Control-Allow-Headers', '*');

  }


}
