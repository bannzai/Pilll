import 'package:freezed_annotation/freezed_annotation.dart';

part 'signin_sheet_state.freezed.dart';

@freezed
abstract class SigninSheetState implements _$SigninSheetState {
  SigninSheetState._();
  factory SigninSheetState({
    @Default(false) bool isLoginMode,
  }) = _SigninSheetState;
}
