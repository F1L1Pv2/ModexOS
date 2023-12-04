clear_buffer:
    ; input buffer in bx
    ; buffer len in dx
    push dx
    push bx

    .loop:

        cmp dx, 0
        je .exit

        mov byte [bx],  byte 0

        dec dx
        inc bx

        jmp .loop
    .exit:

    pop bx
    pop dx
    ret

read_buffer:
    ; input buffer in bx
    ; buffer len in dx
    push dx
    push bx
    .loop:

        ; capturing character
        mov ah, 0
        int 0x16
        ; capturing character

        ; handling enter
        cmp ah, 28
        je .exit
        ; handling enter

        pop cx
        push cx
        add cx, dx



        ; handling backspace
        cmp al, 8
        je .backward
        ; handling backspace
        
        cmp bx, cx
        jge .loop

        call write_char

        mov [bx], al
        inc bx

        jmp .loop
    .exit:

    pop bx
    pop dx

    ret

    .backward:
        pop cx
        cmp bx, cx
        push cx
        jng .exit_back
        dec bx
        mov byte [bx], 0
        mov al, 8
        call write_char
        mov al, 32
        call write_char
        mov al, 8
        call write_char
        .exit_back:
        jmp .loop


write_buffer:
    push bx
    ; input buffer in bx
    .loop:
        mov al, [bx]

        cmp al, 0
        je .exit

        call write_char
        inc bx

        jmp .loop
    .exit:
    pop bx
    ret

cmp_str:
    ; first string address in bx
    ; second string address in dx

    push bx
    push dx

    .loop:
        mov al, byte [bx]
        push bx
        mov bx, dx
        mov ah, byte [bx]
        pop bx

        cmp ah,al
        jne .exit

        cmp al, 0
        je .exit

        inc bx
        inc dx

        jmp .loop
    .exit:
    

    pop dx
    pop bx

    ret

write_char:
    mov ah, 0x0e
    int 0x10
    ret

cls:
    mov ah, 0
    mov al, 3
    int 0x10
    ret

new_line:
    mov ah, 0x0e
    mov al, 10
    int 0x10
    mov al, 13
    int 0x10
    ret


command: times 512 db 0
command_len: equ $ - command
