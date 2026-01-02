FROM makotoaraki346/python_base_image:v1.0.0

# コンテナ内の作業ディレクトリを設定
WORKDIR /app

# 依存関係ファイルを先にコピー(ビルドキャッシュの最適化のため)
COPY requirements.txt .

# requirements.txtに基づきPythonパッケージをインストール
RUN pip install --no-cache-dir -r requirements.txt

# 残りのソースコードをコンテナ内にコピー
COPY . .

# バッチ処理実行
CMD ["python", "main.py"]
