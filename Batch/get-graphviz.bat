@echo off

REM Lots of Python lib binaries here: http://www.lfd.uci.edu/~gohlke/pythonlibs/

set gvhome=%programfiles(x86)%\Graphviz 2.28
if exist "%gvhome%" goto gvdone
call cinst Graphviz
reg add HKLM\SOFTWARE\ATT\Graphviz /v InstallPath /t REG_SZ /d "%gvhome%" /f
setx PATH "%PATH%;C:\Program Files (x86)\Graphviz 2.28\bin" /m
:gvdone

C:\python27\scripts\easy_install pydot

rem C:
rem cd %temp%
rem curl -O http://garr.dl.sourceforge.net/project/numpy/NumPy/1.8.0/numpy-1.8.0-win32-superpack-python2.7.exe
rem curl -O http://freefr.dl.sourceforge.net/project/matplotlib/matplotlib/matplotlib-1.3.1/matplotlib-1.3.1.win32-py2.7.exe

set pywin32=%userprofile%\Downloads\pywin32-218.4.win32-py2.7.exe
if not exist "%pywin32%" goto nopywin32
if exist "%temp%\pywin32\SCRIPTS\pywin32_postinstall.py" goto pywin32avail
call 7za x -o%temp%\pywin32 %pywin32%
:pywin32avail
xcopy %temp%\pywin32\SCRIPTS\*.* C:\python27\python\Scripts\ /y /d /s
xcopy %temp%\pywin32\PLATLIB\*.* C:\python27\python\Lib\site-packages\ /y /d /s
rd %temp%\pywin32 /s /q

C:
cd C:\python27
python Scripts\pywin32_postinstall.py -install

goto :eof

:nopywin32
echo Manually get pywin32-218.4.win32-py2.7.exe from:
echo http://www.lfd.uci.edu/~gohlke/pythonlibs/
goto :eof



