import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vice_bank/data_models/config.dart';
import 'package:flutter_vice_bank/utils/exceptions.dart';

void main() {
  const stringKey = 'key1';
  const stringValue = 'value1';

  const numKey = 'key2';
  const numValue = 1;

  const boolKey = 'key3';
  const boolValue = true;

  final stringConfig = ConfigOption.newConfigOption(
    key: stringKey,
    value: stringValue,
  );
  final numConfig = ConfigOption.newConfigOption(
    key: numKey,
    value: numValue,
  );
  final boolConfig = ConfigOption.newConfigOption(
    key: boolKey,
    value: boolValue,
  );

  group('ConfigTest', () {
    group('getters', () {
      group('string', () {
        test('returns the value as-is if it is a string', () {
          final result = stringConfig.string;

          // Assert
          expect(result, stringValue);
        });

        test('returns a stringified version of a non-string scalar', () {
          expect(numConfig.string, numValue.toString());
          expect(boolConfig.string, boolValue.toString());
        });
      });

      group('number', () {
        test('returns the value as-is if it is a number', () {
          expect(numConfig.number, numValue);
        });

        test('returns NaN if the input is not a number', () {
          expect(boolConfig.number.isNaN, true);
          expect(stringConfig.number.isNaN, true);
        });
      });

      group('boolean', () {
        test('returns true if the value is "true"', () {
          expect(boolConfig.boolean, true);
        });

        test('returns false if the value is "false"', () {
          final config = ConfigOption.newConfigOption(
            key: 'key',
            value: false,
          );

          expect(config.boolean, false);
        });

        test('returns false if the value is anything else', () {
          expect(stringConfig.boolean, false);
          expect(numConfig.boolean, false);
        });
      });
    });

    group('toJson', () {
      test('returns a map with the expected data', () {
        final config = ConfigOption(key: stringKey, value: stringValue);

        expect(config.toJson(), {'key': stringKey, 'value': stringValue});
      });

      test('toJson can be piped into fromJson and get the same result', () {
        final stringConfigB = ConfigOption.fromJson(stringConfig.toJson());
        expect(stringConfigB.toJson(), stringConfig.toJson());
        final numConfigB = ConfigOption.fromJson(numConfig.toJson());
        expect(numConfigB.toJson(), numConfig.toJson());
        final boolConfigB = ConfigOption.fromJson(boolConfig.toJson());
        expect(boolConfigB.toJson(), boolConfig.toJson());
      });
    });

    group('fromJson', () {
      test('returns a valid object given proper inputs', () {
        final input1 = {'key': stringKey, 'value': stringValue};
        final config1 = ConfigOption.fromJson(input1);
        expect(config1.toJson(), input1);

        final input2 = {'key': boolKey, 'value': '$boolValue'};
        final config2 = ConfigOption.fromJson(input2);
        expect(config2.toJson(), input2);

        final input3 = {'key': numKey, 'value': '$numValue'};
        final config3 = ConfigOption.fromJson(input3);
        expect(config3.toJson(), input3);
      });

      test('throws an exception if required values are missing', () {
        expect(
          () => ConfigOption.fromJson({'key': 'key'}),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('value'),
          )),
        );

        expect(
          () => ConfigOption.fromJson({'value': 'value'}),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('key'),
          )),
        );
      });

      test('throws an exception if the input is not a map', () {
        expect(
          () => ConfigOption.fromJson('not a map'),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );
        expect(
          () => ConfigOption.fromJson([]),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );
        expect(
          () => ConfigOption.fromJson(true),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('root'),
          )),
        );
      });

      test('throws an exception if the inputs are the wrong type', () {
        expect(
          () => ConfigOption.fromJson({'key': 'key', 'value': 1}),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('value'),
          )),
        );
        expect(
          () => ConfigOption.fromJson({'key': 'key', 'value': true}),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('value'),
          )),
        );
        expect(
          () => ConfigOption.fromJson({'key': 1, 'value': '1'}),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('key'),
          )),
        );
        expect(
          () => ConfigOption.fromJson({'key': true, 'value': '1'}),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.message.contains('key'),
          )),
        );
      });
    });

    group('newConfig', () {
      test('creates a new ConfigOption with a string value', () {
        final config1 = ConfigOption.newConfigOption(
          key: stringKey,
          value: stringValue,
        );
        expect(config1.toJson(), {'key': stringKey, 'value': stringValue});

        final config2 = ConfigOption.newConfigOption(
          key: numKey,
          value: numValue,
        );
        expect(config2.toJson(), {'key': numKey, 'value': numValue.toString()});

        final config3 = ConfigOption.newConfigOption(
          key: boolKey,
          value: boolValue,
        );
        expect(
          config3.toJson(),
          {'key': boolKey, 'value': boolValue.toString()},
        );
      });

      test('stringifies a map or list', () {
        final val1 = {'key': 'value'};
        final config1 = ConfigOption.newConfigOption(
          key: 'key1',
          value: val1,
        );
        expect(config1.toJson(), {'key': 'key1', 'value': jsonEncode(val1)});

        final val2 = ['value1', 'value2'];
        final config2 = ConfigOption.newConfigOption(key: 'key2', value: val2);
        expect(config2.toJson(), {'key': 'key2', 'value': jsonEncode(val2)});
      });

      test(
        'throws an error if the value is not the right type or the key is empty',
        () {
          expect(
            () => ConfigOption.newConfigOption(key: 'key', value: null),
            throwsA(predicate((e) => e is InvalidInputException)),
          );
          expect(
            () => ConfigOption.newConfigOption(key: '', value: 'null'),
            throwsA(predicate((e) => e is InvalidInputException)),
          );
          expect(
            () => ConfigOption.newConfigOption(key: 'key', value: null),
            throwsA(predicate((e) => e is InvalidInputException)),
          );
          expect(
            () => ConfigOption.newConfigOption(
              key: 'key',
              value: DateTime.now(),
            ),
            throwsA(predicate((e) => e is InvalidInputException)),
          );
        },
      );
    });
  });
}
