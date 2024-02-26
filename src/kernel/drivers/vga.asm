bits 32

update_cursor:
    push eax
    push ebx
    push edx
    mov bx, word [cursor]

    mov dx, 0x3D4
    mov al, 0xF
    out dx, al

    mov al, bl
    mov dx, 0x3D5
    out dx, al

    mov dx, 0x3D4
    mov al, 0xE
    out dx, al

    mov dx, 0x3D5
    mov al, bh
    out dx, al

    pop edx
    pop ebx
    pop eax
    ret

clear_screen:
    ; input color in ah
    push edi
    mov edi, 0
    mov al, 32
    .loop:
        cmp edi, 80*25
        jge .after

        mov word [virtual_terminal+edi*2], ax

        inc edi

        jmp .loop
    .after:
        mov word [cursor], 0
        pop edi
        ret

new_line:
    push eax
    push ecx
    push edx

    mov ax, [cursor]
    xor dx, dx
    mov cx, 80
    div cx
    
    sub word [cursor], dx
    add word [cursor], 80

    pop edx
    pop ecx
    pop eax
    ret

backspace:
    push eax
    push ebx

    mov bx, word [write_len]
    test bx, bx
    jz .exit

    dec word [cursor]
    mov ah, 0x0a
    mov al, ' '
    call write_char

    dec word [write_len]
    .exit:
        pop ebx
        pop eax
        ret

write_buffer:
    ; input color in ah
    ; input buffer in esi

    push eax
    push esi
    push edx

    cld
    .loop:
        lodsb
        or al, al
        jz .after

        cmp al, 10
        je .new_line
        
        call write_char
        inc word [cursor]

        jmp .loop
    .after:
        jmp .exit

    .new_line:
        call new_line
        jmp .loop

    .exit:
        pop edx
        pop esi
        pop eax
        ret

write_char:
    push edi

    mov edi, dword [cursor]
    mov word [virtual_terminal+edi*2], ax

    pop edi
    ret


update_screen:
    push eax
    mov esi, 0
.loop:
    cmp esi, 80*25*2
    jge .after
    mov al, byte [virtual_terminal+esi]
    cmp al, byte [ScreenBuffer+esi]
    je .end_loop
    mov byte [ScreenBuffer+esi], al
.end_loop:
    inc esi
    jmp .loop
.after:
    call update_cursor
    pop eax
    ret


write_len: dw 0
cursor: dd 0
times 16 db 0xFE
virtual_terminal: times(80*25) dw 0

terminal_offset:              dw 0
terminal_content: times 80*25 db 0
terminal_cursor:              dw 0

vga_history: times (10*80*25)+1 db 0
vga_history_len equ $ - vga_history - 1