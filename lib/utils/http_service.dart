import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class HttpResponseData {
  final String body;
  final String url;
  final int statusCode;

  HttpResponseData({
    required this.body,
    required this.url,
    required this.statusCode,
  });

  get ok => statusCode >= 200 && statusCode < 300;
}

class HttpService {
  Future<HttpResponseData> postJson(
    Uri uri, {
    required String body,
    Map<String, String>? headers,
  }) async {
    return customPostJson(
      uri,
      body: body,
      headers: headers,
    );
  }

  Future<HttpResponseData> get(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    return customGet(
      uri,
      headers: headers,
    );
  }

  @visibleForTesting
  Future<HttpResponseData> customGet(
    Uri uri, {
    Map<String, String>? headers,
    HttpClient? mockClient,
  }) async {
    final HttpClient client = mockClient ?? HttpClient();

    final request = await client.getUrl(uri);

    _setHeaders(request, headers);

    final resp = request.close();

    return _parseResponse(resp, request);
  }

  @visibleForTesting
  Future<HttpResponseData> customPostJson(
    Uri uri, {
    required String body,
    Map<String, String>? headers,
    HttpClient? mockClient,
  }) async {
    final HttpClient client = mockClient ?? HttpClient();

    final req = await client.postUrl(uri);
    req.headers.set('content-type', 'application/json');

    if (headers != null) {
      _setHeaders(req, headers);
    }
    req.add(utf8.encode(body));

    final resp = req.close();

    return _parseResponse(resp, req);
  }

  Future<HttpResponseData> post(
    Uri uri, {
    Map<String, String>? headers,
    String? body,
  }) async {
    return customPost(
      uri,
      body: body,
      headers: headers,
    );
  }

  @visibleForTesting
  Future<HttpResponseData> customPost(
    Uri uri, {
    Map<String, String>? headers,
    String? body,
    HttpClient? mockClient,
  }) async {
    final HttpClient client = mockClient ?? HttpClient();

    final req = await client.postUrl(uri);

    if (headers != null) {
      _setHeaders(req, headers);
    }
    if (body != null) {
      req.write(body);
    }

    final resp = req.close();

    return _parseResponse(resp, req);
  }

  Future<HttpResponseData> _parseResponse(
    Future<HttpClientResponse> response,
    HttpClientRequest request,
  ) async {
    final resp = await response;
    final completer = Completer<HttpResponseData>();

    var body = '';
    resp.transform(utf8.decoder).listen(
      (event) {
        body += event;
      },
      onDone: () {
        completer.complete(
          HttpResponseData(
            body: body,
            url: request.uri.toString(),
            statusCode: resp.statusCode,
          ),
        );
      },
    );

    return completer.future;
  }

  void _setHeaders(HttpClientRequest req, Map<String, String>? headers) {
    headers?.forEach((key, value) {
      req.headers.set(key, value);
    });
  }
}
