binary_decimal:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja binary to decimal (16-bits) ;;
    ;;           AX to wejsce              ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push edx
    push ecx
    push ebx
    push eax

    xor ebx, ebx

.loop:
    xor edx, edx
    mov ecx, 10
    div ecx
    mov ecx, eax

    mov al, dl
    add al, 48
    push eax

    mov eax, ecx

    inc ebx

    test ecx, ecx
    jnz .loop

.flip:
    pop eax
    mov ah, [global_color]
    call write_char
    inc word [cursor]

    dec ebx
    jnz .flip

    pop eax
    pop ebx
    pop ecx
    pop edx

    call update_cursor

    ret

binary_hexadecimal:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja binary to decimal (16-bits) ;;
    ;;           AX to wejsce              ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push edx
    push ecx
    push ebx
    push eax

    

    xor ebx, ebx

.loop:
    xor edx, edx
    mov ecx, 16
    div ecx
    mov ecx, eax

    mov al, dl
    cmp al, 10
    jge .letter
.number:
    add al, '0'
    jmp .after
.letter:
    add al, 'A' - 10
.after:
    push eax

    mov eax, ecx

    inc ebx

    test ecx, ecx
    jnz .loop

    mov ah, [global_color]
    mov al, '0'
    call write_char
    inc word [cursor]
    mov al, 'x'
    call write_char
    inc word [cursor]

.flip:
    pop eax
    mov ah, [global_color]
    call write_char
    inc word [cursor]

    dec ebx
    jnz .flip

    pop eax
    pop ebx
    pop ecx
    pop edx

    call update_cursor

    ret