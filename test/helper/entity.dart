import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';

List<PillSheet> pillSheet1([int offsetDay = 0]) =>
    [PillSheet(id: "pill_sheet_id_1", typeInfo: PillSheetType.pillsheet_28_0.typeInfo, beginingDate: now().subtract(Duration(days: offsetDay)))];
List<PillSheet> pillSheets2([int offsetDay = 0]) => [
      ...pillSheet1(offsetDay),
      PillSheet(
        id: "pill_sheet_id_2",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: now().subtract(Duration(days: offsetDay)).add(const Duration(days: 28)),
      )
    ];
List<PillSheet> pillSheets3([int offsetDay = 0]) => [
      ...pillSheets2(offsetDay),
      PillSheet(
        id: "pill_sheet_id_3",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: now().subtract(Duration(days: offsetDay)).add(const Duration(days: 56)),
      )
    ];
PillSheetGroup pillSheetGroup(List<PillSheet> pillSheets) =>
    PillSheetGroup(pillSheetIDs: pillSheets.map((e) => e.id!).toList(), pillSheets: pillSheets, createdAt: now());

Setting setting() => const Setting(
      pillNumberForFromMenstruation: 40,
      durationMenstruation: 4,
      isOnReminder: true,
      timezoneDatabaseName: "Asia/Tokyo",
    );

PremiumAndTrial trial() => PremiumAndTrial(
    isTrial: true,
    isPremium: false,
    hasDiscountEntitlement: true,
    beginTrialDate: now().subtract(const Duration(days: 3)),
    trialDeadlineDate: now().add(const Duration(days: 27)),
    discountEntitlementDeadlineDate: now().add(const Duration(days: 29)));

PremiumAndTrial premium([bool hasDiscountEntitlement = false]) => PremiumAndTrial(
    isTrial: false,
    isPremium: true,
    hasDiscountEntitlement: hasDiscountEntitlement,
    beginTrialDate: now().subtract(const Duration(days: 31)),
    trialDeadlineDate: now().subtract(const Duration(days: 1)),
    discountEntitlementDeadlineDate: hasDiscountEntitlement ? now().add(const Duration(days: 1)) : now().subtract(const Duration(days: 1)));
