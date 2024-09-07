function New-AwsRoleSession {

    param (
        [string]$profileName
    )
    
    # profileName が空なら入力を促す
    # TODO: oneloginのjsonファイルを読み取り、profileNameを選択する処理を追加
    if (-not $profileName) {
        $profileName = Read-Host "Profile Name"
    }

    # 今いるディレクトリを保存
    $currentDir = Get-Location

    # onelogin-aws-assume-role というコマンドがなければインストール
    if (-not (Get-Command onelogin-aws-assume-role -ErrorAction SilentlyContinue)) {
        # oneloginモジュールの仮想環境を起動
        Set-Location $PSScriptRoot\onelogin-python-aws-assume-role
        # venvがなければ作成
        if (-not (Test-Path .\venv)) {
            python -m venv .venv
        }
        .\.venv\Scripts\Activate.ps1
        pip install setuptools 2>&1 > $null 
        python setup.py develop  2>&1 > $null

        # TODO: oneloginのjsonファイルを設定する処理を追加

    }

    # onelogin-aws-assume-roleを実行
    onelogin-aws-assume-role --profile $profileName

    # oneloginモジュールの仮想環境を終了
    deactivate

    # 元いたディレクトリを戻す
    Set-Location $currentDir

}