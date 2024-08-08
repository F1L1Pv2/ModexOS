global_time:
    push eax
    push ebx

    mov ebx, eax
    xor eax, eax

    mov al, 128

    call .date_d

    push eax
    mov eax, ebx
    mov al, '.'
    call write_char
    inc word [cursor]
    pop eax

    call .date_m

    push eax
    mov eax, ebx
    mov al, '.'
    call write_char
    inc word [cursor]
    pop eax

    call .date_y

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

    call .time_h

    push eax
    mov eax, ebx
    mov al, ':'
    call write_char
    inc word [cursor]
    pop eax

    call .time_m

    push eax
    mov eax, ebx
    mov al, ':'
    call write_char
    inc word [cursor]
    pop eax

    call .time_s

    pop ebx
    pop eax

    ret

.time_s:
    push eax
    or al, 0x00
    out 0x70, al
    in al, 0x71
    call print_bcd
    pop eax

    ret
    
.time_m:
    push eax
    or al, 0x02
    out 0x70, al
    in al, 0x71
    call print_bcd
    pop eax

    ret

.time_h:
    push eax
    or al, 0x04
    out 0x70, al
    in al, 0x71
    call print_bcd
    pop eax

    ret

.date_d:
    push eax
    or al, 0x07
    out 0x70, al
    in al, 0x71
    call print_bcd
    pop eax

    ret

.date_m:
    push eax
    or al, 0x08
    out 0x70, al
    in al, 0x71
    call print_bcd
    pop eax

    ret

.date_y:
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


args:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;                     (32-bits)  ;;
    ;;    ESI to [input] / [output]   ;;
    ;;       EAX to liczba args       ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push ebx
    push ecx
    push edx

    xor eax, eax
    xor ebx, ebx

    mov dl, byte [esi+ebx]

    cmp dl, 34
    jne .is_not_34
    mov ecx, 0
    jmp .loop
.is_not_34:
    mov ecx, 1

.loop:
    test dl, dl
    jz .after_loop

    inc ebx
    mov dl, byte [esi+ebx]


    cmp dl, 34
    jne .is_false

    cmp ecx, 0
    jne .op1
    inc ecx
    jmp .op2
.op1:
    dec ecx
.op2:
.is_false: 


    cmp dl, ' '
    jne .is_false2

    test ecx, ecx
    jz .is_false2

    inc eax
    mov byte [esi+ebx], 0
.is_false2:

    jmp .loop
.after_loop:

    pop edx
    pop ecx
    pop ebx

    ret
.return: dw 0
.ebx:    dw 0
.ecx:    dw 0
.edx:    dw 0



debug:
    push eax
    push esi
    
    mov ah, [global_color]
    mov esi, .msg
    call write_buffer
    
    pop esi
    pop eax

    ret
.msg: db "Debug!",10,0

debug1:
    push eax
    push esi
    
    mov ah, [global_color]
    mov esi, .msg
    call write_buffer
    
    pop esi
    pop eax

    ret
.msg: db "Debug1!",10,0

debug2:
    push eax
    push esi
    
    mov ah, [global_color]
    mov esi, .msg
    call write_buffer
    
    pop esi
    pop eax

    ret
.msg: db "Debug2!",10,0