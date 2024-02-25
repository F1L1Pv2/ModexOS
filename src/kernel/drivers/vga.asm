update_cursor:
    push eax
    push ebx
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

        mov word [ScreenBuffer+edi*2], ax

        inc edi

        jmp .loop
    .after:
        mov word [cursor], 0
        call update_cursor

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
    call write_char_vga
    call update_cursor

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
        
        call write_char_vga
        inc word [cursor]

        jmp .loop
    .after:
        call update_cursor
        jmp .exit

    .new_line:
        call new_line
        jmp .loop

    .exit:
        pop edx
        pop esi
        pop eax
        ret

write_char_vga:
    push edi

    mov edi, [cursor]
    mov word [ScreenBuffer+edi*2], ax

    pop edi
    ret

write_len: dw 0
cursor: dw 0

vga_history: times (10*80*25)+1 db 0
vga_history_len: equ $ - vga_history - 1