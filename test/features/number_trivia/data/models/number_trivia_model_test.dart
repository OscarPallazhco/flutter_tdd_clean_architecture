import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNUmberTriviaModel = NumberTriviaModel(text: 'text', number: 1);

  test(
    'NumberTriviaModel should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(tNUmberTriviaModel, isA<NumberTrivia>());
    },
  );

  group("fromJson", () {
    test(
      'should be return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));

        // act
        final result = NumberTriviaModel.fromJson(jsonMap);

        // assert
        expect(result, tNUmberTriviaModel);
      },
    );
  });
}
