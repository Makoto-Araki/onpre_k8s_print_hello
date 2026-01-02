# onpre_k8s_print_hello (バッチ処理)

## 前提条件
- Dockerhubにアカウント作成済
- Dockerhubにonpre_k8s_print_helloのDockerイメージリリース済
- Githubにアカウント作成済
- Githubにonpre_k8s_print_helloのリモートリポジトリ作成済

## 処理概要
- 標準出力にHelloとプリントする単純なバッチ処理

## 環境構築
### ローカルリポジトリ上で開発準備
```bash
## ディレクトリ作成
$ cd ~
$ mkdir onpre_k8s_print_hello

## ローカルリポジトリ初期化
$ cd ~/onpre_k8s_print_hello
$ git init

## ローカルリポジトリ初期設定 
$ git config --global user.email (自分のメールアドレス)
$ git config --global user.name Makoto-Araki

## リモートリポジトリ設定
$ cd ~/onpre_k8s_print_hello
$ git branch -M main

## リモートリポジトリ設定
$ cd ~/onpre_k8s_print_hello
$ git remote add origin git@github.com:Makoto-Araki/onpre_k8s_print_hello.git

## 開発イメージ用のDockerfile作成
$ cd ~/onpre_k8s_print_hello
$ vi Dockerfile

## バッチ処理のソースファイル作成
$ cd ~/onpre_k8s_print_hello
$ vi main.py

## 開発イメージビルド
$ cd ~/onpre_k8s_print_hello
$ docker build --no-cache -t onpre_k8s_print_hello_image .

## 開発イメージからVSCode上で開発コンテナ起動
$ cd ~/onpre_k8s_print_hello
$ code .
```

```note
開発コンテナ上でターミナルを開き「python main.py」を実行して「Hello」とターミナルに表示
```

