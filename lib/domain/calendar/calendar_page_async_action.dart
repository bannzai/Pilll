import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';

final calendarPageAsyncActionProvider = Provider(
  (ref) => CalendarPageAsyncAction(
    ref.watch(pillSheetModifiedHistoryDatastoreProvider),
  ),
);

class CalendarPageAsyncAction {
  final PillSheetModifiedHistoryDatastore _pillSheetModifiedHistoryDatastore;

  CalendarPageAsyncAction(this._pillSheetModifiedHistoryDatastore);

  Future<void> editTakenValue(
    DateTime actualTakenDate,
    PillSheetModifiedHistory history,
    PillSheetModifiedHistoryValue value,
    TakenPillValue takenPillValue,
  ) {
    return updateForEditTakenValue(
      service: _pillSheetModifiedHistoryDatastore,
      actualTakenDate: actualTakenDate,
      history: history,
      value: value,
      takenPillValue: takenPillValue,
    );
  }
}
