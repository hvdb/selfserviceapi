import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';

class MongoDb {









  retrieveAllApplicationForEnv(String env) {
    Db db = new Db("mongodb://test:test@192.168.59.103/applicationconfig");
    db.open().then((c){

      DbCollection collection = db.collection('applications');
    }).then((v){
      print(v);
      db.close();
    });
  }

  insertTest(String env) {

    Db db = new Db("mongodb://test:test@192.168.59.103/applicationconfig");

    ObjectId id;
    Stopwatch stopwatch = new Stopwatch()..start();
    DbCollection test;
    db.open().then((_){
      test = db.collection('applications');
      var data = [];
      for(num i = 0; i<100; i++){
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