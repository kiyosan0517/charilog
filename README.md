# ChariLog(チャリログ)
【サービスURL】**https://charilog.jp**

## サービス概要
自慢のカスタムや友人とのツーリングなどの思い出を写真・カスタムパーツ(アイテム)と共に発信できる、 自転車というツールに特化した投稿サービスです。

## 想定されるユーザー層
- 自転車に関する思い出などを記録したい人
- 自転車に関連した投稿を発信/共有したい人
- 他の人の自転車に関連する投稿を見たい人

## サービスコンセプト
### なぜそのサービスを作ろうと思ったのか
- **自転車の楽しさを共有できる友人づくりに多少苦労した経験があったため**
<br />=> アメリカやヨーロッパ圏などではBMXやロードレース等を中心とした自転車競技がメジャースポーツとして発展しているものの、
日本においては健康志向の中年層がメインに利用するマイナースポーツに留まっているのが現状です。
特に10~20代の若年層の利用者人口は少なく、私自身趣味である自転車の楽しさを共有できる友人づくりに多少苦労した経験がありました。

- **SNSの投稿を見ても詳細なカスタムパーツ等を確認できないことが多いため**
<br />=> 自転車は非常にカスタム性が高く、持ち主の個性が強く出る乗り物ですが、XやFacebookに投稿された画像等を見ても、
どんなメーカーのどのようなパーツ/アイテムを使ってカスタムしているのかを分かりづらいと感じる時がありました。

そこで、`自転車という共通の趣味を持った友人を作りたい方のニーズ`、`カスタムアイテムを見てみたい方のニーズ`を満たせるような、自転車に特化した投稿サービスを考案しました。

### どこが売りになるか、差別化ポイントになるか
自転車というツールに特化したコミュニティ内であれば、自転車という共通の趣味を持つ友人の少ない方であっても、
XやFacebookなど以上に自転車に関連する投稿を発信しやすくなり、より交流が増えるのではないかと考えます。
<br />
また、カスタムに使用したアイテムを表示できる仕組みを設けることで、ユーザーの個性を可視化できるように考案した本サービスでは、
自分の趣味・嗜好に近い人を探しやすくなるなど、通常の投稿サービスより交流を増やせるのではとも考えます。

### どのようなサービスにしていきたいか
**「自転車乗りの友人を作りたい！」**、そんな思いを持つ人たちを繋げていけるようなコミュニティにしたいです！

## サービス紹介
- 全ページにて**レスポンシブ対応**しているため、どのデバイスからでも使用可能です
- メイン機能に関しては、スマホ等のデバイスでは**ナビゲーションフッター**から、PC等のデバイスでは**サイドバー**からアクセス可能

<br />

| 新規登録 | ログイン/トップ | ログイン/トップ |
| :---: | :---: | :---: |
| ![charilog-user-new](https://github.com/kiyosan0517/charilog/assets/131296049/502b194d-1593-43d3-9f6a-588c4cf16115) | ![charilog-login](https://github.com/kiyosan0517/charilog/assets/131296049/8f10daab-16da-4886-835d-cc69f4934d10) | ![charilog-login](https://github.com/kiyosan0517/charilog/assets/131296049/a79c9eb9-68ce-4d3e-aa2b-cc02f6ce3da6) |
| メールアドレス・パスワードの他に、アイコン画像やユーザー名、お気に入りメーカーを登録可能 | ログインページにはパスワードリセットのためのリンクも用意 | ログインページ下部にはサービス詳細、XとLINEへのシェアボタン、最新の投稿を表示 |
<br>

| ログ一覧（ホーム） | いいね一覧 | ログ投稿 |
| :---: | :---: | :---: |
| ![charilog-posts-index](https://github.com/kiyosan0517/charilog/assets/131296049/df35ecdd-df12-4ff3-b152-a9b6e2f13b36) | ![charilog-likes-index](https://github.com/kiyosan0517/charilog/assets/131296049/ffeeb05e-8d29-4981-8dfc-dac93f8e6c7d) | ![charilog-post-new](https://github.com/kiyosan0517/charilog/assets/131296049/aa6eabeb-91d9-46cb-89ff-96f1cbabafad) |
| ログの検索、検索条件クリア、ログの並び替えが可能 | いいねした投稿のみを一覧形式で確認可能 | 画像やアイテムをログに紐づけて投稿可能 |
<br>

| ログ詳細 | ログ詳細 | マイページ（ユーザー詳細） |
| :---: | :---: | :---: |
| ![charilog-post-show](https://github.com/kiyosan0517/charilog/assets/131296049/d4730935-ec47-4a4f-98e2-3a45fe9090b2) | ![charilog-post-show](https://github.com/kiyosan0517/charilog/assets/131296049/da3a2f7b-2187-4697-9928-78419d466b1c) | ![charilog-user-show](https://github.com/kiyosan0517/charilog/assets/131296049/5b59c564-7d94-46c0-a96e-16ac281ba2df) |
| 各ログ詳細にはシェアボタンを設置。<br>他ユーザーのログにはいいねが可能 | 登録アイテムの情報として、商品画像、商品名、商品価格、楽天へリンクが確認可能 | マイページorユーザー詳細では、自分や他ユーザーの詳細な情報を確認可能。ここにもシェアボタンを設置 |
<br>

## 機能概要
### 実装済み機能
- 会員登録
- ログイン
- ログアウト
- 投稿機能（楽天APIから取得した商品情報を紐付ける）
- 投稿編集/削除
- 投稿検索機能（タイトル・本文・自転車メーカー）
- 投稿並べ替え機能（新着・古い・タイトル降順・タイトル昇順・いいね多い）
- ユーザー編集（プロフィール/パスワードリセット）
- ユーザー検索機能（ユーザーネーム・自転車メーカー）
- 検索条件リセット機能
- 検索オートコンプリート（入力補完）機能（現状ユーザー検索のみ）
- フォロー機能
- いいね機能
- シェア機能（X,LINEへのシェア）

### 今後の実装予定機能
- コメント機能
- タグ機能
- 投稿検索オートコンプリート機能（対象はタグ）
- マイバイク管理機能
  - メンテナンス管理（いつ、どんなメンテナンスを行なったかを記録する機能）
  - メンテナンス通知（給油や部品交換等の目安・時期を通知する機能）
- 投稿に位置情報を紐づける機能（API(Google Map)を使用する予定）

## 使用技術
### フロントエンド
- Bootstrap
- JavaScript
- jQuery
- Stimulus
- Sass

### バックエンド
- Ruby（3.1.0）
- Rails（6.0.6.1）
- PostgreSQL（14.10）

### インフラ
- AWS
  - EC2
  - RDS（PostgreSQL）
  - Route53
  - ALB
  - S3
  - CloudFront
- puma
- Nginx

## インフラ構成図
![charilog-infrastructure](https://github.com/kiyosan0517/charilog/assets/131296049/006bc42c-68f9-419e-869e-e672883a152a)

## ER図
![charilog-table](https://github.com/kiyosan0517/charilog/assets/131296049/38d125dd-d71b-4b1b-97ab-6b9bb7059e57)
