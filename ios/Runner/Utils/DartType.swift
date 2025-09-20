import SwiftUI


// Dartの日付のタイムスタンプはmillisecondsで渡ってくる。それをSwiftのDate型にマッピングする
func dartTypeDate(nsNumber: NSNumber) -> Date {
  Date(timeIntervalSince1970: nsNumber.doubleValue / 1000)
}
