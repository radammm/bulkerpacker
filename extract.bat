@echo off
setlocal enabledelayedexpansion

:: Set path to the location of extract-xiso.exe
set EXTRACT_XISO_PATH=C:\Users\adam\Desktop\extract-xiso.exe

:: Set the UNC path to the folder containing .iso files
set UNC_PATH=\\TRUENAS\Data\Emulation\Roms\xbox\Myrient

:: Set the destination directory where extracted files will be stored
set DEST_DIR=\\TRUENAS\Data\Emulation\Roms\xbox\Myrient\extracted

:: Set Samba share credentials
set USERNAME=adammm
set PASSWORD=280102
set DRIVE_LETTER=Z:

:: Check if extract-xiso.exe exists
if not exist "%EXTRACT_XISO_PATH%" (
    echo extract-xiso.exe not found at %EXTRACT_XISO_PATH%
    exit /b 1
)

:: Check if destination directory exists, create if not
if not exist "%DEST_DIR%" (
    echo Destination directory not found. Creating directory: %DEST_DIR%
    mkdir "%DEST_DIR%"
)

:: Map network drive using provided Samba credentials
echo Connecting to network share...
net use %DRIVE_LETTER% "%UNC_PATH%" /user:%USERNAME% %PASSWORD%

:: Check if the network share was successfully mapped
if %ERRORLEVEL% neq 0 (
    echo Failed to connect to network share. Check credentials and network connection.
    exit /b 1
)

:: Loop through all .iso files in the specified folder on the mapped network drive
for %%F in ("%DRIVE_LETTER%\*.iso") do (
    echo Extracting ISO: %%F to %DEST_DIR%\%%~nF

    :: Extract the ISO file to a subfolder named after the ISO file (without the extension)
    "%EXTRACT_XISO_PATH%" "%%F" "%DEST_DIR%\%%~nF"

    :: Check if extraction was successful
    if %ERRORLEVEL% neq 0 (
        echo Failed to extract: %%F
    ) else (
        echo Extraction successful for: %%F
    )
)

:: Disconnect the network drive after the extraction is complete
echo Disconnecting from network share...
net use %DRIVE_LETTER% /delete

endlocal
exit /b 0
