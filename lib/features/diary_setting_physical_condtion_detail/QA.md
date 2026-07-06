---
feature: diary_setting_physical_condtion_detail
verification: mobile-mcp
last_verified_commit: 34b7e05eb0ed73e5ee0caa2a91a96147e2edaded
last_verified_at: 2026-07-05
---

# diary_setting_physical_condtion_detail QA

## 1. 初期表示

- [x] **既定症状の初期表示**: diary_post 画面の「体調詳細」の鉛筆アイコン（プレミアム/トライアル中ユーザー）からこの画面を開くと、頭痛・腹痛・吐き気など既定の症状項目一覧がボトムシートに表示される
  - Note: プレミアム/トライアル状態のテストアカウントが必要

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **既定症状の初期表示**: diary_post 画面の「体調詳細」の鉛筆アイコン（プレミアム/トライアル中ユーザー）からこの画面を開くと、頭痛・腹痛・吐き気など既定の症状項目一覧がボトムシートに表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/29463ca2-48fa-4e48-b556-eaba83168814.png" width="320">

</details>

</details>

---

## 2. 項目の追加

- [x] **項目の追加**: 上部のテキスト欄に文字を入力しキーボードの確定（Done/Enter）を押すと、入力した文字列が一覧の先頭に追加され、テキスト欄は空にリセットされる
- [x] **文字数制限**: テキスト欄は8文字を超えて入力できない

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **項目の追加**: 上部のテキスト欄に文字を入力しキーボードの確定（Done/Enter）を押すと、入力した文字列が一覧の先頭に追加され、テキスト欄は空にリセットされる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/d514b1ca-2254-4af7-bc4a-c48022b95bbf.png" width="320">

</details>

### **文字数制限**: テキスト欄は8文字を超えて入力できない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/074c80dc-0cd7-48a2-afcc-05300128fb72.png" width="320">

</details>

</details>

---

## 3. 項目の削除

- [x] **項目の削除**: 一覧の各行にあるゴミ箱アイコンをタップすると、その項目が一覧から削除される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **項目の削除**: 一覧の各行にあるゴミ箱アイコンをタップすると、その項目が一覧から削除される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/f03e29c6-eac4-438c-adc7-17a6e9fa71b6.png" width="320">

</details>

</details>

---

## 4. diary_post 画面との連携

- [x] **追加・削除内容の反映**: この画面で追加・削除した症状項目は、diary_post 画面の「体調詳細」チップ一覧（プレミアム/トライアル中ユーザー向け）に反映される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **追加・削除内容の反映**: この画面で追加・削除した症状項目は、diary_post 画面の「体調詳細」チップ一覧（プレミアム/トライアル中ユーザー向け）に反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/f34f8d9c-7aa3-41bc-b54d-23364069305e.png" width="320">

</details>

</details>
