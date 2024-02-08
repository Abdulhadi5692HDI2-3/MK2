@echo off
:::::::::::::::::::::::::::::::::::::::::::::::
:: Script name: unmountdrive.bat
::
:: Abstract:
::  Unmount the W: drive
::  Set the _MK2_DRIVE variable to _NODRIVE
::
:: Copyright (c) Abdulhadi5692HDI2-3 2024-2024.
:: It license under MIT License
:::::::::::::::::::::::::::::::::::::::::::::::
if exist \\.\W:\ goto :continue

:continue
subst W: /d
set _MK2_DRIVE=_NODRIVE
exit /b %errorlevel