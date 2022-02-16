import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tdd_clean_architecturre/core/error/exceptions.dart';
import 'package:flutter_tdd_clean_architecturre/core/error/failures.dart';
import 'package:flutter_tdd_clean_architecturre/core/platform/network_info.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/domain/entities/number_trivia.dart';
import 'number_trivia_repository_impl_test.mocks.dart';


@GenerateMocks([NumberTriviaRemoteDataSource, NetworkInfo, NumberTriviaLocalDataSource])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: "test trivia", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should be check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
        // verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      },
    );

    


    });

}
