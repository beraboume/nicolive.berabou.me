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

`0.0.2`: 平成２７年１２月２０日（土）
---
* 変更: 一般追い出しコメント`/hb ifseetno`を非表示に

`0.0.1`: 平成２７年１１月２７日（金）
---
* 修正：セッションIDが84文字ではない場合、ログインできない不具合（[#18](https://github.com/59naga/nicolive.berabou.me/issues/18)）

`0.0.0`: 平成２７年１０月６日（火）
---
* 修正：`VoiceText Web API`を選択した時に`SpeechSynthesisUtterance`も同時に再生されてしまう不具合

平成２７年１０月５日（月）
---
* 変更：初めてコメントしたユーザーを太字にする(#7)
* 修正：URLは「URL省略」と読み上げるように(#11 一部)
* 修正：`VoiceText Web API`が同時に再生されてしまう不具合 (#9)
* 追加：[Open JTalk](https://github.com/59naga/openjtalk.berabou.me)を話者に選べるように (#10)

平成２７年１０月４日（日）
---
* 追加：コメント番号の表示。
* 変更：デザイン。angular-materialのバージョンを`0.11.2`に更新。
* 変更：リファクタリング。ディレクトリ構造と各ファイルの依存関係を簡素化。
* 変更：URLを開くさいの確認ダイアログを廃止。新しいウィンドウを開くように。
* 修正：主コメントのテキストも、URLがあればリンク化するように。(#5)
* 修正：読み上げ＞感情レベルが保存されない(#6)

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

# Setup & Boot

gitおよびNodeJSとbowerのインストールが終了していることが前提です。ターミナル／cmder環境下で

```bash
git clone https://github.com/59naga/nicolive.berabou.me.git
cd nicolive.berabou.me

npm install
npm start
# Server running at http://localhost:59798
```

とすることで、`http://localhost:59798`上に、開発環境を起動できます。

```bash
NODE_ENV=production npm start
# Server running at http://localhost:59798
```

とすることで、本番環境に近い、コンパイルを圧縮して、各`index`ファイルを公開します。
（初回起動時、ファイルの圧縮にCPUをかなり消費します。プロセスが強制終了して`pkgs.min.js`が生成されない場合は、`onefile -o pkgs.min.js -m`を手動で行う必要があるかもしれません。ファイルが`./pkgs.min.js`に存在する場合、圧縮処理は起動しません。）

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/
