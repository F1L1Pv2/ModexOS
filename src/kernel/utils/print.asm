dump_xbytes_little_endian:
    [bits 32]
    push edx
    push eax
.loop:

    xor eax, eax
    mov al, byte [esi]

    call print_byte

    inc esi

    dec edx
    test edx, edx
    jnz .loop

    pop eax
    pop edx
    ret

dump_xbytes_big_endian:
    [bits 32]
    push edx
    push eax

    add esi, edx
    push esi
    dec esi
.loop:

    xor eax, eax
    mov al, byte [esi]

    call print_byte

    dec esi

    dec edx
    test edx, edx
    jnz .loop

    pop esi
    pop eax
    pop edx
    ret