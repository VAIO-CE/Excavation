import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:excavator/util/multipart_extension.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl;

  HttpService({required this.baseUrl});

  // GET request
  Future<http.Response> getRequest(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri =
          Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  // POST request
  Future<http.Response> postRequest(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    String contentType = 'application/json',
  }) async {
    try {
      headers = headers ?? {};
      headers['Content-Type'] = contentType;

      // Encoding
      var encodedBody = body;

      if (contentType == 'application/json' && body != null) {
        encodedBody = jsonEncode(body);
      } else if (contentType == 'application/x-www-form-urlencoded' &&
          body is Map) {
        encodedBody = Uri(queryParameters: body.cast<String, String>()).query;
      }

      final uri = Uri.parse('$baseUrl$endpoint');
      final response =
          await http.post(uri, headers: headers, body: encodedBody);
      return response;
    } catch (e) {
      throw Exception('Error POST: $e');
    }
  }

  Future<void> uploadFirmware(String endpointESP, Uint8List? firmwareBytes,
      Function(double) onProgress) async {
    try {
      final uri = Uri.parse('$baseUrl$endpointESP');

      final request = http.MultipartRequest("POST", uri)
        ..files.add(http.MultipartFile.fromBytes(
            'firmware', firmwareBytes as List<int>,
            filename: 'firmware.bin'));

      final streamResponse = await request.sendWithProgress(
        (int bytes, int total) {
          onProgress(bytes / total);
        },
      );

      final response = await http.Response.fromStream(streamResponse);
      // final streamResponse = await request.send();
      // final response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        print('Firmware update successful!');
      } else {
        throw Exception(
            'Failed to update firmware with code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading firmware: $e');
    }
  }

  // JSON Response Parser
  dynamic parseJson(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return response.body;
    }
  }
}
