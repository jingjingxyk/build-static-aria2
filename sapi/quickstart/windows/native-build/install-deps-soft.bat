@echo off

echo %~dp0
set CURRENT_DIR=%~dp0

cd ..\..\..\..\

set __PROJECT__=%cd%
echo %cd%


rem 命令行静默安装 msi
rem msiexec /i strawberry-perl-5.38.2.2-64bit.msi /quiet

msiexec /i strawberry-perl-5.38.2.2-64bit.msi  /passive


set "PATH=%PATH%;%__PROJECT__%\php\;%__PROJECT__%\nasm\;"


echo %PATH%

perl -v
php -v
nasm -v
