import 'package:flutter_tdd_clean_architecturre/core/platform/network_info.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should be check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );
  });
}
