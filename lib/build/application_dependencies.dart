library selfservice_build_stash;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';

import 'package:self_service_api/config/urls.dart';
import "package:json_object/json_object.dart";
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/services/genericclient.dart';
import 'package:self_service_api/services/database/mongodb.dart';
import 'package:self_service_api/config/urls.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:logging/logging.dart';



class ApplicationDependencies {

  Urls _urls = new Urls();
  MongoDb _db = new MongoDb();
  final Logger _log = new Logger('Aapplication');


  /**
   * Retrieve the dependencies for the Application in the URL and the Environment.
   * Gives back a json object from the database with all (bower) dependencies.
   */
  retrieveDependenciesForApplicationWithEnv(req) {
    var applicationId =  _urls.dependencyInformationForApplicationWithEnv.parse(req.uri.path)[0].toLowerCase();
    var environment =  _urls.dependencyInformationForApplicationWithEnv.parse(req.uri.path)[1].toLowerCase();

    _log.fine('Going to retrieve dependencies for app: $applicationId and env: $environment');
    print("env $environment and application $applicationId");

    Future retrieve = _db.retrieveDependenciesForApplicationAndEnvironment(applicationId, environment);

      retrieve.then((List value) {
      _log.finer('Retrieved dependencies.');
      req.response.write(JSON.encode(value));
      req.response.close();
    });

  }
}