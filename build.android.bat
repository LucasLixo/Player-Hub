@echo off

:: Definindo variáveis para o nome do app e os diretórios de build
set APP_NAME=Player Hub
set BUILD_DIR=build

:: Gerar APK
echo Gerando APK...
flutter build apk --release

:: Gerar AAB
echo Gerando AAB...
flutter build appbundle --release

:: Mostrar onde os arquivos gerados estão localizados
echo Builds concluídos com sucesso!
echo APK gerado em: %BUILD_DIR%\app\outputs\flutter-apk\app-release.apk
echo AAB gerado em: %BUILD_DIR%\app\outputs\bundle\release\app-release.aab
pause
