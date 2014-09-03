library selfservice_services_application;

import 'dart:io';
import 'dart:convert';
import 'package:self_service_api/config/urls.dart';

import 'package:self_service_api/config/urls.dart';
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/services/genericclient.dart';

class Application {
  Urls urls = new Urls();



  mergeBranches(){

  }

  get(req) {

    var applicationName =  urls.applicationDetailsUrl.parse(req.uri.path)[0];

    GenericClient.getSingleRepo(STASH_API_URL +'/'+applicationName, req);


  }





}
