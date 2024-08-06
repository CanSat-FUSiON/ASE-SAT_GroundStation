# ASE-Sat Lite 地上局

## 使い方
- windowsを想定
1. WSL2上でDockerを起動してデータベースであるInfluxDBおよび可視化ツールであるGrafanaを動作させる
1. ホストOS上で無線機(今回はESP-32)とのデータのやり取りを行うPythonIFを起動
1. その他の補助的なUIを起動(コマンド送信/姿勢viewerなど)

### 環境構(最初の1回のみ)
1. pythonをインストール
    https://learn.microsoft.com/ja-jp/windows/python/beginners#install-python
1. WSL2をインストール
    https://learn.microsoft.com/ja-jp/windows/wsl/install
1. Dockerをインストール
    https://qiita.com/ryotaro76/items/305d4d61dfd82e3f2bfa
1. windowsおよびWSL2上の任意のディレクトリにこのリポジトリをclone
1. windows側の`setup_env.bat`をダブルクリックで実行してpythonの仮想環境を構築(少し時間がかかる)

### 起動(使いたいとき)
1. (サーバーの起動) wsl2上で以下のようにコマンド`docker compose up -d`を実行
    ```
    mission5-ground-station$ docker compose up -d
    ```
1. (地上局テレメ画面の起動) `http://localhost:8085/dashboards`にアクセス
    
    今のところユーザー名はadminでパスワードもadmin
1. (地上局コマンドCUIの起動) `Python_IF.bat`を実行

    COMPortとbaudを入力 (baudは入力せずにEnterでOK)
1. (3DViewerの起動) `Attitude_view.bat`を実行
1. (地上局コマンドGUIの起動) `CommandUI.bat`を実行


### 終了(終わりたいとき)
1. ターミナルでCtrl+Cを押す or windowの終了ボタンを押下
1. 以下のコマンドを実行
    ```
    mission5-ground-station$ docker compose down
    ```

## ファイル・ディレクトリ構成(抜粋)

    mission5-ground-station
    ├─ASE-GS-client:ホストOS側のpythonコードが入るフォルダ
    │  ├─client:PythonIFとなるソースコードが入るフォルダ
    │  ├─command:コマンドUIが入るフォルダ
    │  └─GS3D_viewer_matplotlib:matplotlibライブラリによる3Dviewer
    ├─client:FUSiON-M5の地上局
    ├─docker:docker:Dockerのvolume用フォルダ
    ├─Attitude_view.bat:3DViewer立ち上げ用バッチファイル
    ├─CommandUI.bat:地上局コマンドUI立ち上げ用バッチファイル
    ├─PythonIF.bat:地上局コマンドCUI立ち上げ用バッチファイル
    ├─setup_env:Python仮想環境構築用バッチファイル
    └─requirements.txt:仮想環境に要求されるバージョンを記述するファイル
