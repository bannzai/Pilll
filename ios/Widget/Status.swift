import Foundation

enum Status {
    case userIsNotPremiumOrTrial
    case invalidPillSheet
    case pill(todayPillNumber: Int, alreadyTaken: Bool)
}
