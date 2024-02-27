memmory_dump:
    [bits 32]
    mov esi, memmory_table
.loop:
    cmp esi, memmory_table_end
    jge .after

    mov edx, 8
    call dump_xbytes_big_endian

    mov ah, [global_color]
    mov al, 32
    call write_char
    inc word [cursor]

    call dump_xbytes_big_endian
    call write_char
    inc word [cursor]

    mov edx, 4
    call dump_xbytes_big_endian
    call write_char
    inc word [cursor]

    call dump_xbytes_big_endian
    call new_line

    jmp .loop


.after:

    ret

calculate_ram:
    mov esi, memmory_table
.loop:
    cmp esi, memmory_table_end
    jge .after

    add esi, 24

    cmp dword [esi-4-4], 1
    jne .loop

    mov eax, dword [esi-4-4-8]
    add dword [avaliable_ram], eax
    jmp .loop
.after:
    ret

avaliable_ram: dd 0