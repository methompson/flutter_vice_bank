import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vice_bank/api/vice_bank_user_api.dart';
import 'package:flutter_vice_bank/utils/http_service.dart';

void main() {
  group('ViceBankUserAPI', () {
    test('mocking data works', () async {
      final api = ViceBankUserAPI();
      final svc = HttpService();
      api.httpService = svc;
    });
  });
}
