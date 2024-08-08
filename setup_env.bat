@echo off
REM 仮想環境の作成（Python 3.11を使用）
python3.11 -m venv my_env

REM 仮想環境の有効化
call my_env\Scripts\activate

REM pipを指定バージョンにアップグレード
python -m pip install --upgrade pip==24.2

REM 必要なパッケージをインストール（例としてrequirements.txtを使う）
if exist requirements.txt (
    pip install -r requirements.txt
)

REM 環境が正常に有効化されたか確認
echo ok!

pause
