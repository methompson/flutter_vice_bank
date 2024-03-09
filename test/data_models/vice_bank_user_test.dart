import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';
import 'package:flutter_vice_bank/utils/exceptions.dart';

void main() {
  const id = 'id';
  const name = 'name';
  const currentTokens = 22.3;

  final validInput = {
    'id': id,
    'name': name,
    'currentTokens': currentTokens,
  };

  group('ViceBankUser', () {
    group('toJson', () {
      test('should return a map with expected data', () {
        final viceBankUser = ViceBankUser(
          id: id,
          name: name,
          currentTokens: currentTokens,
        );

        expect(viceBankUser.toJson(), validInput);
      });

      test(
        'toJson can be piped into fromJson and return an object with duplicate values',
        () {
          final viceBankUser1 = ViceBankUser(
            id: id,
            name: name,
            currentTokens: currentTokens,
          );

          final viceBankUser2 = ViceBankUser.fromJson(viceBankUser1.toJson());

          expect(viceBankUser1.toJson(), viceBankUser2.toJson());
        },
      );
    });

    group('fromJson', () {
      test('should return a valid object', () {
        final viceBankUser = ViceBankUser.fromJson(validInput);

        expect(viceBankUser.toJson(), validInput);
      });

      test('should throw an exception if any required value is missing', () {
        var input = {};

        input = {...validInput};
        input.remove('id');
        expect(
          () => ViceBankUser.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('id'),
          )),
        );

        input = {...validInput};
        input.remove('name');
        expect(
          () => ViceBankUser.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('name'),
          )),
        );

        input = {...validInput};
        input.remove('currentTokens');
        expect(
          () => ViceBankUser.fromJson(input),
          throwsA(predicate(
            (e) =>
                e is TypeCheckException && e.message.contains('currentTokens'),
          )),
        );
      });

      test('should throw an exception if the argument is not a map', () {
        expect(
          () => ViceBankUser.fromJson(''),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );

        expect(
          () => ViceBankUser.fromJson(1),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );

        expect(
          () => ViceBankUser.fromJson(true),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );

        expect(
          () => ViceBankUser.fromJson([]),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );

        expect(
          () => ViceBankUser.fromJson(null),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );
      });
    });
  });
}
