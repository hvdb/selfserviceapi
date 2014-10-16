import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';

class MongoDb {


  Future retrieveBuildInformationsWithApplicationId(String applicationId) {
    var completer = new Completer();
    Db db = new Db("mongodb://test:test@192.168.59.103/build");
    DbCollection information;
    db.open().then((_){
      information = db.collection('build');
      return information.find(where.eq("applicationId", applicationId)).toList().then((data) {
        completer.complete(data);
      });
    }).then((o) {
      print('close');
      db.close();
    });
    return completer.future;
  }


  Future retrieveBuildInformationWithBuildIndicator(String buildIndicator) {
    var completer = new Completer();
    Db db = new Db("mongodb://test:test@192.168.59.103/build");
    DbCollection information;
    db.open().then((_){
      information = db.collection('build');
      return information.findOne({"buildIndicator": "$buildIndicator"}).then((Map object){
        completer.complete(object);
      });

    }).then((o) {
      print('close');
      db.close();
    });
    return completer.future;
  }

  updateBuildStatusInformation(String buildIndicator, String status) {
    Db db = new Db("mongodb://test:test@192.168.59.103:27017/build");
    DbCollection information;
    db.open().then((_){
      information = db.collection('build');
      information.update(where.eq("buildIndicator", buildIndicator), modify.set('status', status));
    }).then((o) {
      db.close();
    });
  }

  insertBuildInformation(Map buildInformationData) {
    Db db = new Db("mongodb://test:test@192.168.59.103:27017/build");
    DbCollection information;
    db.open().then((_){
      information = db.collection('build');
      information.insert(buildInformationData);
    }).then((o) {
        db.close();
    });
  }


  Future retrieveDependenciesForApplicationAndEnvironment(String applicationId, String environment) {
    var completer = new Completer();
    Db db = new Db("mongodb://test:test@192.168.59.103/application");
    DbCollection information;
    db.open().then((_){
      information = db.collection('dependencies');
      return information.findOne(where.eq("environment", environment).and(where.eq("applicationId", applicationId))).then((Map object){
        completer.complete(object);
      });
    }).then((o) {
      print('close');
      db.close();
    });
    return completer.future;
  }



  insertDependencies(Map dependencyInformation) {
print('insert depen $dependencyInformation');
    Db db = new Db("mongodb://test:test@192.168.59.103:27017/application");

    DbCollection information;
    db.open().then((_){
      information = db.collection('dependencies');
      information.insert(dependencyInformation);
    }).then((o) {
      db.close();
    });


  }

}