@echo off

setlocal enableextensions enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%

cd /d %__PROJECT__%\var\windows-build-deps\php-src\

set X_MAKEFILE=%__PROJECT__%\var\windows-build-deps\php-src\Makefile

:: set "PATH=%ProgramFiles%\7-Zip;%ProgramFiles%\Git\bin;%__PROJECT__%\bin\runtime\;%__PROJECT__%\bin\runtime\nasm\;%__PROJECT__%\bin\runtime\php;%__PROJECT__%\bin\runtime\libarchive\bin;%PATH%"

rem https://learn.microsoft.com/zh-cn/cpp/error-messages/tool-errors/linker-tools-warning-lnk4098?view=msvc-170&redirectedfrom=MSDN
rem https://learn.microsoft.com/zh-cn/cpp/build/reference/md-mt-ld-use-run-time-library?view=msvc-170
rem /VERBOSE:LIB	/NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:libcmtd.lib /NODEFAULTLIB:msvcrtd.lib

rem -lucrt

sed.exe -i 's/\/LD \/MD/\/MT \/WHOLEARCHIVE/' %X_MAKEFILE%
sed.exe -i 's/\/D _USRDLL/ /' %X_MAKEFILE%
sed.exe -i 's/ZEND_DLIMPORT/ /' Zend\zend_stream.c
:: sed.exe -i 's/: \$\(BUILD_DIR\)\\\$\(PHPDLL\)/: \$\(BUILD_DIR\)\\\$\(PHPDLL\) x-php-lib /' Zend\zend_stream.c

findstr /C:"x-show-var: " %X_MAKEFILE%
findstr /C:"x-show-var: " %X_MAKEFILE% > nul

if errorlevel 1 (
	echo "custom x-show-var config !"
	goto x-custom-show-var-start
) else (
	echo "custom x-show-var config file exits !"
	goto x-custom-show-var-end
)

:x-custom-show-var-start
echo x-show-var:                                          >> %X_MAKEFILE%
echo    ^@echo BUILD_DIR: $(BUILD_DIR)                    >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo CFLAGS: $(CFLAGS)                          >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo LDFLAGS: $(LDFLAGS)                        >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo LDFLAGS_CLI: $(LDFLAGS_CLI)                >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo LIBS: $(LIBS)                              >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo LIBS_CLI: $(LIBS_CLI)                      >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo PHP_LDFLAGS: $(PHP_LDFLAGS)                >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo DEPS_CLI: $(DEPS_CLI)                      >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo CFLAGS_PHP_OBJ: $(CFLAGS_PHP_OBJ)          >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo CFLAGS_BD_ZEND: $(CFLAGS_BD_ZEND)          >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo CLI_GLOBAL_OBJ: $(CLI_GLOBAL_OBJS)         >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo ASM_OBJS: $(ASM_OBJS)                      >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo STATIC_EXT_LIBS: $(STATIC_EXT_LIBS)        >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo STATIC_EXT_LDFLAGS: $(STATIC_EXT_LDFLAGS)  >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo STATIC_EXT_CFLAGS: $(STATIC_EXT_CFLAGS)    >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo BUILD_DIR\PHPLIB: $(BUILD_DIR)\$(PHPLIB)   >> %X_MAKEFILE%
echo    ^@echo ==================                             >> %X_MAKEFILE%
echo    ^@echo BUILD_DIR\PHPDLL: $(BUILD_DIR)\$(PHPDLL)   >> %X_MAKEFILE%
echo    ^@echo ==================                             >> %X_MAKEFILE%
echo    ^@echo CLI_GLOBAL_OBJS_RESP: $(CLI_GLOBAL_OBJS_RESP)  >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo _VC_MANIFEST_EMBED_EXE: $(_VC_MANIFEST_EMBED_EXE) >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo PHPDEF: $(PHPDEF)            >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo PHPDLL_RES: $(PHPDLL_RES)    >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo ASM_OBJS: $(ASM_OBJS)        >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo MCFILE: $(MCFILE)            >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%

:x-custom-show-var-end


findstr /C:"x-release-php:" %X_MAKEFILE% >nul

if errorlevel 1 (
	echo "custom x-release-php config !"
	goto x-release-php-start
) else (
	echo "custom x-release-php config file exits !"
	goto x-release-php-end
)

:x-release-php-start
echo. >> %X_MAKEFILE%

echo. >> %X_MAKEFILE%
echo x-release-php^: $(DEPS_CLI) $(CLI_GLOBAL_OBJS) generated_files $(PHP_GLOBAL_OBJS) $(STATIC_EXT_OBJS)  $(ASM_OBJS) $(MCFILE)   $(BUILD_DIR)\php.exe.res $(BUILD_DIR)\php.exe.manifest   >> %X_MAKEFILE%
echo 	@"$(LINK)" /nologo $(CLI_GLOBAL_OBJS_RESP) $(PHP_GLOBAL_OBJS) $(STATIC_EXT_OBJS_RESP) $(STATIC_EXT_LIBS) $(ASM_OBJS) $(LIBS_CLI) $(BUILD_DIR)\php.exe.res /out:$(BUILD_DIR)\php.exe $(LDFLAGS) $(LDFLAGS_CLI) $(LIBS) >> %X_MAKEFILE%
rem echo 	-@$(_VC_MANIFEST_EMBED_EXE) >> %X_MAKEFILE%




rem https://www.cnblogs.com/sherry-best/archive/2013/04/15/3022705.html
rem https://learn.microsoft.com/zh-CN/cpp/c-runtime-library/crt-library-features?view=msvc-170&viewFallbackFrom=vs-2019

rem echo 	-@$(_VC_MANIFEST_EMBED_EXE)   >> %x_makefile%
rem echo 	^@echo SAPI sapi\cli build complete  >> %x_makefile%
rem echo 	@if exist php.exe.manifest $(MT) -nologo -manifest php.exe.manifest -outputresource:php.exe    >> %x_makefile%

rem  /WHOLEARCHIVE  /NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:msvcrtd.lib /FORCE:MULTIPLE
rem libcpmt.lib  libvcruntime.lib libucrt.lib msvcrt.lib
rem  /NODEFAULTLIB:libc.lib /NODEFAULTLIB:libcmt.lib /NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:libcd.lib /NODEFAULTLIB:libcmtd.lib /NODEFAULTLIB:msvcrtd.lib
rem libvcruntime.lib libcmt.lib

rem /MANIFEST:php.exe.manifest /MANIFESTUAC:uiAccess /SUBSYSTEM:CONSOLE  /subsystem:windows

:x-release-php-end



cd %__PROJECT__%
endlocal
