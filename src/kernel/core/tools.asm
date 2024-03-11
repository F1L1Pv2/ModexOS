global_time:
    push eax
    push ebx

    mov ebx, eax
    xor eax, eax

    mov al, 128

    call date_d

    push eax
    mov eax, ebx
    mov al, '.'
    call write_char
    inc word [cursor]
    pop eax

    call date_m

    push eax
    mov eax, ebx
    mov al, '.'
    call write_char
    inc word [cursor]
    pop eax

    call date_y

    push eax
    mov eax, ebx
    mov al, ' '
    call write_char
    inc word [cursor]
    mov al, '/'
    call write_char
    inc word [cursor]
    mov al, ' '
    call write_char
    inc word [cursor]
    pop eax

    call time_h

    push eax
    mov eax, ebx
    mov al, ':'
    call write_char
    inc word [cursor]
    pop eax

    call time_m

    push eax
    mov eax, ebx
    mov al, ':'
    call write_char
    inc word [cursor]
    pop eax

    call time_s

    pop ebx
    pop eax
    ret

time_s:
    push eax
    or al, 0x00
    out 0x70, al
    in al, 0x71
    call print_bcd
    pop eax
    ret
    
time_m:
    push eax
    or al, 0x02
    out 0x70, al
    in al, 0x71
    call print_bcd
    pop eax
    ret

time_h:
    push eax
    or al, 0x04
    out 0x70, al
    in al, 0x71
    call print_bcd
    pop eax
    ret

date_d:
    push eax
    or al, 0x07
    out 0x70, al
    in al, 0x71
    call print_bcd
    pop eax
    ret

date_m:
    push eax
    or al, 0x08
    out 0x70, al
    in al, 0x71
    call print_bcd
    pop eax
    ret

date_y:
    push eax
    or al, 0x32
    out 0x70, al
    in al, 0x71
    call print_bcd
    pop eax

    push eax
    or al, 0x09
    out 0x70, al
    in al, 0x71
    call print_bcd
    pop eax
    ret