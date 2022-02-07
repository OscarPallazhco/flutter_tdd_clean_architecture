import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failures.dart';
import '../../../../core/use_cases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}
