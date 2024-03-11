org 0x100000
use32

;;;;;;;;;;;;;;;;;;
;;; \/ MAIN \/ ;;;
;;;;;;;;;;;;;;;;;;
main: ; main loop
    mov dword [memmory_table_ptr], eax
    add eax, 20*24
    mov dword [memmory_table_end_ptr], eax
    mov dword [memmory_table_count], ebx
    mov dword [kernel_size_in_bytes], edx

    call calculate_ram
    call setup_physical_alloc

    mov ah, [global_color]
    call clear_screen
    mov esi, welcome_msg
    call write_buffer

.loop:
    mov ah, [global_color]
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
    mov esi, read_content

    mov edi, clear_cmd
    call cmp_str
    je .clear_cmd
    mov edi, cls_cmd
    call cmp_str
    je .clear_cmd

    mov edi, help_command
    call cmp_str
    je .help_cmd

    mov edi, ver_command
    call cmp_str
    je .ver_cmd

    mov edi, say_command
    call cmp_str
    je .say_cmd

    mov edi, ping_command
    call cmp_str
    je .ping_cmd

    mov edi, motd_command
    call cmp_str
    je .motd_cmd

    mov edi, time_command
    call cmp_str
    je .time_cmd

    mov edi, cal_command
    call cmp_str
    je .cal_command

    mov edi, test_command
    call cmp_str
    je .test_command

    mov edi, bindec_command
    call cmp_str
    je .bindec_command

    mov edi, memdup_command
    call cmp_str
    je .memdup_command

    mov edi, love_command
    call cmp_str
    je .love_command

    mov esi, invalid_command
    call write_buffer
    ret

    .clear_cmd:
    mov ah, [global_color]
    call clear_screen
    jmp .after

    .help_cmd:
    mov esi, help_command_msg
    call write_buffer
    jmp .after

    .ver_cmd:
    mov esi, version_msg
    call write_buffer
    jmp .after

    .say_cmd:
    call read_buffer
    call new_line
    jmp .after

    .ping_cmd:
    mov esi, ping_command_msg
    call write_buffer
    call new_line
    jmp .after

    .motd_cmd:
    mov ah, [global_color]
    call clear_screen
    mov esi, welcome_msg
    call write_buffer
    jmp .after

    .time_cmd:
    call global_time
    call new_line
    call new_line
    jmp .after

    .test_command:
    ; call test

    ; mov eax, .test_command
    ; call binary_hexadecimal

    ; call new_line

    ; xor eax, eax
    ; mov ax, ((.test_command shr 16) and 0xFFFF)
    ; call binary_hexadecimal
    ; call new_line

    mov esi, memmory_bit_map
    mov edx, 8*8
    call dump_xbits
    call new_line

    call alloc_page
    mov eax, esi
    call binary_hexadecimal
    call new_line

    push esi

    mov esi, memmory_bit_map
    mov edx, 8*8
    call dump_xbits
    call new_line

    call alloc_page
    mov eax, esi
    call binary_hexadecimal
    call new_line

    mov esi, memmory_bit_map
    mov edx, 8*8
    call dump_xbits
    call new_line

    pop esi

    mov ah, byte [global_color]
    mov al, 'F'
    call write_char
    inc word [cursor]
    mov eax, esi
    call binary_hexadecimal
    call new_line

    call free_page

    mov esi, memmory_bit_map
    mov edx, 8*8
    call dump_xbits
    call new_line

    call alloc_page
    mov eax, esi
    call binary_hexadecimal
    call new_line

    mov esi, memmory_bit_map
    mov edx, 8*8
    call dump_xbits
    call new_line

    call alloc_page
    mov eax, esi
    call binary_hexadecimal
    call new_line


    mov esi, memmory_bit_map
    mov edx, 8*8
    call dump_xbits
    call new_line

    push esi
    ;;;


    call alloc_page
    mov eax, esi
    call binary_hexadecimal
    call new_line

    mov esi, memmory_bit_map
    mov edx, 8*8
    call dump_xbits
    call new_line

    pop esi

    call free_page

    mov esi, memmory_bit_map
    mov edx, 8*8
    call dump_xbits
    call new_line

    call new_line
    jmp .after

    .bindec_command:
    call binary_decimal
    call new_line
    jmp .after

    .cal_command:
    ; call calculator
    call new_line
    jmp .after

    .memdup_command:
    call new_line
    call memmory_dump
    jmp .after

    .love_command:
    ; call cls
    call valentine
    call new_line
    jmp .after
.after:
    ret

clear_command:
    mov ah, [global_color]
    call clear_screen
    ret

memmory_table_ptr: dd 0
memmory_table_end_ptr: dd 0
memmory_table_count: dd 0

kernel_size_in_bytes: dd 0


global_color: db 0x0a

welcome_msg:  db "Made by: F1L1P and Rilax",10,10
 version_msg: db "System MODEX prot-11032024 32-bits",10
              db "Copyright (C) 2020-2024r.",10,10
              db 0

terminal_msg: db "#> ",0


clear_cmd:       db "clear",  0 ; Clear command
cls_cmd:         db "cls",    0 ; Clear command
help_command:    db "help",   0 ; Help command
ver_command:     db "ver",    0 ; Version command
say_command:     db "say",    0 ; Say command
ping_command:    db "ping",   0 ; Ping command
motd_command:    db "motd",   0 ; Motd command
time_command:    db "time",   0 ; Time command
cal_command:     db "cal",    0 ; Calculator command
memdup_command:  db "memdup", 0 ; Calculator command

test_command: db "test", 0
bindec_command: db "bindec", 0
fatal_error_command: db "death", 0 ; fatal error test

love_command:        db "love", 0 ; z
ping_command_msg:    db "pong!", 10, 0
; version_command_msg: db 0

help_command_msg: 
    db 10
    db "1. help    -  Help information.",10
    db "2. cls     -  Clears the screen.",10
    db "3. ver     -  Displays the system version.",10
    db "4. say     -  Comment.",10
    db "5. ping    -  pong!",10
    db "6. motd    -  Displays welcome text.",10
    db "7. time    -  Displays the current time (HH:MM:SS / DD.MM.YYYY).",10
    db "8. cal     -  Calculator.",10
    db "9. memdup  -  Physical Memory map",10
    ; db "10. list    -  Displays a list of files and subdirectories in a directory.",10
    ; db "11. cd      -  Changes the current directory.",10
    ; db "12. sd      -  Displays the name of the current directory.",10
    ; db "13. dup     -  Copies one or more files to another location.",10
    ; db "14. mov     -  Moves one or more files to another location.",10
    db 10,0

invalid_command: db 'Invalid command!',10,10,0

; disk byte table!
disk_num:     db 0
cylinder_num: db 0
sector_num:   db 0
head_num:     db 0


panic:
    push esi
    push eax

    mov ah, 0x04
    push esi
    mov esi, panic_msg
    call new_line
    call write_buffer

    pop esi
    call write_buffer
    call new_line
    mov al, 32
    call write_char
    call update_cursor

    pop eax
    pop esi

    cli
    hlt

panic_msg: db "KERNEL PANIC: ", 0

; Include core and drivers!        
include "../eastereggs/valentine.asm"
include "core/initial_tools.asm"  
include "src/drivers/ps2_keyboard.asm"
include "src/drivers/filesys.asm"
;;;;;;;;;;;;;;;;;;
;;; /\ MAIN /\ ;;;
;;;;;;;;;;;;;;;;;;

memmory_bit_map: