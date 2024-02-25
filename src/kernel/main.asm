org 0x20000
bits 16

mov byte [disk_num], dl
%include "switch_mode_gdt.asm"

;;;;;;;;;;;;;;;;;;
;;; \/ MAIN \/ ;;;
;;;;;;;;;;;;;;;;;;
global_color: db 0x0A
welcome_msg:  db "Made by: F1L1P and Rilax",10,10,"HTC 32 bit prot-23022024 (proteted mode edition)",10,"Copyright (C) 2020-2024r.",10,10,0
terminal_msg: db "#> ",0

main: ; main loop
    [bits 32]

    mov ax, 0x10
    mov ds, ax
    mov ss, ax

    ; mov ah, [global_color]
    ; call clear_screen

    ; mov ah, [global_color]
    ; mov esi, welcome_msg
    ; call write_buffer
    ; mov esi, terminal_msg
    ; call write_buffer

    .loop:
    call keyboard_handler
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

; Include core and drivers!
bits 32
%include "core.asm"
%include "drivers/vga.asm"
%include "drivers/keyboard.asm"
;;;;;;;;;;;;;;;;;;
;;; /\ MAIN /\ ;;;
;;;;;;;;;;;;;;;;;;