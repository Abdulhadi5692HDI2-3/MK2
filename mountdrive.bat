@echo off
:::::::::::::::::::::::::::::::::::::::::::::::
:: Script name: mountdrive.bat
::
:: Abstract:
::  Mount the repo dir to the W: drive
::  Set the _MK2_DRIVE environment variable
::
:: Copyright (c) Abdulhadi5692HDI2-3 2024-2024.
:: It license under MIT License
:::::::::::::::::::::::::::::::::::::::::::::::
if exist \\.\W:\ echo W: is already mounted! Try unmounting with unmountdrive.bat! && exit /b 1
subst W: .
set _MK2_DRIVE=W:
exit /b %errorlevel%