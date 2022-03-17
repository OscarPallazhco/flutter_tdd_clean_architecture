import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecturre/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str){
    return Right(int.parse(str));
  }
}

class InvalidInputFailure {
  
}