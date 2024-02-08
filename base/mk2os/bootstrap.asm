; Module name: bootstrap.asm
;
; Abstract:
;   Bootstrap executed by bootloader.
;	* Set the environment for kernel.
;
; Author: Abdulhadi5692HDI2-3
; Copyright (c) Abdulhadi5692HDI2-3 2024
;
; Licensed under MIT License;

 
.386
	option segment:use16 ; 16 bits
.model tiny

.code
BOOTORIGIN EQU 7C00H

org BOOTORIGIN


start:
	jmp $


byte 510 - ($ - start) dup (0) ; pad with zeros
dw 0AA55h ; Boot signature for BIOS
END start