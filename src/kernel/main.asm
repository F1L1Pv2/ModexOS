%include "core/initial_setup.asm"

;;;;;;;;;;;;;;;;;;
;;; \/ MAIN \/ ;;;
;;;;;;;;;;;;;;;;;;
global_color: db 0x0A
welcome_msg:  db "Made by: F1L1P and Rilax",10,10,"Modex 32 bit prot-27022024 (proteted mode edition)",10,"Copyright (C) 2020-2024r.",10,10,0
terminal_msg: db "#> ",0

memmory_dump:
    [bits 32]
    mov esi, memmory_table
.loop:
    cmp esi, memmory_table_end
    jge .after

    mov edx, 8
    call dump_xbytes_big_endian

    mov ah, [global_color]
    mov al, 32
    call write_char

    call dump_xbytes_big_endian
    call write_char

    mov edx, 4
    call dump_xbytes_big_endian
    call write_char

    call dump_xbytes_big_endian
    call new_line

    jmp .loop


.after:

    ret

calculate_ram:
    mov esi, memmory_table
.loop:
    cmp esi, memmory_table_end
    jge .after

    add esi, 24

    cmp dword [esi-4-4], 1
    jne .loop

    mov eax, dword [esi-4-4-8]
    add dword [avaliable_ram], eax
    jmp .loop
.after:
    ret

avaliable_ram: dd 0

main: ; main loop
    [bits 32]

    mov ax, 0x10
    mov ds, ax
    mov ss, ax


    mov ah, [global_color]
    call clear_screen
    mov esi, welcome_msg
    call write_buffer

.loop:

    mov esi, terminal_msg
    call write_buffer
    call read_buffer

    cmp word[read_cursor], 0
    jne .run_command

.after:
    jmp .loop

.run_command:
    call run_command
    jmp .after

    cli
    hlt ; End main loop


run_command:
    mov esi, invalid_command
    call write_buffer
    ret

clear_command:
    mov ah, [global_color]
    call clear_screen
    ret

clear_cmd: db 'clear'
clear_cmd_len equ $-clear_cmd

invalid_command: db 'invalid command', 10 , 0

; disk byte table!
disk_num:     db 0
cylinder_num: db 0
sector_num:   db 0
head_num:     db 0

; Include core and drivers!
%include "drivers/vga.asm"
%include "drivers/ps2_keyboard.asm"
%include "core/io.asm"
;;;;;;;;;;;;;;;;;;
;;; /\ MAIN /\ ;;;
;;;;;;;;;;;;;;;;;;