import 'package:Pilll/core/action.dart';
import 'package:Pilll/core/state.dart';

typedef Reducer = State Function<State extends ReduxState>(State, Action);
