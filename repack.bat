@echo off
setlocal enabledelayedexpansion

:: Clear the screen before displaying the message
cls

:: Display "Coded by NunYa" message before starting the process
echo.
echo ============================
echo     Coded by NunYa
echo	 
echo ============================
echo.
pause

:: Set path to the location of extract-xiso.exe (same folder as this script)
set EXTRACT_XISO_PATH=%~dp0extract-xiso.exe

:: Get the current directory (same folder as this script and extract-xiso.exe)
set CURRENT_DIR=%~dp0

:: Check if extract-xiso.exe exists in the same directory as the batch file
if not exist "%EXTRACT_XISO_PATH%" (
    echo extract-xiso.exe not found in %CURRENT_DIR%
    pause
    exit /b 1
)

:: Loop through each folder in the current directory (skip extract-xiso.exe and the batch file itself)
for /d %%F in ("%CURRENT_DIR%*") do (
    if /i not "%%F" == "%CURRENT_DIR%" if /i not "%%F" == "%EXTRACT_XISO_PATH%" (
        
        :: Get the folder name (without path)
        set "FOLDER_NAME=%%~nxF"
        
        :: Set the output .iso file name to the folder name in the current directory
        set "ISO_FILE=%CURRENT_DIR%!FOLDER_NAME!.iso"

        :: Check if the ISO file already exists
        if exist "!ISO_FILE!" (
            echo ISO file already exists for folder: %%F
            echo Skipping folder: %%F
        ) else (
            :: Check if the folder contains any files (avoid empty folders)
            dir /b "%%F" >nul 2>&1
            if errorlevel 1 (
                echo Skipping empty folder: %%F
            ) else (
                echo Repacking folder: %%F

                :: Immediately create the .iso file (name it after the folder)
                echo Creating ISO: "!ISO_FILE!"

                :: Repack the folder content into a new .iso file using extract-xiso.exe -c
                "%EXTRACT_XISO_PATH%" -c "%%F" "!ISO_FILE!"

                :: Check if repacking was successful
                if !ERRORLEVEL! neq 0 (
                    echo Failed to repack folder: %%F
                ) else (
                    echo Repacking successful for: %%F
                )
            )
        )
    )
)

:: Display "Coded by NunYa" message after the process completes
cls
echo.
echo ============================
echo     Coded by NunYa
echo ============================
echo.
echo Process Completed Successfully!
pause

endlocal
exit /b 0
