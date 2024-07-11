@echo off
setlocal enabledelayedexpansion

rem Source��Target�̐e�f�B���N�g����ݒ�
rem set sourceParentDir=D:\Project\Assets
set sourceParentDir=%~dp0Assets
set targetParentDir=X:\Project\Assets

rem �����̃\�[�X�f�B���N�g����ݒ� (Assets�ȉ��̃p�X��o�^)
set sourceDirs=Thirdparty

rem �Ώۂ̃t�@�C���g���q��ݒ�
rem set exts=.fbx .png .jpg .psd .mp3 .wav .mp4 .tiff .tif .bmp .tga .exr .hdr .aif .aiff .mov .avi .flv .webm .ogv .ogg .webp .ttf .otf .bytes
set exts=.psd

rem sourceDirs�Ŏw�肵���t�H���_�ȉ��̃T�u�f�B���N�g���ɂ���w��g���q�̃t�@�C�����V���{���b�N�����N�t�@�C���ɕϊ�
for %%D in (%sourceDirs%) do (
    set sourceDir=%sourceParentDir%\%%D
    echo !sourceDir! ���������܂��B >> 00_LinkFilesUpdate.log
    call :CreateSymbolicLink !sourceDir!
)
exit /b

:CreateSymbolicLink
rem �g���q�̕������������J��Ԃ�
for %%E in (!exts!) do (
    for /r %1 %%F in (*%%E) do (
        set skip=0
        rem �V���{���b�N�����N�t�@�C�����ǂ����𔻒�
        dir /a:l "%%F" > nul 2>&1
        if !errorlevel! equ 0 (
            echo %%F �̓V���{���b�N�����N�t�@�C���ł��B >> 00_LinkFilesUpdate.log
            set skip=1
        )

        if !skip! equ 0 (
            rem �t�@�C���p�X���擾
            set sourceFile=%%F
            rem echo �t�@�C���p�X�F!sourceFile! >> 00_LinkFilesUpdate.log
            rem �t�@�C�������擾
            set fileName=%%~nxF
            rem echo �t�@�C�����F!fileName! >> 00_LinkFilesUpdate.log
            rem �t�@�C���̑��΃p�X���擾
            set relPath=!sourceFile:%sourceParentDir%\=!
            rem echo �t�@�C���̑��΃p�X�F!relPath! >> 00_LinkFilesUpdate.log
            rem �^�[�Q�b�g�t�@�C���̃p�X��ݒ�
            set targetFile=!targetParentDir!\!relPath!
            rem echo �^�[�Q�b�g�t�@�C���̃p�X�F!targetFile! >> 00_LinkFilesUpdate.log
            rem �^�[�Q�b�g�̃t�H���_�p�X���擾
            set targetDir=!targetFile:%%~nxF=!
            rem echo �^�[�Q�b�g�̃t�H���_�p�X�F!targetDir! >> 00_LinkFilesUpdate.log

            rem �^�[�Q�b�g�t�H���_�����݂��Ȃ��ꍇ�͍쐬
            if not exist "!targetDir!" (
                mkdir "!targetDir!"
                rem echo !targetDir! ���쐬���܂����B >> 00_LinkFilesUpdate.log
            )

            rem ���̃t�@�C�����^�[�Q�b�g�t�H���_�Ɉړ�
            move "%%F" "!targetFile!"
            echo %%F �� !targetFile! �Ɉړ� >> 00_LinkFilesUpdate.log

            rem �V���{���b�N�����N���쐬
            rem mklink "%%F" "!targetFile!"
            powershell -command start-process cmd.exe '/c mklink \"%%F\" \"!targetFile!\"' -verb runas

            echo %%F �� !targetFile! �Ɉړ����A�V���{���b�N�����N���쐬���܂����B >> 00_LinkFilesUpdate.log
        )
        
    )
)
exit /b