import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecturre/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final int inputNumber = int.parse(str);
      if (inputNumber < 0) throw FormatException();
        return Right(inputNumber);
    } on FormatException{
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
