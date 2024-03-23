import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_vice_bank/data_models/action.dart';
import 'package:flutter_vice_bank/utils/exceptions.dart';

void main() {
  const id = 'id';
  const vbUserId = 'vbUserId';
  const name = 'name';
  const conversionUnit = 'conversionUnit';
  const depositsPer = 1.0;
  const tokensPer = 2.0;
  const minDeposit = 3.0;

  final validInput = {
    'id': id,
    'vbUserId': vbUserId,
    'name': name,
    'conversionUnit': conversionUnit,
    'depositsPer': depositsPer,
    'tokensPer': tokensPer,
    'minDeposit': minDeposit,
  };

  group('toJson', () {
    test('should return a map with expected data', () {
      final depositConversion = VBAction(
        id: id,
        vbUserId: vbUserId,
        name: name,
        conversionUnit: conversionUnit,
        depositsPer: depositsPer,
        tokensPer: tokensPer,
        minDeposit: minDeposit,
      );

      expect(depositConversion.toJson(), validInput);
    });

    test(
      'toJson can be piped into fromJson and return an object with duplicate values',
      () {
        final depositConversion1 = VBAction(
          id: id,
          vbUserId: vbUserId,
          name: name,
          conversionUnit: conversionUnit,
          depositsPer: depositsPer,
          tokensPer: tokensPer,
          minDeposit: minDeposit,
        );

        final depositConversion2 = VBAction.fromJson(
          depositConversion1.toJson(),
        );

        expect(depositConversion1.toJson(), depositConversion2.toJson());
      },
    );
  });

  group('fromJson', () {
    test('should return a valid object', () {
      final depositConversion = VBAction.fromJson(validInput);

      expect(depositConversion.toJson(), validInput);
    });

    test('should throw an exception any required value is missing', () {
      var input = {};

      input = {...validInput};
      input.remove('id');
      expect(
        () => VBAction.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('id'),
        )),
      );

      input = {...validInput};
      input.remove('vbUserId');
      expect(
        () => VBAction.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('vbUserId'),
        )),
      );
      input = {...validInput};
      input.remove('vbUserId');
      expect(
        () => VBAction.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('vbUserId'),
        )),
      );
      input = {...validInput};
      input.remove('conversionUnit');
      expect(
        () => VBAction.fromJson(input),
        throwsA(predicate(
          (e) =>
              e is TypeCheckException && e.message.contains('conversionUnit'),
        )),
      );
      input = {...validInput};
      input.remove('depositsPer');
      expect(
        () => VBAction.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('depositsPer'),
        )),
      );
      input = {...validInput};
      input.remove('tokensPer');
      expect(
        () => VBAction.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('tokensPer'),
        )),
      );
      input = {...validInput};
      input.remove('minDeposit');
      expect(
        () => VBAction.fromJson(input),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('minDeposit'),
        )),
      );
    });

    test('should throw an exception if the argument is not a map', () {
      expect(
        () => VBAction.fromJson(''),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('root'),
        )),
      );

      expect(
        () => VBAction.fromJson(0),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('root'),
        )),
      );

      expect(
        () => VBAction.fromJson(true),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('root'),
        )),
      );

      expect(
        () => VBAction.fromJson([]),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('root'),
        )),
      );

      expect(
        () => VBAction.fromJson(null),
        throwsA(predicate(
          (e) => e is TypeCheckException && e.message.contains('root'),
        )),
      );
    });
  });
}
