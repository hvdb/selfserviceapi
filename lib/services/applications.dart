library selfservice_services_git;

import 'dart:io';
import 'dart:convert';
import '../config/urls.dart';
import "package:json_object/json_object.dart";


class Applications {

// Callback for all posts (plural).
  serverApplications(req) {

    var data = new JsonObject();

    data = new List();

    var application = new JsonObject();
    application.name = 'pManagePaymentAccountsWA';
    application.stashUrl = 'bla';
    application.cmdbId = '222';

    data.add(application);

    req.response.headers.add("Access-Control-Allow-Methods", "POST, OPTIONS, GET");
    req.response.headers.add("Access-Control-Allow-Origin", "*");
    req.response.headers.add('Access-Control-Allow-Headers', '*');

    req.response.write(JSON.encode(data));
    req.response.close();
  }

}
