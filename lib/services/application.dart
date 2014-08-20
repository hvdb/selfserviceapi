library selfservice_services_application;

import 'dart:io';
import 'dart:convert';
import '../config/urls.dart';

import '../config/urls.dart';
import '../config/gitconfig.dart';
import 'genericclient.dart';

class Application {
  Urls urls = new Urls();



  mergeBranches(){

  }

  get(req) {

    var applicationName =  urls.applicationDetailsUrl.parse(req.uri.path)[0];

    GenericClient.getSingleRepo(STASH_API_URL +'/'+applicationName, req);


  }





}
