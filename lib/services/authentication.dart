import 'dart:io';
import 'package:dart_jwt/dart_jwt.dart';
import 'dart:convert';

class Authentication {

  login(HttpRequest req) {
    var requestContentStream;
    req.listen((List<int> buffer) {
      requestContentStream = new String.fromCharCodes(buffer);
    }, onDone: () {
      print('received: $requestContentStream');
      final issuedAt = new DateTime.now();
      final expiry = issuedAt.add(const Duration(seconds: 3));
      //TODO add extra claimset.

      final claimSet = new JwtClaimSet('selfservice_api', 'api_security', expiry, issuedAt, '1');
      var settings = JSON.decode(new File('settings.json').readAsStringSync());
      String sharedSecret = settings["sharedSecret"];

      final signatureContext = new JwaSignatureContext(sharedSecret);
      final jwt = new JsonWebToken.jws(claimSet, signatureContext);


      String token = jwt.encode();
      req.response.headers.add('authorization', token);

      req.response.close();



    });

  }

}
