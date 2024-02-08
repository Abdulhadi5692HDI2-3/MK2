!!!!!!!!!!!!!
MK2
!!!!!!!!!!!!!

Building (win32 only)
==================
1. Open a command prompt window. (administrator prompt if you want to overwrite the A: drive)
2. Switch to the MK2 dir.
3. Execute `mountdrive.bat`
4. Switch to the W: drive. (it mounts it to W) (TODO: allow to change what drive letter is going to be mounted)
5. From the command prompt window run toolchain\toolchain7z.bat
6. Extract the content of the mk2be.toolchain.7z file (in the main MK2 dir) to W:\tools\
7. Then (from the other command prompt) run tools\_missile.bat
8. In the new command prompt run build to build the OS


Copying to a floppy disk
=====================
The floppy disk should be mounted in drive A: (TODO: allow to change which drive to overwrite)
1. In the "MK2 BUILD ENVIRONMENT" command prompt, type copytofloppy to overwrite drive A
