import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final servLocator = GetIt.instance;

Future<void> init() async {
  // Features - Number Trivia
  // Bloc
  servLocator.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: servLocator(),
      getRandomNumberTrivia: servLocator(),
      inputConverter: servLocator()));

  // use cases
  servLocator.registerLazySingleton(() => GetConcreteNumberTrivia(servLocator()));
  servLocator.registerLazySingleton(() => GetRandomNumberTrivia(servLocator()));

  // Repository
  servLocator.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          localDataSource: servLocator(),
          networkInfo: servLocator(),
          remoteDataSource: servLocator()));
  

  // Data sources
  servLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(() => 
    NumberTriviaRemoteDataSourceImpl(client: servLocator()));

  servLocator.registerLazySingleton<NumberTriviaLocalDataSource>(() => 
    NumberTriviaLocalDataSourceImpl(sharedPreferences: servLocator()));
    

  // Core
  servLocator.registerLazySingleton(() => InputConverter());
  servLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(servLocator()));


  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  servLocator.registerLazySingleton(() => sharedPreferences);
  servLocator.registerLazySingleton(() => http.Client());
  servLocator.registerLazySingleton(() => DataConnectionChecker());
}
