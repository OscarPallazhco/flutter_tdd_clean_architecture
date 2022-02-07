import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  late final List properties;

  Failure({required this.properties});

  @override
  List<Object> get props => [properties];
}
