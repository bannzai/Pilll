import 'package:pilll/entity/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class UserState implements _$UserState {
  UserState._();
  factory UserState({required User? entity}) = _UserState;
}
