; Module name: boot.asm
;
; Abstract:
;   Stage 1 bootloader executed by the BIOS
;   * Load the kernel bootstrap.
;
; Author: Abdulhadi5692HDI2-3
; Copyright (c) Abdulhadi5692HDI2-3 2024
;
; Licensed under MIT License;



; 386 cpu
.386
	option segment:use16 ; 16 bits !!!
.model tiny


.code
BOOTORIGIN equ 7C00H

; we (should) be loaded at 0x7c00
org BOOTORIGIN


start: 
	jmp short astart ; second start to set things up and go to label main.
	nop ; nop instruction required for a valid FAT boot record.

include W:\base\boot\bootparameterblock.inc

astart:
	
	main:
		cli
		xor ax, ax ; Location of the boot loader divided by 16
		mov ds, ax ; Set data segment to where we are loaded.
		mov es, ax
		add ax, 20h ; Skip over the size of the bootloader divided by 16 (512 / 16)
		mov ss, ax ; Set segment register to current location (start of stack)
		mov sp, 4096 ; Set ss:sp to the top of the 4k stack.
		sti
		
		mov [biosDriveNum], dl ; Store bootdrive number
		
		
		mov si, offset startup ; Load the string into the si register to print to the screen.
		call BootPutString ; Call the put string function.
		
		; read something from the floppy/disk
		mov ax, 1
		mov cl, 1
		mov bx, 7E00h
		call DiskRead
		
		
		cli
		hlt
	
; Functions
 
; Abstract: Puts a string from the [SI] register onto the screen
BootPutString PROC
	; Here we setup up the registers for the int 10 interrupt
	mov ah, 0Eh ; Tell the BIOS that we want to be in teletype mode
	mov bh, 00h ; Page number
	mov bl, 07h ; Normal text attribute
	
	@@_loop:
		lodsb ; Load [SI] into [AL] and increase [SI] by 1
	
	or al, al ; Check for end of string.(this checks if al = 0)
			  ; If it is zero it sets the zero flag in the register
			  ; C code: if (al == 0) { zeroflag = true; goto return; } return: /* nothing */
	jz return ; if zero then just stop
	int 10h ; BIOS video/teletype interrupt
	jmp @@_loop
	return:
	ret
BootPutString ENDP

; Abstract: quick way to reboot
; just jumps to beginning of BIOS which should cause a GPF

; Abstract: floppy error handler
ErrorHandle_FLP PROC
	mov si, offset diskreadfail
	call BootPutString
	call WaitForKey
	call REBOOT
ErrorHandle_FLP ENDP

; Abstract: Wait for a keypress
WaitForKey PROC
	mov ah, 0
	int 16h ; wait for key
WaitForKey ENDP

; Abstract: reboot
REBOOT PROC
	mov eax, 0ffffh
	jmp eax
REBOOT ENDP

; Abstract: Converts a LBA address in [AX] to a CHS address.
; IN:
;   ax - LBA address
; OUT:
;   cx [bits 0-5] - sector number
;   cx [bits 6-15] - cylinder
;   dh - head
;

LBA2CHS PROC

	push ax
	push dx
	
	xor dx, dx
	div [sectorsPerTrack]
	inc dx
	mov cx, dx
	
	xor dx, dx
	div [heads]
	
	mov dh, dl
	mov ch, AL
	shl ah, 6
	or cl, ah
	
	pop ax
	mov dl, al
	pop ax
	ret
LBA2CHS ENDP

; Abstract: Read from disk/floppy
; IN:
;   ax - LBA address
;   cl - Number of sectors to read (up to 128)
;   dl - Drive number
;   es:bx - memory address to store the data
;
DiskRead PROC
	push ax
	push bx
	push cx
	push dx
	push di
	
	push cx
	call LBA2CHS
	pop ax
	
	mov ah, 02h
	mov di, 3 ; retry 3 times until we just stop

_retry:
	pusha
	stc
	int 13h
	jnc _done
	
	; if we haven't jumped to .done then something went wrong.
	popa
	call DiskReset
	
	dec di
	test di, di
	jnz _retry ; retry again
	
_fail:
	; we have tried 3 times and it failed
	call ErrorHandle_FLP
_done:
	popa
	
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	ret
DiskRead ENDP

; Abstract: Resets disk/floppy controller
; IN:
;   dl - drive number
; OUT:
;   Nothing
;
DiskReset PROC
	pusha
	mov ah, 0
	stc
	int 13h
	jc ErrorHandle_FLP
	popa
	ret
DiskReset ENDP

startup db "MK2 Bootloader. Preparing. . ", 13, 10, 0 
diskreadfail db "Failed to operate on floppy!", 13, 10, 0
BYTE 510 - ($ - start) dup (0)
dw 0AA55h ; Boot signature for BIOS
END start
