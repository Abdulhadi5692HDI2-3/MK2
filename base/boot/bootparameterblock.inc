; Module name: bootparameterblock.inc
;
; Abstract:
;   Boot parameter block for floppy disk
;
; Author: Abdulhadi5692HDI2-3
; Copyright (c) Abdulhadi5692HDI2-3 2024
;
; Licensed under MIT License;

; OEM Parameter block
; STARTOEMBLOCK
    OEMName	          db "MSWIN4.1" ; Disk label
    bytesPerSector    dw 512	    ; Bytes per sector
    sectorsPerCluster db 1			; Sectors per cluster
    reservedSectors   dw 1			; Reserved sectors
    fats	          db 2			; Number of fats
    rootDirEntries    dw 224	    ; Number of entries in root dir
    sectors	          dw 2880	    ; Logical sectors
    mediaType	      db 0f0h       ; Media descriptor byte
    fatSectors        dw 9			; Sectors per FAT
    sectorsPerTrack   dw 18			; Sectors per track
    heads	          dw 2			; Number of sides/heads
    hiddenSectors     dd 0			; Hidden sectors
    hugeSectors	      dd 0			; LBA sectors
	
	; Extended OEM Parameter block (FAT12+)
    biosDriveNum      db 0h 		; Drive number, 0h for floppy, 80h for HDD. (This is useless because on a different machine
									; it would probally have a different drive number depending on the BIOS).
    reserved	      db 0			; Reserved (Flags for WINNT otherwise reserved)
    bootSignature     db 41			; Drive signature
    volumeId	      dd 0			; Volume ID
    volumeLabel	      db "NO NAME    " ; Volume Label
    fatTypeLabel      db "FAT12   "	   ; File system type
; ENDOEMBLOCK