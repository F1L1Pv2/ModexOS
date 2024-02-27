%include "core/initial_setup.asm"

;;;;;;;;;;;;;;;;;;
;;; \/ MAIN \/ ;;;
;;;;;;;;;;;;;;;;;;
%substr compile_day __DATE__ 9,2
%substr compile_month __DATE__ 6,2
%substr compile_year __DATE__ 1,4

global_color: db 0x0a
welcome_msg:  db "Made by: F1L1P and Rilax",10,10
              db "System Modex 32 bit prot-",compile_day,compile_month,compile_year," (proteted mode edition)",10
              db "Copyright (C) 2020-",compile_year,"r.",10,10,0
terminal_msg: db "#> ",0

main: ; main loop
    [bits 32]

    mov ax, 0x10
    mov ds, ax
    mov ss, ax

    call calculate_ram

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
    mov edi, version_command_msg
    call write_buffer
    jmp .after

    .say_cmd:
    ; call say
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
    ; call date_time
    call new_line
    jmp .after

    .test_command:
    ; call test
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

clear_cmd:    db "clear", 0 ; Clear command
cls_cmd:      db "cls",   0 ; Clear command
help_command: db "help",  0 ; Help command
ver_command:  db "ver",   0 ; Version command
say_command:  db "say",   0 ; Say command
ping_command: db "ping",  0 ; Ping command
motd_command: db "motd",  0 ; Motd command
time_command: db "time",  0 ; Time command
cal_command:  db "cal",   0 ; Calculator command
memdup_command:  db "memdup",   0 ; Calculator command

ver2_command: db "ver2", 0
test_command: db "test", 0
bindec_command: db "bindec", 0
fatal_error_command: db "death", 0 ; fatal error test
restore_cmd_command: db "rescmd", 0 ; fatal error test
mov_ax_cx_command: db "ax=cx", 0 ; nie dziala (narazie)

love_command: db "love", 0 ; z
ping_command_msg: db "pong!", 10, 0
version_command_msg: db 0

help_command_msg: 
    db 10
    db "1. help   - Help.",10
    db "2. cls    - Clear text.",10
    db "3. ver    - System version.",10
    db "4. say    - Comment.",10
    db "5. ping   - pong!",10
    db "6. motd   - Welcome text.",10
    db "7. time   - Displays the current time (HH:MM:SS / DD.MM.YYYY).",10
    db "8. cal    - Calculator.",10
    db "9. memdup - Physical Memory map",10
    db 10,0

invalid_command: db 'Invalid command!', 10 , 0

; disk byte table!
disk_num:     db 0
cylinder_num: db 0
sector_num:   db 0
head_num:     db 0

; Include core and drivers!        
%include "core/initial_tools.asm"  
%include "drivers/ps2_keyboard.asm"
%include "drivers/vga.asm"         
;;;;;;;;;;;;;;;;;;
;;; /\ MAIN /\ ;;;
;;;;;;;;;;;;;;;;;;