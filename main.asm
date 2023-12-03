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

    .nothing:
    ret

say:

    mov bx, command
    mov dx, command_len
    call clear_buffer
    call read_buffer

    call new_line

    ret



%define VERSION "BIOS-HTC - Test 1_00",10,13

welcome_msg: db VERSION,"Corporation (C) 2020-2023",10,13,10,13,"Type help a for a list of commands.",10,13,10,13,0

unknown_command_msg: db "The command does not exist. Type help a for a list of commands", 10,13,0

help_command_msg: db "1. help - Help.",10,13,"4. cls - Clear text.",10,13,"7. ver - System vesrsion.",10,13,"8. say - Comment.",10,13,"8. ping - pong!.",10,13,0
version_command_msg: db VERSION,"Corporation (C) 2020",10,13,0
ping_command_msg: db "pong!",0

command_msg: db "> ",0
cls_command: db "cls", 0
help_command: db "help", 0
ver_command: db "ver", 0
say_command: db "say", 0
ping_command: db "ping", 0