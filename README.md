# onpre_k8s_print_hello (バッチ処理)

## 前提条件
- Dockerhubにアカウント作成済
- Dockerhubにonpre_k8s_print_helloのDockerイメージリリース済
- Docker-DesktopがWindows11のローカルPC上で起動済
- Docker-DesktopでDockerhubにログイン済
- Githubにアカウント作成済
- Githubにonpre_k8s_print_helloのリモートリポジトリ作成済

## 開発概要
- バッチ処理作成
  - ローカルリポジトリ上で開発準備
  - 標準出力にHelloとプリントする単純なバッチ処理の動作確認
  - DockerHubにアップロード
  - Docker-Desktopの設定確認
  - Kubectlの準備
  - Kubernetes上で動作確認
  - Githb-Actionsを使用したCI/CD改善

## 開発記録
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

## バッチ処理のプログラム用ディレクトリ作成
$ cd ~/onpre_k8s_print_hello
$ mkdir src

## バッチ処理のプログラム作成
$ cd ~/onpre_k8s_print_hello
$ vi src/main.py

## バッチ処理のテスト用ディレクトリ作成
$ cd ~/onpre_k8s_print_hello
$ mkdir tests

## バッチ処理のテスト用プログラム作成
$ cd ~/onpre_k8s_print_hello
$ vi tests/test_main.py

## 開発イメージビルド
$ cd ~/onpre_k8s_print_hello
$ docker build --no-cache -t onpre_k8s_print_hello_image .

## 開発イメージからVSCode上で開発コンテナ起動
$ cd ~/onpre_k8s_print_hello
$ code .
```

### 標準出力にHelloとプリントする単純なバッチ処理の動作確認
```bash
## 開発コンテナ上のターミナルでバッチ処理の動作確認
$ cd ~
$ python src/main.py

## 開発コンテナ上のターミナルでバッチ処理のテスト
$ cd ~
$ python -m pytest tests/test_main.py
```

### DockerHubにアップロード
```bash
## DockerHubのイメージビルド
$ cd ~/onpre_k8s_print_hello
$ docker build --no-cache -t makotoaraki346/onpre_k8s_print_hello_image .

## DockerHubにアップロード
$ cd ~/onpre_k8s_print_hello
$ docker push makotoaraki346/onpre_k8s_print_hello_image
```

### Docker-Desktopの設定確認
```note
・Docker-DesktopのSettings > Resources > WSL Integration => UbuntuスイッチON
・Docker-DesktopのSettings > Kubernetes => Enable Kubernetesチェック
```

### Kubectlの準備
```bash
## kubectlバイナリのダウンロード
$ cd ~/onpre_k8s_print_hello
$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

## kubectlバイナリに権限付与
$ cd ~/onpre_k8s_print_hello
$ sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

## インストール確認
$ cd ~/onpre_k8s_print_hello
$ kubectl version --client

## ダウンロードしたkubectlバイナリ削除
$ cd ~/onpre_k8s_print_hello
$ rm kubectl

## 既存の設定ファイル削除
$ cd ~/.kube
$ mv config config_old

## Windows11側で起動しているDocker-Desktopの設定ファイルへのリンク作成
$ cd ~/.kube
$ ln -s /mnt/c/Users/(Windows側のユーザー名)/.kube/config config

## コンテキスト一覧
$ cd ~/onpre_k8s_print_hello
$ kubectl config get-contexts

## コンテキスト確認
$ cd ~/onpre_k8s_print_hello
$ kubectl config current-context

## コンテキスト切替 ※コンテキスト切替時に実行
$ cd ~/onpre_k8s_print_hello
$ kubectl config use-context (コンテキスト名)
```

### Kubernetes上で動作確認
```bash
## コンテキスト一覧
$ cd ~/onpre_k8s_print_hello
$ kubectl config get-contexts

## コンテキスト確認
$ cd ~/onpre_k8s_print_hello
$ kubectl config current-context

## 名前空間一覧
$ cd ~/onpre_k8s_print_hello
$ kubectl get namespaces

## 名前空間作成
$ cd ~/onpre_k8s_print_hello
$ kubectl create namespace user-apps

## Cronjobリソース用のYAMLファイル作成
$ cd ~/onpre_k8s_print_hello
$ vi onpre_k8s_print_hello.yaml

## Cronjobリソース作成
$ cd ~/onpre_k8s_print_hello
$ kubectl apply -n user-apps -f onpre_k8s_print_hello.yaml

## Cronjobリソース確認
$ cd ~/onpre_k8s_print_hello
$ kubectl -n user-apps get cronjobs 

## Cronjobリソース動作確認1
$ cd ~/onpre_k8s_print_hello
$ kubectl -n user-apps get jobs ※Cronjobから起動されたJob名を確認

## Cronjobリソース動作確認2
$ cd ~/onpre_k8s_print_hello
$ kubectl -n user-apps get pods --selector=job-name=(取得したJob名) ※Jobから起動されたPod名を確認

## Cronjobリソース動作確認3
$ cd ~/onpre_k8s_print_hello
$ kubectl -n user-apps logs (取得したPod名) ※PodのログからHelloを確認
```

