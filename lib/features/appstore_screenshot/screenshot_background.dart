import 'package:flutter/material.dart';

/// ページ番号に対応する背景グラデーション（2色）。
///
/// 競合調査（tmp/research/report.md 5-A）の配色方針に沿う:
/// 安心・信頼を表す Pilll のネイビー基調（#1 社会的証明 / #3 伏せた通知 / #4 複数回通知）に、
/// ピルシート（#2）と生理管理（#5）はピンク/コーラル寄せのハイブリッドで差し色にする。
/// いずれも白のキャッチコピーが読めるだけの明度差を確保している。
/// 上端の明るい色から下端の濃い色へ、左上→右下方向にかける。
class ScreenshotBackground {
  const ScreenshotBackground({required this.topColor, required this.bottomColor});

  /// グラデーション上端（左上）の色。
  final Color topColor;

  /// グラデーション下端（右下）の色。
  final Color bottomColor;

  /// この配色を左上→右下方向の LinearGradient として返す。
  LinearGradient get gradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [topColor, bottomColor],
      );

  /// ページ番号（1始まり）に対応する背景を返す。
  ///
  /// 定義外のページは p1 の配色にフォールバックする。
  static ScreenshotBackground of({required int page}) {
    return _backgrounds[page] ?? _backgrounds[1]!;
  }

  /// ページ番号→配色の対応表。
  static const Map<int, ScreenshotBackground> _backgrounds = {
    // #1 社会的証明: ネイビー。
    1: ScreenshotBackground(topColor: Color(0xFF41597F), bottomColor: Color(0xFF24324D)),
    // #2 ピルシート: ネイビー→コーラル寄りのハイブリッド。
    2: ScreenshotBackground(topColor: Color(0xFFE98A76), bottomColor: Color(0xFFC15E76)),
    // #3 伏せた通知: 夜のロック画面を思わせる濃紺。
    3: ScreenshotBackground(topColor: Color(0xFF33465F), bottomColor: Color(0xFF1C2942)),
    // #4 複数回リマインド: ネイビー。
    4: ScreenshotBackground(topColor: Color(0xFF45608A), bottomColor: Color(0xFF2A3A57)),
    // #5 生理管理: ピンク。AppColors.menstruation 系。
    5: ScreenshotBackground(topColor: Color(0xFFE79AAE), bottomColor: Color(0xFFCB7089)),
    // #6 カレンダー: 予定の見通しを表す明るめのブルーグレー。
    6: ScreenshotBackground(topColor: Color(0xFF5B7BA6), bottomColor: Color(0xFF31456B)),
    // #7 服用履歴: 安心・記録の蓄積を表す深めのティール寄りネイビー。
    7: ScreenshotBackground(topColor: Color(0xFF3F6678), bottomColor: Color(0xFF23394A)),
  };
}
