import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/utils/exceptions.dart';

void main() {
  const id = 'id';
  const userId = 'userId';
  const purchasePriceId = 'purchasePriceId';
  const purchasedQuantity = 1.0;

  const dateStr = '2021-01-01T00:00:00.000Z';
  final date = DateTime.parse(dateStr);

  final validInput = {
    'id': id,
    'userId': userId,
    'purchasePriceId': purchasePriceId,
    'date': dateStr,
    'purchasedQuantity': purchasedQuantity,
  };

  group('Purchase', () {
    group('toJson', () {
      test('should return a map with expected data', () {
        final purchase = Purchase(
          id: id,
          userId: userId,
          purchasePriceId: purchasePriceId,
          date: date,
          purchasedQuantity: purchasedQuantity,
        );

        expect(purchase.toJson(), validInput);
      });

      test(
        'toJson can be piped into fromJson and return an object with duplicate values',
        () {
          final purchase1 = Purchase(
            id: id,
            userId: userId,
            purchasePriceId: purchasePriceId,
            date: date,
            purchasedQuantity: purchasedQuantity,
          );

          final purchase2 = Purchase.fromJson(purchase1.toJson());

          expect(purchase1.toJson(), purchase2.toJson());
        },
      );
    });

    group('fromJson', () {
      test('should return a valid object', () {
        final purchase = Purchase.fromJson(validInput);

        expect(purchase.toJson(), validInput);
      });

      test('should throw an exception if any required value is missing', () {
        var input = {};

        input = {...validInput};
        input.remove('id');
        expect(
          () => Purchase.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('id'),
          )),
        );

        input = {...validInput};
        input.remove('userId');
        expect(
          () => Purchase.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('userId'),
          )),
        );

        input = {...validInput};
        input.remove('purchasePriceId');
        expect(
          () => Purchase.fromJson(input),
          throwsA(predicate(
            (e) =>
                e is TypeCheckException &&
                e.message.contains('purchasePriceId'),
          )),
        );

        input = {...validInput};
        input.remove('date');
        expect(
          () => Purchase.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('date'),
          )),
        );

        input = {...validInput};
        input.remove('purchasedQuantity');
        expect(
          () => Purchase.fromJson(input),
          throwsA(predicate(
            (e) =>
                e is TypeCheckException &&
                e.message.contains('purchasedQuantity'),
          )),
        );
      });

      test('should throw an error if date is invalid', () {
        var input = {...validInput};
        input['date'] = 'invalid date';
        expect(
          () => Purchase.fromJson(input),
          throwsA(predicate(
            (e) => e is FormatException && e.message.contains('Invalid date'),
          )),
        );
      });

      test('should throw an exception if the argument it not a valid map', () {
        expect(
          () => Purchase.fromJson(''),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );

        expect(
          () => Purchase.fromJson(1),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );

        expect(
          () => Purchase.fromJson(true),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );

        expect(
          () => Purchase.fromJson([]),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );

        expect(
          () => Purchase.fromJson(null),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );
      });
    });
  });
}
