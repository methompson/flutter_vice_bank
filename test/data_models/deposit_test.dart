import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/utils/exceptions.dart';

void main() {
  const id = 'id';
  const userId = 'userId';
  const depositQuantity = 1;
  const conversionRate = 2.1;
  const depositConversionName = 'depositConversionName';

  const dateStr = '2021-01-01T00:00:00.000Z';
  final date = DateTime.parse(dateStr);

  final validInput = {
    'id': id,
    'userId': userId,
    'date': dateStr,
    'depositQuantity': depositQuantity,
    'conversionRate': conversionRate,
    'depositConversionName': depositConversionName,
  };

  group('Deposit', () {
    group('toJson', () {
      test('should return a map with expected data', () {
        final deposit = Deposit(
          id: id,
          userId: userId,
          date: date,
          depositQuantity: depositQuantity,
          conversionRate: conversionRate,
          depositConversionName: depositConversionName,
        );

        expect(deposit.toJson(), validInput);
      });

      test(
        'toJson can be piped into fromJson and return an object with duplicate values',
        () {
          final deposit1 = Deposit(
            id: id,
            userId: userId,
            date: date,
            depositQuantity: depositQuantity,
            conversionRate: conversionRate,
            depositConversionName: depositConversionName,
          );

          final deposit2 = Deposit.fromJson(deposit1.toJson());

          expect(deposit1.toJson(), deposit2.toJson());
        },
      );
    });

    group('fromJson', () {
      test('should return a valid object', () {
        final deposit = Deposit.fromJson(validInput);

        expect(deposit.toJson(), validInput);
      });

      test('should throw an exception if any required value is missing', () {
        var input = {};

        input = {...validInput};
        input.remove('id');
        expect(
          () => Deposit.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('id'),
          )),
        );

        input = {...validInput};
        input.remove('userId');
        expect(
          () => Deposit.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('userId'),
          )),
        );

        input = {...validInput};
        input.remove('date');
        expect(
          () => Deposit.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('date'),
          )),
        );

        input = {...validInput};
        input.remove('depositQuantity');
        expect(
          () => Deposit.fromJson(input),
          throwsA(predicate(
            (e) =>
                e is TypeCheckException &&
                e.message.contains('depositQuantity'),
          )),
        );

        input = {...validInput};
        input.remove('conversionRate');
        expect(
          () => Deposit.fromJson(input),
          throwsA(predicate(
            (e) =>
                e is TypeCheckException && e.message.contains('conversionRate'),
          )),
        );

        input = {...validInput};
        input.remove('depositConversionName');
        expect(
          () => Deposit.fromJson(input),
          throwsA(predicate(
            (e) =>
                e is TypeCheckException &&
                e.message.contains('depositConversionName'),
          )),
        );
      });

      test('should throw an error if date is invalid', () {
        var input = {...validInput};
        input['date'] = 'invalid date';
        expect(
          () => Deposit.fromJson(input),
          throwsA(predicate(
            (e) => e is FormatException && e.message.contains('Invalid date'),
          )),
        );
      });

      test('should throw an exception if the argument is not a valid map', () {
        expect(
          () => Deposit.fromJson(''),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );

        expect(
          () => Deposit.fromJson(1),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );

        expect(
          () => Deposit.fromJson(true),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );

        expect(
          () => Deposit.fromJson([]),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );

        expect(
          () => Deposit.fromJson(null),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );
      });
    });
  });
}
