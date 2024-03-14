import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/utils/exceptions.dart';

main() {
  const id = 'id';
  const vbUserId = 'vbUserId';
  const name = 'name';
  const price = 1.0;

  final validInput = {
    'id': id,
    'vbUserId': vbUserId,
    'name': name,
    'price': price,
  };

  group('PurchasePrice', () {
    group('toJson', () {
      test('should return a map with expected data', () {
        final purchasePrice = PurchasePrice(
          id: id,
          vbUserId: vbUserId,
          name: name,
          price: price,
        );

        expect(purchasePrice.toJson(), validInput);
      });

      test(
        'toJson can be piped into fromJson and return an object with duplicate values',
        () {
          final purchasePrice1 = PurchasePrice(
            id: id,
            vbUserId: vbUserId,
            name: name,
            price: price,
          );

          final purchasePrice2 = PurchasePrice.fromJson(
            purchasePrice1.toJson(),
          );

          expect(purchasePrice1.toJson(), purchasePrice2.toJson());
        },
      );
    });

    group('fromJson', () {
      test('should return a valid object', () {
        final purchasePrice = PurchasePrice.fromJson(validInput);

        expect(purchasePrice.toJson(), validInput);
      });

      test('should throw an exception if any required value is missing', () {
        var input = {};

        input = {...validInput};
        input.remove('id');
        expect(
          () => PurchasePrice.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('id'),
          )),
        );

        input = {...validInput};
        input.remove('vbUserId');
        expect(
          () => PurchasePrice.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('vbUserId'),
          )),
        );

        input = {...validInput};
        input.remove('name');
        expect(
          () => PurchasePrice.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('name'),
          )),
        );

        input = {...validInput};
        input.remove('price');
        expect(
          () => PurchasePrice.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('price'),
          )),
        );
      });

      test(
        'should throw an exception if the argument is not a valid map',
        () {
          expect(
            () => PurchasePrice.fromJson(''),
            throwsA(predicate(
              (e) => e is TypeCheckException && e.message.contains('root'),
            )),
          );

          expect(
            () => PurchasePrice.fromJson(1),
            throwsA(predicate(
              (e) => e is TypeCheckException && e.message.contains('root'),
            )),
          );

          expect(
            () => PurchasePrice.fromJson(true),
            throwsA(predicate(
              (e) => e is TypeCheckException && e.message.contains('root'),
            )),
          );

          expect(
            () => PurchasePrice.fromJson([]),
            throwsA(predicate(
              (e) => e is TypeCheckException && e.message.contains('root'),
            )),
          );

          expect(
            () => PurchasePrice.fromJson(null),
            throwsA(predicate(
              (e) => e is TypeCheckException && e.message.contains('root'),
            )),
          );
        },
      );
    });
  });
}
