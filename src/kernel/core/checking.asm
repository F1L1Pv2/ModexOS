cmp_str:
    ; first string address in bx
    ; second string address in dx
    push eax
    push esi
    push edi

.loop:
    mov al, byte [esi]
    mov ah, byte [edi]

    cmp ah, al
    jne .exit

    cmp al, 0
    je .exit

    inc esi
    inc edi

    jmp .loop
.exit:

    pop edi
    pop esi
    pop eax
    ret