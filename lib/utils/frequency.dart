import 'package:flutter_vice_bank/utils/exceptions.dart';

enum Frequency {
  daily,
  weekly,
  monthly,
}

Frequency stringToFrequency(String input) {
  switch (input) {
    case 'daily':
      return Frequency.daily;
    case 'weekly':
      return Frequency.weekly;
    case 'monthly':
      return Frequency.monthly;
    default:
      throw InvalidInputException('Invalid frequency: $input');
  }
}

String frequencyToString(Frequency input) {
  switch (input) {
    case Frequency.daily:
      return 'daily';
    case Frequency.weekly:
      return 'weekly';
    case Frequency.monthly:
      return 'monthly';
  }
}
