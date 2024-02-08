@echo off
:: this removes the tools dir ready to commit to github
echo Please wait for the CMD windows to complete!
start cmd.exe /c rd /s /q W:\tools && echo null > taskcomp

:wait
if exist taskcomp echo done! && goto :complete
if not exist taskcomp echo still waiting for cmd window && goto :wait

:complete
echo Complete! errorlevel = %errorlevel%
del taskcomp
exit /b %errorlevel%