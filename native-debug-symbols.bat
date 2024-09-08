@echo off

set "source_dir=.\build\app\intermediates\merged_native_libs\release\out\lib"
set "output_zip=.\native-debug-symbols.zip"

if exist "%output_zip%" (
    echo Excluindo arquivo existente: %output_zip%
    del /f /q "%output_zip%"
)

echo Compactando %source_dir% em %output_zip%
powershell -command "Compress-Archive -Path '%source_dir%\*' -DestinationPath '%output_zip%'"

if exist "%output_zip%" (
    echo %output_zip%
) else (
    echo Error.
)

pause
