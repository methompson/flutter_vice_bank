import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_vice_bank/data_models/deposit_conversion.dart';
import 'package:flutter_vice_bank/utils/exceptions.dart';

void main() {
  const id = 'id';
  const userId = 'userId';
  const name = 'name';
  const rateName = 'rateName';
  const depositsPer = 1.0;
  const tokensPer = 2.0;
  const minDeposit = 3.0;

  final validInput = {
    'id': id,
    'userId': userId,
    'name': name,
    'rateName': rateName,
    'depositsPer': depositsPer,
    'tokensPer': tokensPer,
    'minDeposit': minDeposit,
  };

  group('toJson', () {
    test('should return a map with expected data', () {
      final depositConversion = DepositConversion(
        id: id,
        userId: userId,
        name: name,
        rateName: rateName,
        depositsPer: depositsPer,
        tokensPer: tokensPer,
        minDeposit: minDeposit,
      );

      expect(depositConversion.toJson(), validInput);
    });

    test(
      'toJson can be piped into fromJson and return an object with duplicate values',
      () {
        final depositConversion1 = DepositConversion(
          id: id,
          userId: userId,
          name: name,
          rateName: rateName,
          depositsPer: depositsPer,
          tokensPer: tokensPer,
          minDeposit: minDeposit,
        );

        final depositConversion2 = DepositConversion.fromJson(
          depositConversion1.toJson(),
        );

        expect(depositConversion1.toJson(), depositConversion2.toJson());
      },
    );
  });

  group('fromJson', () {
    test('should return a valid object', () {
      final depositConversion = DepositConversion.fromJson(validInput);

      expect(depositConversion.toJson(), validInput);
    });

    test('should throw an exception any required value is missing', () {
      var input = {};

      input = {...validInput};
      input.remove('id');
      expect(
        () => DepositConversion.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('id'),
        )),
      );

      input = {...validInput};
      input.remove('userId');
      expect(
        () => DepositConversion.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('userId'),
        )),
      );
      input = {...validInput};
      input.remove('userId');
      expect(
        () => DepositConversion.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('userId'),
        )),
      );
      input = {...validInput};
      input.remove('rateName');
      expect(
        () => DepositConversion.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('rateName'),
        )),
      );
      input = {...validInput};
      input.remove('depositsPer');
      expect(
        () => DepositConversion.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('depositsPer'),
        )),
      );
      input = {...validInput};
      input.remove('tokensPer');
      expect(
        () => DepositConversion.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('tokensPer'),
        )),
      );
      input = {...validInput};
      input.remove('minDeposit');
      expect(
        () => DepositConversion.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('minDeposit'),
        )),
      );
    });

    test('should throw an exception if the argument is not a map', () {
      expect(
        () => DepositConversion.fromJson(''),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('root'),
        )),
      );

      expect(
        () => DepositConversion.fromJson(0),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('root'),
        )),
      );

      expect(
        () => DepositConversion.fromJson(true),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('root'),
        )),
      );

      expect(
        () => DepositConversion.fromJson([]),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('root'),
        )),
      );

      expect(
        () => DepositConversion.fromJson(null),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('root'),
        )),
      );
    });
  });
}
