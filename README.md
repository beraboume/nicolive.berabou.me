# [nicolive.berabou.me](http://nicolive.berabou.me/)

> HTML5コメントビューアー。

## つかいかた

![nicolive berabou me](https://cloud.githubusercontent.com/assets/1548478/8642348/eee1d1ae-295d-11e5-8be8-741b4bcf08bd.png)

* ①… `lv99999`, `co99999`, `nsen/***`のような書式のURLをニコ生のコメントサーバーとみなして、接続をこころみます。
* ②… コミュニティページを開きます
* ③… [Web Speech Synthesis API](http://qiita.com/kyota/items/da530ad22733b644518a)を使用して、文章を読み上げます。（[IE,Firefoxでは動きません](http://caniuse.com/#feat=web-speech)）
* ④… 閲覧しているコメントサーバーへコメントを送信します
* ⑤… 匿名コメント／実名コメントを切り替えます

## chrome/Firefox/safari プラグイン

![nicolive berabou me-boot-button](https://cloud.githubusercontent.com/assets/1548478/8642349/eee2f638-295d-11e5-9070-bc202cf4da25.png)

gtk2k氏の[nicolive.berabou.me-boot-button](https://github.com/gtk2k/nicolive.berabou.me-boot-button)をブラウザに導入することで、配信画面の上部メニューの「コメビュ」ボタンから、ダイレクトにnicolive.berabou.meを起動することができます。

# 更新履歴

平成２７年７月２２日（土）
---
* iPhoneでも読み上げが再生できるようにtouchstartに無音ファイルを再生する処理を追記
* wav -> aacに変更
* コメント入力欄の autofocus を除去（初回タップ時にバーチャルキーボードが出る）

平成２７年７月１８日（土）
---
* [VoiceText Web API](https://cloud.voicetext.jp/webapi)を使用して読み上げ出来るようにボイスを追加

平成２７年７月１７日（金）
---
* コメント中のURLをクリックで開けるように修正
* １８４ボタンを記憶するように修正

平成２７年７月１２日（日）
---
* アルファ版を公開
* 読み上げ機能の実装
* 外人のボイスを選択時は文章をローマ字にして無理やり読ませるように変更

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/
