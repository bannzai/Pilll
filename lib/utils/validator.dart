/// メールアドレスの形式が有効かどうかを検証する
///
/// 以下の形式に対応:
/// - 基本形式: user@example.com
/// - エイリアス付き: user+alias@gmail.com
/// - サブドメイン: user@mail.example.com
/// - アンダースコア、ドット、ハイフン含む: user_name.test-1@example.co.jp
bool isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
  );
  return emailRegex.hasMatch(email);
}
