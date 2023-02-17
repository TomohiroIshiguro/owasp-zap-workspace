# ローカルに OWASP ZAP 実行環境を構築する

## OWASP ZAP とは

```
The OWASP Zed Attack Proxy (ZAP) is one of the world’s most popular free security tools and is actively maintained by a dedicated international team of volunteers. It can help you automatically find security vulnerabilities in your web applications while you are developing and testing your applications. It's also a great tool for experienced pentesters to use for manual security testing.
```
Ref: https://github.com/zaproxy/zaproxy

## リポジトリのファイル構成

Makefile: リポジトリをクローン後のコマンド。

## 作業手順

1. 当リポジトリをクローンする
2. OWASP ZAP を実行する (コンテナを起動して、Web アプリの設定を監査する)
   - USAGE: make zap-weekly URL={対象となる Web アプリの URL}
3. output/ に監査結果が出力されるので、html ファイルを web ブラウザで開く

## 備考

Makefile のコマンドで実行した場合、コンテナは終了したら破棄するオプションをつけて起動しています。
