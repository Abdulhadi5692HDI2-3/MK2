@ECHO OFF
:: Compiles all the .00X into a single 7z
set FINALARCHIVE="%CD%\mk2be.toolchain.7z"

cd %~dp0
:: Combine all the .00X files
copy /B "mk2be.toolchain.7z.001" + "mk2be.toolchain.7z.002" + "mk2be.toolchain.7z.003" + "mk2be.toolchain.7z.004" + "mk2be.toolchain.7z.005" + "mk2be.toolchain.7z.006" "%FINALARCHIVE%"
echo OUT: %FINALARCHIVE%
cd ..
goto :eof
