import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/home/job_entries/format.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.hours(10), '10h');
    });
    test('zero', () {
      expect(Format.hours(0), '0h');
    });
    test('negative', () {
      expect(Format.hours(-10), '0h');
    });
    test('decimal', () {
      expect(Format.hours(4.5), '4.5h');
    });
  });
  // group('date', () {
  //   setUp(() async {
  //     Intl.defaultLocale = 'en_GB';
  //     await initializeDateFormatting(Intl.defaultLocale.toString(), null)
  //         .then((value) => {print('intl ok')});
  //   });
  //   test('2018-08-12', () {
  //     expect(Format.date(DateTime(2019, 8, 12)), '12 Aug 2019 ');
  //   });
  // });
  //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
}
