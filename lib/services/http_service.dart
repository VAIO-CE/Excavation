import 'dart:convert';
import 'dart:io';

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

  Future<String> getLatestFirmware() async {
    const url =
        'https://api.github.com/repos/VAIO-CE/VAIO-Code/releases/latest';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final assets = parseJson(response)['assets'] as List;
        for (var asset in assets) {
          if (asset['name'] == "firmware.bin") {
            return asset['browser_download_url'];
          }
        }
        throw Exception(
            "firmware.bin not found in the latest release! Please report to devs.");
      } else {
        throw Exception(
            'Failed to fetch latest release: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching firmware URL: $e');
    }
  }

  Future<List<int>> downloadFirmware(String firmwareUrl) async {
    final response = await http.get(Uri.parse(firmwareUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("Failed to download firmware: ${response.statusCode}");
    }
  }

  Future<void> uploadFirmware(String endpointESP, List<int> firmwareBytes) async {
    final uri = Uri.parse(endpointESP);

    final request = http.MultipartRequest("POST", uri)..files.add.(http.MultipartFile.fromBytes('firmware', firmwareBytes, filename: 'firmware.bin'));

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);

    if(response.statusCode == 200){
      print('Firmware uploaded successfully: ${response.body}');
    } else {
      throw Exception('Failed to upload firmware: ${response.statusCode}');
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
