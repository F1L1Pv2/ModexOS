call cls

mov bx, welcome_msg
call write_buffer

main:
    
    mov bx, command_msg
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

    .nothing:
    ret

say:

    mov bx, command
    mov dx, command_len

    call new_line

    call clear_buffer
    call read_buffer

    call new_line
    call new_line

    ret

%define DATA "2020-2023r."
%define NEW_LINE 10,13
%define VERSION "System HTC build-04122023-2205 16-bits",NEW_LINE

welcome_msg: db "Made by: F1L1P (modified by Rilax)",NEW_LINE,NEW_LINE,VERSION,"Corporation (C) ",DATA,NEW_LINE,NEW_LINE,"Type help a for a list of commands.",NEW_LINE,NEW_LINE, 0

unknown_command_msg: db "The command does not exist. Type help a for a list of commands", NEW_LINE, NEW_LINE, 0

help_command_msg: 
db NEW_LINE,"1. help - Help.",NEW_LINE,"2. cls - Clear text.",NEW_LINE,"3. ver - System vesrsion.",NEW_LINE,"4. say - Comment.",NEW_LINE,"5. ping - pong!",NEW_LINE,"6. motd - Welcome text!",NEW_LINE,NEW_LINE, 0

version_command_msg: db VERSION,"Corporation (C) ",DATA,NEW_LINE,NEW_LINE,0
ping_command_msg: db "pong!",NEW_LINE, 0

command_msg: db "> ", 0
cls_command: db "cls", 0
help_command: db "help", 0
ver_command: db "ver", 0
say_command: db "say", 0
ping_command: db "ping", 0
motd_command: db "motd", 0

%include "core.asm"