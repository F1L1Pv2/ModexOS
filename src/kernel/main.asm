call cls
mov ax, 0
mov cx, 0

mov bx, welcome_msg
call write_buffer

main:
    mov bx, command_tag
    call write_buffer

    mov bx, command
    mov dx, command_len
    call clear_buffer
    call read_buffer

    call new_line
    call choose_command

    jmp main

choose_command:
    mov bx, command

    mov dx, cls_command
    call cmp_str
    je .cls_cmd

    mov dx, help_command
    call cmp_str
    je .help_cmd

    mov dx, ver_command
    call cmp_str
    je .ver_cmd

    mov dx, say_command
    call cmp_str
    je .say_cmd

    mov dx, ping_command
    call cmp_str
    je .ping_cmd

    mov dx, motd_command
    call cmp_str
    je .motd_cmd

    mov dx, time_command
    call cmp_str
    je .time_cmd

    mov dx, cal_command
    call cmp_str
    je .cal_command

    mov dx, ver2_command
    call cmp_str
    je .ver2_cmd

    mov dx, test_command
    call cmp_str
    je .test_command

    mov dx, bindec_command
    call cmp_str
    je .bindec_command

    mov dx, love1_command
    call cmp_str
    je .love_command
    mov dx, love2_command
    call cmp_str
    je .love_command


    cmp byte [bx], 0
    je .nothing

    mov bx, unknown_command_msg
    call write_buffer
    ret

    .cls_cmd:
    call cls
    ret

    .help_cmd:
    mov bx, help_command_msg
    call write_buffer
    ret

    .ver_cmd:
    mov bx, version_command_msg
    call write_buffer
    ret

    .say_cmd:
    call say
    ret

    .ping_cmd:
    mov bx, ping_command_msg
    call write_buffer
    call new_line
    ret

    .motd_cmd:
    call cls
    mov bx, welcome_msg
    call write_buffer
    ret

    .time_cmd:
    call date_time
    call new_line
    ret

    .ver2_cmd:
    push ax

    mov al, '2'
    call write_char
    mov al, '3'
    call write_char
    mov al, '5'
    call write_char
    mov al, '0'
    call write_char

    pop ax

    call new_line
    call new_line
    ret

    .test_command:
    call test
    call new_line
    ret

    .bindec_command:
    call binary_decimal
    call new_line
    ret

    .cal_command:
    call calculator
    call new_line
    ret

    .love_command:
    ; call cls
    call valentine
    call new_line
    ret

    .nothing:
    ret

%define HEART 2563
%define NEW_LINE 10,13
%define DATE "2020-2024r."
%define VER "System HTC build-14022024 16-bits",NEW_LINE

welcome_msg: db "Made by: F1L1P and Rilax",NEW_LINE,NEW_LINE,VER,"Copyright (C) ",DATE,NEW_LINE,NEW_LINE,"Type help a for a list of commands.",NEW_LINE,NEW_LINE, 0

unknown_command_msg: db "The command does not exist. Type help a for a list of commands", NEW_LINE, NEW_LINE, 0

help_command_msg: 
db NEW_LINE,"1. help - Help.",NEW_LINE,"2. cls  - Clear text.",NEW_LINE,"3. ver  - System version.",NEW_LINE,"4. say  - Comment.",NEW_LINE,"5. ping - pong!",NEW_LINE,"6. motd - Welcome text.",NEW_LINE,"7. time - Displays the current time (HH:MM:SS / DD.MM.YYYY).",NEW_LINE,"8. cal  - Calculator.",NEW_LINE,NEW_LINE, 0

version_command_msg: db VER,"Copyright (C) ","2020-2024r.",NEW_LINE,NEW_LINE, 0
ping_command_msg: db "pong!", NEW_LINE, 0
null_msg: db 0

command_tag: db "> ", 0

cls_command: db "cls", 0
help_command: db "help", 0
ver_command: db "ver", 0
say_command: db "say", 0
ping_command: db "ping", 0
motd_command: db "motd", 0
time_command: db "time", 0
    ; time_commandhms: db "time -hms", 0
    ; time_command: db "time -hm", 0
    ; time_command: db "time -h", 0
    ; time_command: db "time -hs", 0
    ; time_command: db "time -s", 0
    ; time_command: db "time -ms", 0
    ; time_command: db "time -m", 0
cal_command: db "cal", 0

; komendy testowe
ver2_command: db "ver2", 0
test_command: db "test", 0
bindec_command: db "bindec", 0
mov_ax_cx_command: db "ax=cx", 0 ; nie dziala (narazie)

love1_command: db "love", 0 ; 14 ; Istereg
love2_command: db "LOVE", 0 ; 14 ; Istereg

command: times 512*2 db 0
command_len: equ $ - command - 1

%include "core.asm"