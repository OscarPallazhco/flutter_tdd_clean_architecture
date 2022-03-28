import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecturre/core/error/failures.dart';
import 'package:flutter_tdd_clean_architecturre/core/use_cases/usecase.dart';
import 'package:flutter_tdd_clean_architecturre/core/util/input_converter.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<GetConcreteNumberTrivia>(returnNullOnMissingStub: true),
  MockSpec<GetRandomNumberTrivia>(returnNullOnMissingStub: true),
  MockSpec<InputConverter>(returnNullOnMissingStub: true),
])
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

    void setUpMockInputConverterSuccess() => 
      when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Right(tNumberParsed));

    void setUpMockInputConverterUnSuccess() => 
      when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Left(InvalidInputFailure()));
    
    void setUpMockGetConcreteNumberTriviaSuccess() => 
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));

    void setUpMockGetConcreteNumberTriviaUnSuccessWithServerFailure() => 
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Left(ServerFailure()));

    void setUpMockGetConcreteNumberTriviaUnSuccessWithCacheFailure() => 
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Left(CacheFailure()));

    test(
      'Should call the InputConvert to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        // act
        numberTriviaBloc.add((GetTriviaForConcreteNumber(tNumberString)));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [error] when the input is invalid',
      () async {
        // arrange
        setUpMockInputConverterUnSuccess();

        // assert later
        final expected = [Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

        // act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTriviaSuccess();

        // act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));

        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTriviaSuccess();

        // assert later
        final expected = [
          Loading(),
          Loaded(numberTrivia: tNumberTrivia)
        ];
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

        // act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTriviaUnSuccessWithServerFailure();

        // assert later
        final expected = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE)
        ];
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

        // act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
    
    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTriviaUnSuccessWithCacheFailure();

        // assert later
        final expected = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE)
        ];
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

        // act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });
  
  group('GetTriviaForRandomNumber', () {

    final tNumberTrivia = NumberTrivia(text: "test trivia", number: 1);
    
    void setUpMockGetRandomNumberTriviaSuccess() => 
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));

    void setUpMockGetRandomNumberTriviaUnSuccessWithServerFailure() => 
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Left(ServerFailure()));

    void setUpMockGetRandomNumberTriviaUnSuccessWithCacheFailure() => 
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Left(CacheFailure()));



    test(
      'should get data from the random use case',
      () async {
        // arrange
        setUpMockGetRandomNumberTriviaSuccess();

        // act
        numberTriviaBloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));

        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockGetRandomNumberTriviaSuccess();

        // assert later
        final expected = [
          Loading(),
          Loaded(numberTrivia: tNumberTrivia)
        ];
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

        // act
        numberTriviaBloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
      () async {
        // arrange
        setUpMockGetRandomNumberTriviaUnSuccessWithServerFailure();

        // assert later
        final expected = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE)
        ];
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

        // act
        numberTriviaBloc.add(GetTriviaForRandomNumber());
      },
    );
    
    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockGetRandomNumberTriviaUnSuccessWithCacheFailure();

        // assert later
        final expected = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE)
        ];
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

        // act
        numberTriviaBloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
