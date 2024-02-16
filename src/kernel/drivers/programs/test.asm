test:

    ; call file_sys
    ; call new_line

    ; mov bx, test_tag
    ; call write_buffer

    ; mov bx, tests_command
    ; mov dx, tests_command_len
    ; call clear_buffer
    ; call read_buffer

    ; cmp byte [bx], 0
    ; jz .exit

    ; call decimal_binary
    ; call new_line

    ; call file_sys
    ; call new_line
    ; jmp test
.exit
    ret

number_input: db "9", 0

test_tag: db "test> ", 0
tests_command: times 16 db 0
tests_command_len: equ $ - tests_command - 1







    ; ; handling other character
    ; push ax
    ; cmp ah, 0x48
    ; jz .restore_cmd
    ; cmp ah, 0x4D
    ; jz .restore_cmd
    ; cmp ah, 0x4B
    ; jz .restore_cmd
    ; cmp ah, 0x50
    ; jz .restore_cmd

    ; cmp al, 0x0a
    ; jnz .ctrl_j
    ; cmp ah, 0x24
    ; jz .restore_cmd
    ; .ctrl_j:

    ; cmp al, 0x07
    ; jnz .ctrl_g
    ; cmp ah, 0x22
    ; jz .restore_cmd
    ; .ctrl_g:

    ; pop ax
    ; ; handling other character