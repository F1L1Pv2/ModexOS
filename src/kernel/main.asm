org 0x20000
bits 16

mov byte [disk_num], dl
%include "switch_mode_gdt.asm"

;;;;;;;;;;;;;;;;;;
;;; \/ MAIN \/ ;;;
;;;;;;;;;;;;;;;;;;
buffer: db "Made by: F1L1P and Rilax",10,0
buffer: db "HTC 32 bit prot-23022024 (proteted mode edition)",10,"Copyright (C)",10,0
terminal_msg: db "#> ",0

main: ; main loop
    [bits 32]

    mov ax, 0x10
    mov ds, ax
    mov ss, ax

.loop:
    
    jmp .loop

    cli
    hlt ; End main loop

; disk byte table!
disk_num:     db 0
cylinder_num: db 0 
sector_num:   db 0
head_num:     db 0

; Screen buffer address!
ScreenBuffer  equ 0xB8000

; Include 32 bits core and drivers!
bits 32
%include "core.asm"
%include "drivers/vga.asm"
%include "drivers/ps2io.asm"
;;;;;;;;;;;;;;;;;;
;;; /\ MAIN /\ ;;;
;;;;;;;;;;;;;;;;;;