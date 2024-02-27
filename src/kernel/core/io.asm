bits 32

dump_xbytes_little_endian:
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;    ta funkcja wypisuje x byte'ow    ;; 
    ;;   z rejestru esi w little_endian    ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
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
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;    ta funkcja wypisuje x byte'ow    ;; 
    ;;     z rejestru esi w big_endian     ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
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


print_hex:
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;    funkcja print hex (4-bits)       ;;
    ;;            AL to wejsce             ;;
    ;; (funkcja nie updat'uje kursora vga) ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
    push eax
    cmp al, 0xA
    jge .letter
.number:
    add al, '0'
    jmp .after
.letter:

    add al, 'A' - 0xA
.after:
    mov ah, [global_color]

    call write_char
    inc word [cursor]

    pop eax

    ret

print_byte:
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;    funkcja print byte (8-bits)      ;;
    ;;            AL to wejsce             ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
    push eax
    push ebx
    
    mov bl, al

    shr al, 4
    and al, 0b00001111
    call print_hex
    mov al, bl
    and al, 0b00001111
    call print_hex

    pop ebx
    pop eax

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
    call update_cursor
    ret

write_char:
    push edi

    mov edi, dword [cursor]
    mov word [ScreenBuffer+edi*2], ax

    pop edi
    ret

read_buffer:
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;   funkcja read buffer (32-bits)     ;;
    ;;wczytuje z klawiatury do read_content;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
    call read_clear_buffer

    push edx
    push eax
.loop:
    xor edx, edx
    mov dx, [read_cursor]

    cmp dx, 80*25
    jge .after


    call ps2_read_char

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
    cmp al, 0xF9
    je .page_up
    cmp al, 0xF8
    je .page_down
    
    mov [read_content+edx], al
    mov ah, [global_color]
    call write_char
    inc word [cursor]
    inc word [read_cursor]
    
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
    .page_up:
    ; TODO: Make it work
    jmp .after
    .page_down:
    call scroll_down
    jmp .after

    .new_line:
    cmp byte [ps2_shift], 0
    jz .run_command
    jmp .write_new_line

    .run_command:
    call new_line
    jmp .end

    .write_new_line:
    mov byte [read_content+edx], 10
    inc word [read_cursor]
    xor edx, edx
    mov dx, word [cursor]
    mov byte [ScreenBuffer+edx*2], 0xFF
    call new_line
    jmp .after

    jmp .after

    .backspace_newline:
    mov dl, 2
    call read_move_back_while_not_x
    jmp .after_backspace_newline

    .backspace:

    cmp word [read_cursor], 0
    je .after
    cmp word [cursor], 0
    je .after

    dec word [read_cursor]
    dec word [cursor]

    xor edx, edx


    mov dx, word [read_cursor]
    cmp byte [read_content+edx], 10

    je .backspace_newline
    mov ah, [global_color]
    mov al, 32
    call write_char
    .after_backspace_newline:
    
    mov byte [read_content+edx], 0

    jmp .after
    .after:


    call update_cursor
    jmp .loop
.end:
    pop eax
    pop edx
    ret

read_clear_buffer:
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;       ta funkcja wyczyszcza         ;;
    ;;            read_content             ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
    push eax

    mov word [read_cursor], 0

    mov eax, read_content_len
.loop:
    dec eax
    mov byte [read_content+eax], 0

    test eax, eax
    jnz .loop

    pop eax
    ret

read_move_back_while_not_x:
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; ta funkcja porusza kursor do tyłu   ;;
    ;; tak długo az nie znajdzie znaku     ;;
    ;; który jest równy znakowi podanemu   ;;
    ;;         w rejestrze edx             ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
    push eax

    xor eax, eax
.loop:
    mov ax, word [cursor]
    cmp byte [ScreenBuffer+eax*2], dl
    je .after
    dec word [cursor]
    jmp .loop
.after:
    mov byte [ScreenBuffer+eax*2], 32
    pop eax
    ret

read_content: times 80*25 db 0
read_content_len equ ($-read_content)
db 0 ; padding
read_cursor:              dw 0