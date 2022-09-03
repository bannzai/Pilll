import Foundation

enum Status {
  case userIsNotPremiumOrTrial
  case pill(todayPillNumber: Int?, alreadyTaken: Bool)
}
