import 'dart:io';

class Authentication {

  login(HttpRequest req) {
    var requestContentStream;
    req.listen((List<int> buffer) {
      requestContentStream = new String.fromCharCodes(buffer);
    }, onDone: () {
      print('received: $requestContentStream');

      req.session['user'] = '{"user":"henk","level":1}';
      req.response.close();
    });

  }

}
