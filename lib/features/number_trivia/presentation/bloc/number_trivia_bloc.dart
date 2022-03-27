import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_clean_architecturre/core/error/failures.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/use_cases/get_concrete_number_trivia.dart';
import '../../domain/use_cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';


const String SERVER_FAILURE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_FAILURE_MESSAGE = "Invalid input - The number must be a positive integer or zero";
const String UNEXPECTED_FAILURE_MESSAGE = "Unexpected error";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter
  }): super(Empty()) {
      on<GetTriviaForConcreteNumber>(_mapGetTriviaForConcreteNumber);
  }

  void _mapGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event, 
    Emitter<NumberTriviaState> emit
  ) async {
    final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
    inputEither.fold(
      (failure) => emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
      (integer) async{
        emit(Loading());
        final failureOrTrivia = await getConcreteNumberTrivia(Params(number: integer));
        failureOrTrivia.fold(
          (failure) => emit(Error(message: _mapFailureToMessage(failure))),
          (trivia) => emit(Loaded(numberTrivia: trivia))
        );
      }
    );
  }

  String _mapFailureToMessage(Failure failure){
    switch(failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
