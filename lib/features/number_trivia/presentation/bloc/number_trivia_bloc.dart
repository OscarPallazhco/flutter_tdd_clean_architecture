import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/use_cases/get_concrete_number_trivia.dart';
import '../../domain/use_cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';


const String SERVER_FAILURE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_FAILURE_MESSAGE = "Invalid input - The number must be a positive integer or zero";

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
      (integer) => getConcreteNumberTrivia(Params(number: integer))
    );
  }
}
