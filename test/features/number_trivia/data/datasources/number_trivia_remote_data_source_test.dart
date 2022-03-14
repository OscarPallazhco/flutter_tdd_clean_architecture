import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/data/models/number_trivia_model.dart';

import 'number_trivia_remote_data_source_test.mocks.dart';

// https://pub.dev/documentation/mockito/latest/annotations/MockSpec-class.html/

@GenerateMocks([],
    customMocks: [MockSpec<http.Client>(returnNullOnMissingStub: true)])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    final int tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      '''
        should perform a GET request on an URL with number being the endpoint
        and with application/json header 
      ''',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (realInvocation) async =>
                http.Response(fixture('trivia.json'), 200));
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockHttpClient
            .get(Uri(path: 'http://numbersapi.com/$tNumber'), headers: {
          'Content-Type': 'application/json',
        }));
      },
    );

    test(
      'should return a NumberTrivia when the response have a 200 status code (success)',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (realInvocation) async =>
                http.Response(fixture('trivia.json'), 200));

        // act
        final NumberTriviaModel result =
            await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
  });
}
