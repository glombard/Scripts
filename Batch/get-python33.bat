@echo off

powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://gist.github.com/glombard/7416112/raw/fb317426b2092a41770cf86b50463fb0c2f73706/get-curl.ps1'))"

curl -O http://python.org/ftp/python/3.3.2/python-3.3.2.msi
curl -O http://python-distribute.org/distribute_setup.py
curl -k -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py

msiexec /i python-3.3.2.msi /passive /norestart /log %temp%\python-install.log
set PATH=%PATH%;C:\Python33
python distribute_setup.py
python get-pip.py

set PATH=%PATH%;C:\Python33\Scripts
setx PATH "%PATH%" /m

REM pip install markdown
