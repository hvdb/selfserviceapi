import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';

class MongoDb {



  retrieveAllApplicationForEnv(String env) {
    Db db = new Db("mongodb://admin:test@192.168.59.103/applicationconfig");
    db.open().then((c){

      DbCollection collection = db.collection('applications');
    }).then((v){
      print(v);
      db.close();
    });
  }

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

    Cursor cursor;

    DbCollection information;
    db.open().then((_){
      information = db.collection('build');
      return information.find({"buildIndicator": "$buildIndicator"}).forEach((v){
        completer.complete(v);
      });
    }).then((o) {
      print('close');
      db.close();
    });

    return completer.future;

  }

  insertBuildInformation(List<Map> buildInformationData) {

    Db db = new Db("mongodb://test:test@192.168.59.103:27017/build");

    DbCollection information;
    db.open().then((_){
      information = db.collection('build');
      information.insertAll(buildInformationData);
    }).then((o) {
        db.close();
    });


  }

}