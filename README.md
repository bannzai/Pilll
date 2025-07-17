<img width="320px" src="./homepage/homepage.png" />

# Pilll
![Test](https://github.com/bannzai/Pilll/workflows/Test/badge.svg)

## HP
https://pilll.wraptas.site/

## Blogs
- [個人開発のお話](https://bannzai.hatenadiary.jp/entry/2021/05/10/054207)

## Download
- [Google Play](https://play.google.com/store/apps/details?id=com.mizuki.Ohashi.Pilll)
- [App Store](https://apps.apple.com/jp/app/pilll-%E3%83%94%E3%83%AB%E3%83%AA%E3%83%9E%E3%82%A4%E3%83%B3%E3%83%80%E3%83%BC%E3%81%B4%E3%82%8B%E3%82%8B/id1405931017)

## App
- [利用規約](https://bannzai.github.io/Pilll/Terms)
- [プライバシーポリシー](https://bannzai.github.io/Pilll/PrivacyPolicy)
- [特定商取引法に基づく表示](https://bannzai.github.io/Pilll/SpecifiedCommercialTransactionAct)

## LICENSE
ライセンスと書いておきながら規格に沿ったものの提示は無いです。原則[No LICENSE](https://choosealicense.com/no-permission/)です。つまり著作権と同等の権利を主張します。
ただしPull Request等は許可したいので独自で許可することを定めて列挙します。

- このソフトウェアを使用・複写できることを無償で許可します
- 当リポジトリにPull Requestを送る、または個人利用の範囲内ではソースコードの変更を認めます
- 利用に伴い作成者はいかなる責任も負いません
- 当リポジトリに存在する あなた が改変したソースコードに対して、私を含む他者が自由に改変できることを認めてください

## 動作確認方法

### RangeError修正の確認（bugfix/range-error）
1. 21錠タイプのピルシートを設定
2. 21番目（最後）のピルまで服用記録を進める
3. 設定画面から「服用お休み期間を始める」を選択
4. エラーが発生しないことを確認

#### 確認ポイント
- rest_durationダイアログが正常に表示される
- 日付が「1/22」など翌日の日付として表示される
- 「服用お休み期間 1/12〜14」のようなオーバーレイが正常に表示される

