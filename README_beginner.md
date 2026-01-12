# onpre_k8s_print_hello

## はじめに
このリポジトリは **Kubernetes と CI/CD を初めて学ぶ方** を対象に以下の内容を **最小構成・実践重視** で体験できるサンプル。

* ローカルでの簡単なアプリ開発
* Docker イメージ化
* GitHub Actions による CI（自動テスト・ビルド）
* Kubernetes（CronJob）へのデプロイ
* Argo CD を用いた GitOps 型 CD
---
[READMEに戻る](README.md)

## このリポジトリで学べること

* CI（Continuous Integration）とは何か
* CD（Continuous Delivery / Deployment）とは何か
* GitHub Actions を使った CI の基本
* Kubernetes CronJob の基礎
* kubectl apply の限界
* Argo CD による GitOps の考え方
---
[READMEに戻る](README.md)

## 全体構成（開発フロー）

```
## Step1
GithubでIssue作成

## Step2
ローカルリポジトリ上で別ブランチ作成

## Step3
別ブランチをGithub上にも作成

## Step4
コード修正

## Step5
Githubにプッシュ

## Step6
Github上でPR作成
- Github-Actions (CI)
  - Dockerイメージビルド
  - テスト実行

## Step7
Github上でマージ
- Github-Actions (CI)
  - Dockerイメージビルド
  - 脆弱性スキャン
  - テスト実行
  - Github上の別ブランチ削除

## Step8
ローカルリポジトリ上で別ブランチ削除

## Step9
ローカルリポジトリ上のmainブランチをGithubと同期

## Step10
リリース
- Github-Actions (CI)
  - Dockerイメージビルド
  - DockerHubログイン
  - Dockerイメージをバージョンタグ付きでプッシュ

## Step11
YAMLマニフェスト更新
- Argo-CD (CD)
  - Argo-CD本体へログイン
  - Argo-CDアプリをGithubと同期
  - KubernetesのリソースがYAMLマニフェストと同期
```

```note
Githubを唯一の正(Single Source of Truth)とする
```
```note
Kubernetesには直接、kubectlコマンドで更新しない
```
---
[READMEに戻る](README.md)

## 前提環境

以下がローカルPCにセットアップされていることを前提とする。
* Windows11
* Docker-Desktop(Kubernetes有効化済み)
* kubectl
* Git
* ※ Argo CD CLI は後半でインストール。
---
[READMEに戻る](README.md)

## サンプルアプリについて

**目的はアプリ開発ではなく、CI/CDとKubernetes理解のため以下の単純な機能のみ**
- コンテナ起動時にメッセージを標準出力へ表示
- Kubernetes上でCronJobとして定期実行
---
[READMEに戻る](README.md)

## Kubernetesマニフェスト

* `onpre_k8s_print_hello.yaml`
  * Kubernetes CronJob リソース
  * namespace: `user-apps`

* CronJob を選んでいる理由：
  * Deployment より構造が単純
  * Pod / Job / CronJob の関係が理解しやすい
---
[READMEに戻る](README.md)

## CI：GitHub Actions
### GitHub-Actionsでは以下を自動化
* ソースコードのチェック
* 脆弱性スキャン
* Dockerイメージのビルド
* Dockerレジストリへのプッシュ

```note
CIの目的は壊れたものを素早く検知する
```
---
[READMEに戻る](README.md)

## kubectl apply では不十分な理由
* 誰が、いつ、どの状態をapplyしたか分からない
* Githubと実クラスタの状態がズレる
* 差分が可視化されない
---
[READMEに戻る](README.md)

## CD：Argo-CD
この問題を解決するためにArgo-CDを使う。

### Argo CD の役割
* Githubを常に監視
* GithubとKubernetesの差分検知
* Githubの内容を「正」としてクラスタへ反映

### メリット
* kubectl apply が不要
* 状態が常に可視化される
* 差分・履歴が追跡できる
---
[READMEに戻る](README.md)

## Argo-CD操作(概要)

```bash
## アプリ登録
argocd app create onpre-k8s-print-hello \
  --repo https://github.com/Makoto-Araki/onpre_k8s_print_hello \
  --path . \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace user-apps

## アプリ手動同期
argocd app sync onpre-k8s-print-hello
```

* `create`：GithubとKubernetesの紐付け
* `sync`：GithubからKubernetesへ反映
---
[READMEに戻る](README.md)

## よくある状態と意味

| 状態      | 意味                     |
| --------- | ----------------------- |
| OutOfSync | Githubとクラスタが不一致 |
| Synced    | 一致                    |
| Healthy   | リソースが正常           |
---
[READMEに戻る](README.md)
