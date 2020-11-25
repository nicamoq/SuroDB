@echo off
cls
mode con: cols=50 lines=30

:var
set version=1
set entry=0
call :startup
call :dbcheck
goto :menu

:menu
color 0f
title SuroDB :: CMD DB system.
cls
echo %entry% things in the database so far.
echo.
echo 1 = Add
echo 2 = Overwrite
echo 3 = View
echo 4 = Clear
mChoice
If %errorlevel% == 49 goto :create
if %errorlevel% == 50 goto :delete
if %errorlevel% == 51 goto :view
if %errorlevel% == 52 goto :clear
goto menu

:clear
cls
del /f "%dir%\database.bat"
goto :var

:create
set say=echo.
title SuroDB :: Add to database.
cls
:create-0
cls
echo Enter anything.
%say%
echo.
:create-1
mChoice
if %errorlevel% == 33 (goto menu)
set /p crea=
cls
(
echo.
echo set /a entry+=1
echo set slot%entry%=%crea%
) >> "%dir%\database.bat"
call "%dir%\database.bat"
set say=echo "%crea%" has been added to entry #%entry%. Write something again. (! before typing to exit)
goto create-0

:delete
title SuroDB :: Overwrite an entry.
cls
echo Enter the entry number (slot[number])
mChoice
if %errorlevel% == 33 (goto menu)
set /p ovnum=
cls
echo Enter anything that will overwrite entry %ovnum%.
mChoice
if %errorlevel% == 33 (goto menu)
set /p crea=
cls
(
echo.
echo :: overwrites slot%ovnum%
echo set slot%ovnum%=%crea%
) >> "%dir%\database.bat"
call "%dir%\database.bat"
goto menu

:view
cls
title SuroDB :: Creating the database.
if exist "%dir%\viewcache.bat" (del /f "%dir%\viewcache.bat")
set saves=0
set entcount=0
call :dbcheck

:entcoun
cls
if %entcount% == 0 (call :viewzero)
set /a entcount+=1
set entcountp=%%slot%entcount%%%
(
echo.
echo echo Entry #%entcount% : %entcountp%
) >> "%dir%\viewcache.bat"
set /a saves+=1
if %saves% == %entry% (goto :view-2) ELSE (goto :entcoun)

:view-2
title SuroDB :: The database.
cls
call "%dir%\viewcache.bat"
echo.
pause >nul
goto menu

:viewzero
set entcountp=%%slot%entcount%%%
(
echo.
echo echo Entry #0 : %entcountp%
) >> "%dir%\viewcache.bat"
goto :EOF


:startup
:: Basic startup calls
pushd %~dp0
set dir=%CD%
goto :EOF

:dbcheck
:: Database check
if exist "%dir%\database.bat" (call "%dir%\database.bat") ELSE (goto :dbcheck-2)
goto :EOF
:dbcheck-2
(
echo :dbvar
echo set entry=0
echo.
) > "%dir%\database.bat"
goto :dbcheck