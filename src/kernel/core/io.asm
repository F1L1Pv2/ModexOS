use32

; Screen buffer address!
ScreenBuffer  equ 0xB8000 + 0xC0000000
read_content_len equ 80*25

round_up:
    cmp edx, 0
    jnz .round_up
    jmp .after
.round_up:
    inc eax
.after:
    ret

dump_xbits:
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;    ta funkcja wypisuje x byte'ow    ;; 
    ;;   z rejestru esi w little_endian    ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
    push edx
    push eax
    push ecx

    mov eax, edx
    xor edx, edx
    mov ecx, 8
    div ecx
    call round_up
    mov edx, eax
.loop:

    xor eax, eax
    mov al, byte [esi]

    call binary_8_pure
    mov ah, byte [global_color]
    mov al, 32
    call write_char
    inc word [cursor]

    inc esi

    dec edx
    test edx, edx
    jnz .loop

    pop ecx
    pop eax
    pop edx
    ret

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
    call space

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
    call space

    dec esi

    dec edx
    test edx, edx
    jnz .loop

    pop esi
    pop eax
    pop edx
    ret

bindec_wrote: dd 0

s_binary_decimal:
    push eax

    cmp eax, 0
    jnl .after

    dec eax
    not eax

    push eax
    mov ah, [global_color]
    mov al, '-'
    call write_char
    inc word [cursor]
    pop eax

.after:
    call binary_decimal

    pop eax

    ret

binary_decimal:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja binary to decimal (32-bits) ;;
    ;;          EAX to wejsce              ;;
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
    mov dword [bindec_wrote], ebx
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
    and al, 00001111b
    call print_hex
    mov al, bl
    and al, 00001111b
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

    cmp word [cursor], 80*25
    jnge .after
    call scroll_down
.after:

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
    mov dl, 0xFF
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
    cmp word [cursor], 0
    jle .after
    mov ax, word [cursor]
    cmp byte [ScreenBuffer+eax*2], dl
    je .after
    dec word [cursor]
    jmp .loop
.after:
    mov byte [ScreenBuffer+eax*2], 32
    pop eax
    ret

space:
    push eax
    
    mov ah, [global_color]
    mov al, ' '
    call write_char
    inc word [cursor]

    pop eax
    
    ret

update_cursor:
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;  funkcja służąca do zaktualizowania ;;
    ;;     pozycji kursora na ekranie      ;;
    ;;          nowa pozycja jest          ;;
    ;;        brana z word [cursor]        ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
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

        mov word [ScreenBuffer+edi*2], ax

        inc edi

        jmp .loop
    .after:
        mov word [cursor], 0
        pop edi
        ret

new_line:
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;  funkcja służąca do zrobienia nowej ;;
    ;;      lini na ekranie jeżeli jest    ;;
    ;;         wymagane ekran będzie       ;;
    ;;            scrolować w dół          ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
    push eax
    push ecx
    push edx

    mov ax, [cursor]
    xor dx, dx
    mov cx, 80
    div cx
    
    sub word [cursor], dx
    add word [cursor], 80

    cmp word [cursor], 80*25
    jge .scroll_down
    jmp .after

.scroll_down:
    call scroll_down
.after:
    pop edx
    pop ecx
    pop eax
    ret

scroll_down:
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;  funkcja do scrolownia 1 raz w dół  ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
    push eax
    push edx

    mov dx, 80
    cmp dx, word [cursor]
    jg .exit

    xor edx, edx
.loop:
    cmp edx, 80*24
    jge .blank_loop
    mov ax, word [ScreenBuffer+edx*2+(80*2)]
    mov word [ScreenBuffer+edx*2], ax

    inc edx
    jmp .loop
.blank_loop:
    cmp edx, 80*25
    jge .after
    mov ah, [global_color]
    mov al, ' '
    mov word [ScreenBuffer+edx*2], ax

    inc edx
    jmp .blank_loop
.after:
    sub word [cursor], 80
.exit:
    pop edx
    pop eax
    ret

scroll_up:
    ret

binary_8_pure:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja binary to decimal (8-bits)  ;;
    ;;           AL to wejsce              ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    push eax
    push ebx

    mov bl, 128
    mov ah, 8
.loop:
    test ah, ah
    jz .exit

    mov bh, al
    and bh, bl
    shr bl, 1
    dec ah

    test bh, bh
    jnz .set_bit

    push eax
    mov ah, byte [global_color]
    mov al, '0'
    call write_char
    inc word [cursor]
    pop eax

    jmp .loop

.set_bit:
    push eax
    mov ah, byte [global_color]
    mov al, '1'
    call write_char
    inc word [cursor]
    pop eax

    jmp .loop

.exit:
    pop ebx
    pop eax
    ret

