import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';

class MongoDb {

  _retrieveAllApplicationForEnv(String env) {

    Db db = new Db("mongodb://127.0.0.1/build-env");

    ObjectId id;
    Stopwatch stopwatch = new Stopwatch()..start();
    DbCollection test;
    db.open().then((_){
      test = db.collection('test');
      var data = [];
      for(num i = 0; i<1000; i++){
        data.add({'value': i});
      }
      test.drop().then((_) {
        return Future.forEach(data,
            (elem){
          return test.insert(elem, writeConcern: WriteConcern.ACKNOWLEDGED);
        });
      }).then((_){
        print(stopwatch.elapsed);
        db.close();
      });
    });


  }

}