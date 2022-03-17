import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecturre/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'should return an integer when the string represents an unsigned integer.',
      () async {
        // arrange
        final str = '123';

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, Right(123));
      },
    );

    test(
      'should return an Failure when the string is not a integer.',
      () async {
        // arrange
        final str = 'sdsd';

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
