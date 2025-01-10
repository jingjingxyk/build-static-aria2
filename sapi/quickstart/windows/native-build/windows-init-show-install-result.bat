@echo off

setlocal


echo %~dp0


cd /d %~dp0
cd /d ..\..\..\..\


set "__PROJECT__=%cd%"
echo %cd%

md %__PROJECT__%\var\windows-build-deps\
md %__PROJECT__%\bin\runtime\

cd /d %__PROJECT__%\var\windows-build-deps\


echo %ProgramFiles(x86)%
echo %USERPROFILE%
echo %NUMBER_OF_PROCESSORS%
echo %ProgramFiles%
set "PATH=%ProgramFiles%\Git\bin;%__PROJECT__%\bin\runtime\;%__PROJECT__%\bin\runtime\nasm\;%__PROJECT__%\bin\runtime\php;%__PROJECT__%\bin\runtime\libarchive\bin;%PATH%"
set "PATH=%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\;%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\msys2\bin;%PATH%"
echo "%PATH%"

:: git config --global core.autocrlf false
:: git config --global core.eol lf
:: git config --global core.ignorecase false

perl -v
nasm -v
git version
curl -V
:: dir %__PROJECT__%\bin\runtime\php\ext\
php -c %__PROJECT__%\bin\runtime\php.ini -v
php -c %__PROJECT__%\bin\runtime\php.ini -m
php -c %__PROJECT__%\bin\runtime\php.ini --ri curl
php -c %__PROJECT__%\bin\runtime\php.ini composer.phar list

:: vswhere find  Visual Studio component
:: https://github.com/microsoft/vswhere/wiki/Examples

vswhere -?
vswhere -all

set

endlocal
