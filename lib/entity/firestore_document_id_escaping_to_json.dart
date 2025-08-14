// reference: https://stackoverflow.com/questions/59756031/how-to-exclude-a-single-field-from-json-serialization-with-json-serializable

/// Firestoreドキュメント処理時のJSONシリアライゼーション用ユーティリティ関数。
/// 特定のフィールドをnullに変換してJSONから除外する際に使用される。
/// @JsonKeyアノテーションのtoJsonパラメータと組み合わせて、
/// フィールドの値を常にnullに変換する機能を提供する。
dynamic toNull(_) => null;