fill_bits:
    ; al is input / output

    cmp al, 0
    jz .after

    cmp al, 8
    jge .overflow

    push ebx

    xor ebx, ebx
    mov bl, al
    xor al, al

    sub bl, 8
    not bl
    inc bl
.loop:  
    shl al, 1
    inc al

    dec bl
    jnz .loop

    not al

    pop ebx
.after:
    ret
.overflow:
    mov al, -1
    ret

binary_8:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja binary to decimal (8-bits)  ;;
    ;;           AL to wejsce              ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    push eax
    push ebx

    push eax
    mov ah, byte [global_color]
    mov al, '0'
    call write_char
    inc word [cursor]

    mov ah, byte [global_color]
    mov al, 'b'
    call write_char
    inc word [cursor]
    pop eax

    call binary_8_pure

    pop ebx
    pop eax
    ret


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


binary_32:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja print binary (32-bits) ;;
    ;;         EAX to wejsce          ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    push eax
    push ebx

    push eax
    mov ah, [global_color]
    mov al, '0'
    call write_char
    inc word [cursor]
    mov al, 'b'
    call write_char
    inc word [cursor]
    pop eax

    mov ebx, 10000000000000000000000000000000b
.loop:
    test ebx, ebx
    jz .exit

    push eax
    and eax, ebx
    shr ebx, 1

    test eax, eax
    jnz .true

    mov ah, [global_color]
    mov al, '0'
    call write_char
    inc word [cursor]
    pop eax

    jmp .loop

.true:
    mov ah, [global_color]
    mov al, '1'
    call write_char
    inc word [cursor]
    pop eax

    jmp .loop

.exit:
    pop ebx
    pop eax
    ret


print_bcd:
    push eax

    push eax
    shr al, 4
    call binary_decimal
    pop eax

    and al, 1111b
    call binary_decimal

    pop eax
    ret

error: 
    push eax
    push ebx

    ; call new_line
    mov ah, [global_color]
    mov esi, .msg
    call write_buffer
    call new_line

    inc ebx
    test ebx, ebx

    pop ebx
    pop eax
    ret
.msg: db "Error!", 0

if_ascii_number:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja sprawdzania znakow innych niz cyfra w tablicy ;;
    ;;       ESI to informacja o poczatkowym adresie         ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push esi
    push ebx
    push edx

    mov ebx, esi

    xor esi, esi

    mov dl, byte [ebx] 
    cmp dl, 45
    jne .loop

    inc ebx

.loop:
    mov dl, byte [ebx+esi]
    inc esi

    test dl, dl
    jz .valid

    cmp dl, 48
    jl .exit ; Invalid number
    cmp dl, 57
    jg .exit ; Invalid number

    jmp .loop

.valid:
    xor esi, esi

.exit:
    ; cmp dl, 45
    ; je .valid ; valid number

    test esi, esi

    pop edx
    pop ebx
    pop esi
    ret

s_decimal_binary:
    push esi
    push edx

    mov dl, byte [esi]

    cmp dl, 45
    jne .after

    inc esi

    call decimal_binary

    dec eax
    not eax

    jmp .exit
.after:

    call decimal_binary

.exit:
    pop edx
    pop esi
    ret

decimal_binary:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;   funkcja decimal to binary (32-bits)   ;;
    ;; ESI to informacja o poczatkowym adresie ;;
    ;;              EAX to output              ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    call flip_bytes_table

    push edx
    push ecx
    push ebx

    xor edx, edx
    xor ecx, ecx
    xor ebx, ebx

.loop:
    mov dl, byte [esi+ebx]
    push edx
    inc ebx

    test dl, dl
    jnz .loop

    pop eax
    dec ebx

.loop2:
    dec ebx
    mov eax, 10
    call math_power
    pop edx

    sub edx, 48
    mul edx

    add ecx, eax

    test ebx, ebx
    jnz .loop2

    mov eax, ecx

    pop ebx
    pop ecx
    pop edx

    call flip_bytes_table

    ret

flip_bytes_table:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;       funkcja ktora obraca bytes w tablicy        ;;
    ;;      ESI to informacja o poczatkowym adresie      ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push esi
    push edx
    push ebx

    mov ebx, esi

    mov esi, 0
    push esi ; 0 ktore mowi gdzie konczy sie bytes table

.loop:
    mov dl, byte [ebx+esi]
    push edx
    inc esi

    test dl, dl
    jnz .loop

    pop esi ; usuwanie 0 z poczatku tablicy
    xor esi, esi

.loop2:
    pop edx
    mov byte [ebx+esi], dl
    inc esi

    test dl, dl
    jnz .loop2

    pop ebx
    pop edx
    pop esi

    ret

cursor:                              dd 0

read_content: times read_content_len db 0
                                     db 0 ; padding
read_cursor:                         dw 0