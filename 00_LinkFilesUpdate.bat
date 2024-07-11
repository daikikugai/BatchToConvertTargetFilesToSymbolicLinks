@echo off
setlocal enabledelayedexpansion

rem SourceとTargetの親ディレクトリを設定
rem set sourceParentDir=D:\Project\Assets
set sourceParentDir=%~dp0Assets
set targetParentDir=X:\Project\Assets

rem 複数のソースディレクトリを設定 (Assets以下のパスを登録)
set sourceDirs=Thirdparty

rem 対象のファイル拡張子を設定
rem set exts=.fbx .png .jpg .psd .mp3 .wav .mp4 .tiff .tif .bmp .tga .exr .hdr .aif .aiff .mov .avi .flv .webm .ogv .ogg .webp .ttf .otf .bytes
set exts=.psd

rem sourceDirsで指定したフォルダ以下のサブディレクトリにある指定拡張子のファイルをシンボリックリンクファイルに変換
for %%D in (%sourceDirs%) do (
    set sourceDir=%sourceParentDir%\%%D
    echo !sourceDir! を処理します。 >> 00_LinkFilesUpdate.log
    call :CreateSymbolicLink !sourceDir!
)
exit /b

:CreateSymbolicLink
rem 拡張子の分だけ処理を繰り返す
for %%E in (!exts!) do (
    for /r %1 %%F in (*%%E) do (
        set skip=0
        rem シンボリックリンクファイルかどうかを判定
        dir /a:l "%%F" > nul 2>&1
        if !errorlevel! equ 0 (
            echo %%F はシンボリックリンクファイルです。 >> 00_LinkFilesUpdate.log
            set skip=1
        )

        if !skip! equ 0 (
            rem ファイルパスを取得
            set sourceFile=%%F
            rem echo ファイルパス：!sourceFile! >> 00_LinkFilesUpdate.log
            rem ファイル名を取得
            set fileName=%%~nxF
            rem echo ファイル名：!fileName! >> 00_LinkFilesUpdate.log
            rem ファイルの相対パスを取得
            set relPath=!sourceFile:%sourceParentDir%\=!
            rem echo ファイルの相対パス：!relPath! >> 00_LinkFilesUpdate.log
            rem ターゲットファイルのパスを設定
            set targetFile=!targetParentDir!\!relPath!
            rem echo ターゲットファイルのパス：!targetFile! >> 00_LinkFilesUpdate.log
            rem ターゲットのフォルダパスを取得
            set targetDir=!targetFile:%%~nxF=!
            rem echo ターゲットのフォルダパス：!targetDir! >> 00_LinkFilesUpdate.log

            rem ターゲットフォルダが存在しない場合は作成
            if not exist "!targetDir!" (
                mkdir "!targetDir!"
                rem echo !targetDir! を作成しました。 >> 00_LinkFilesUpdate.log
            )

            rem 元のファイルをターゲットフォルダに移動
            move "%%F" "!targetFile!"
            echo %%F を !targetFile! に移動 >> 00_LinkFilesUpdate.log

            rem シンボリックリンクを作成
            rem mklink "%%F" "!targetFile!"
            powershell -command start-process cmd.exe '/c mklink \"%%F\" \"!targetFile!\"' -verb runas

            echo %%F を !targetFile! に移動し、シンボリックリンクを作成しました。 >> 00_LinkFilesUpdate.log
        )
        
    )
)
exit /b