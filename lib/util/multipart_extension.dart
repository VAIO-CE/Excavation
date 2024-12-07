import 'dart:async';
import 'package:http/http.dart' as http;

extension ProgressTracking on http.MultipartRequest {
  Future<http.StreamedResponse> sendWithProgress(
      void Function(int bytes, int total) onProgress) async {
    final totalBytes = headers.containsKey("Content-Length")
        ? int.parse(headers["Content-Length"]!)
        : 0;
    var bytesSent = 0;

    final originalStream = finalize();
    final byteStream = http.ByteStream(originalStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (chunk, sink) {
          bytesSent += chunk.length;
          onProgress(bytesSent, totalBytes);
          sink.add(chunk);
        },
      ),
    ));

    final request = http.StreamedRequest(method, url);
    request.headers.addAll(headers);
    byteStream.pipe(request.sink);

    return request.send();
  }
}
