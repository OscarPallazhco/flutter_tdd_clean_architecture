import 'package:flutter_tdd_clean_architecturre/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tdd_clean_architecturre/features/number_trivia/domain/entities/number_trivia.dart';

void main() {
  final tNUmberTriviaModel = NumberTriviaModel(text: 'text', number: 1);

  test(
    'NumberTriviaModel should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(tNUmberTriviaModel, isA<NumberTrivia>());
    },
  );
}
