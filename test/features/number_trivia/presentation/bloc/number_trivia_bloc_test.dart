import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecturre/core/util/input_converter.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test(
    'initialState should be Empty',
    () async {
      // assert
      expect(numberTriviaBloc.state, equals(Empty()));
    },
  );

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: "test trivia", number: tNumberParsed);

    test(
      'Should call the InputConvert to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any as String)).thenReturn(Right(tNumberParsed));
    
        // act
        numberTriviaBloc.add((GetTriviaForConcreteNumber(tNumberString)));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any as String));
    
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure()));

        // assert later
        final expected = [
          Error(message: INVALID_INPUT_FAILURE_MESSAGE)
        ];
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

        // act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });
}
