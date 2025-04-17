package com.mizuki.Ohashi.Pilll

abstract class Const {
    companion object {
        const val userIsPremiumOrTrial = "userIsPremiumOrTrial"

        const val pillSheetGroupTodayPillNumber = "pillSheetGroupTodayPillNumber"
        const val pillSheetTodayPillNumber = "pillSheetTodayPillNumber"
        const val pillSheetEndDisplayPillNumber = "pillSheetEndDisplayPillNumber"

        // Epoch milli second
        const val pillSheetLastTakenDate = "pillSheetLastTakenDate"

        // Epoch milli second
        const val pillSheetValueLastUpdateDateTime = "pillSheetValueLastUpdateDateTime"

        const val settingPillSheetAppearanceMode =
            "settingPillSheetAppearanceMode" // number or date or sequential
    }
}