import os
import re

# 正規表現パターン
pattern = re.compile(r"(Text\(|return |text:)\s*[']([^']+)[']")

# 検索対象のディレクトリ（適宜変更してください）
directory_to_search = "./"  # カレントディレクトリ

# 一致したファイルを格納するリスト
matching_files = []

def search_files(directory):
    """指定したディレクトリ内のファイルを再帰的に検索"""
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".dart"):  # Dartファイルを対象にする
                file_path = os.path.join(root, file)
                with open(file_path, "r", encoding="utf-8") as f:
                    try:
                        content = f.read()
                        if pattern.search(content):
                            matching_files.append(file_path)
                    except Exception as e:
                        print(f"Error reading {file_path}: {e}")

# 実行
search_files(directory_to_search)

# 結果を出力
if matching_files:
    print("一致するファイル:")
    for file in matching_files:
        print(file)
else:
    print("一致するファイルは見つかりませんでした。")

