bits 32

terminal_handle_key:
    push edx

    xor edx, edx
    mov dx, [terminal_cursor]

    cmp dx, 80*25
    jge .after


    call read_char

    cmp al, 0xFA
    je .left_arrow
    cmp al, 0xFC
    je .right_arrow
    cmp al, 0xFB
    je .after
    cmp al, 0xFD
    je .after
    
    cmp al, 8
    je .backspace
    cmp al, 10
    je .new_line
    cmp al, 0xFE
    je .after
    cmp al, 0xFF
    je .after
    
    mov [terminal_content+edx], al
    mov ah, [global_color]
    call write_char
    inc word [cursor]
    
    inc word [terminal_cursor]
    jmp .after

    .left_arrow:
    ; TODO: Make them work
    ; cmp dx, 0
    ; je .after
    ; dec word [terminal_cursor]
    jmp .after
    .right_arrow:
    ; TODO: Make them work
    ; cmp dx, 80*25
    ; jge .after
    ; inc word [terminal_cursor]
    jmp .after

    .new_line:
    cmp byte [shift], 0
    jz .run_command
    jmp .write_new_line




    .run_command:
    ; TODO: end handling keys and run command
    jmp .after

    .write_new_line:
    mov byte [terminal_content+edx], 10
    inc word [terminal_cursor]
    xor edx, edx
    mov dx, word [cursor]
    mov byte [virtual_terminal+edx*2], 0xFF
    call new_line
    jmp .after

    jmp .after

    .backspace_newline:
    call move_back_while_space
    jmp .after_backspace_newline

    .backspace:

    cmp word [terminal_cursor], 0
    je .after
    cmp word [cursor], 0
    je .after

    dec word [terminal_cursor]
    dec word [cursor]

    xor edx, edx


    mov dx, word [terminal_cursor]
    cmp byte [terminal_content+edx], 10

    je .backspace_newline
    mov ah, [global_color]
    mov al, 32
    call write_char
    .after_backspace_newline:
    
    mov byte [terminal_content+edx], 0






    jmp .after
    .after:


    pop edx
    ret

move_back_while_space:
    push eax

    xor eax, eax
.loop:
    mov ax, word [cursor]
    cmp byte [virtual_terminal+eax*2], 0xFF
    je .after
    dec word [cursor]
    jmp .loop
.after:
    mov byte [virtual_terminal+eax*2], 32
    pop eax
    ret

read_char:
    push edi
    call wait_set_output
    in al, 0x60
    cmp al, 0xE0
    je .special_key_handle
    
    cmp al, 0x3A
    je .toggle_caps_lock
    cmp al, 0x2A
    je .turn_on_shift
    cmp al, 0xAA
    je .turn_off_shift
    
    mov edi, eax
    and edi, 0xFF

    mov al, byte[capslock]

    cmp byte[shift], al
    je .normal_key
    jmp .alt_key


    .normal_key:
    mov al, [edi+code_key_table-1]
    jmp .after

    .alt_key:
    mov al, [edi+shift_code_key_table-1]
    jmp .after


    .special_key_handle:

    call wait_set_output

    in al, 0x60

    ; TODO: Change into table not an hardcoded if else if else
    cmp al, 0x4B
    je .left_arrow
    cmp al, 0x4D
    je .right_arrow
    cmp al, 0x48
    je .up_arrow
    cmp al, 0x50
    je .down_arrow

    mov al, 0xFF
    jmp .after
    .toggle_caps_lock:
    mov al, 1
    sub al, byte [capslock]
    mov byte [capslock], al
    mov al, 0xFF
    jmp .after
    .turn_on_shift:
    mov byte [shift], 1
    mov al, 0xFF
    jmp .after
    .turn_off_shift:
    mov byte [shift], 0
    mov al, 0xFF
    jmp .after
    .left_arrow:
    mov al, 0xFE - 4 ; 0xFA
    jmp .after
    .right_arrow:
    mov al, 0xFF - 3 ; 0xFB
    jmp .after
    .up_arrow:
    mov al, 0xFF - 2 ; 0xFC
    jmp .after
    .down_arrow:
    mov al, 0xFF - 1 ; 0xFD
    jmp .after
    .after:
    pop edi
    ret

wait_clear_input:
    push ecx
    mov cl, 3
    .loop:
    in al, 0x64
    and al, 0b00000010
    cmp al, 0
    jne .loop
    pop ecx
    ret

wait_set_input:
    push ecx
    mov cl, 3
    .loop:
    in al, 0x64
    and al, 0b00000010
    cmp al, 0
    je .loop
    pop ecx
    ret

wait_clear_output:
    push ecx
    mov cl, 3
    .loop:
    in al, 0x64
    and al, 0b00000001
    cmp al, 0
    jne .loop
    pop ecx
    ret

wait_set_output:
    push ecx
    mov cl, 3
    .loop:
    in al, 0x64
    and al, 0b00000001
    cmp al, 0
    je .loop
    pop ecx
    ret

shift:    db 0
capslock: db 0

; code key table
code_key_table: 
               db 27,'1','2','3','4','5','6','7','8','9','0','-','=',8,0xfe,'q','w','e','r','t','y','u','i','o','p','[',']',10,0xfe,'a','s','d','f','g','h','j','k','l'
               db ';',39,'`',0xfe,92,'z','x','c','v','b','n','m',',','.','/',0xfe
               db '*',0xfe,' ',0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,'7','8','9','-','4','5','6','+','1','2','3','0','.',0xff,0xff,0xff,0xfe,0xfe,0xff,0xff,0xff,0xff
    times 4*20 db 0xfe
               db 0xff,0xff,0xff,0xfe,0xfe,0xff,0xff,0xff
    times 4*41 db 0xff
               db 0

shift_code_key_table: 
               db 27,'!','@','#','$','%','&','&','*','(',')','_','+',8,0xfe,'Q','W','E','R','T','Y','U','I','O','P','{','}',10,0xfe,'A','S','D','F','G','H','J','K','L'
               db ':',34,'~',0xfe,'|','Z','X','C','V','B','N','M','<','>','?',0xfe
               db '*',0xfe,' ',0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,'7','8','9','-','4','5','6','+','1','2','3','0','.',0xff,0xff,0xff,0xfe,0xfe,0xff,0xff,0xff,0xff
    times 4*20 db 0xfe
               db 0xff,0xff,0xff,0xfe,0xfe,0xff,0xff,0xff
    times 4*41 db 0xff
               db 0