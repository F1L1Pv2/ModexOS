use32
ScreenBuffer  equ 0xB8000

; dump_xbytes_little_endian:
;     ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     ;;    ta funkcja wypisuje x byte'ow    ;; 
;     ;;   z rejestru esi w little_endian    ;;
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
;     push edx
;     push eax
; .loop:

;     xor eax, eax
;     mov al, byte [esi]

;     call print_byte

;     inc esi

;     dec edx
;     test edx, edx
;     jnz .loop

;     pop eax
;     pop edx
;     ret

; dump_xbytes_big_endian:
;     ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     ;;    ta funkcja wypisuje x byte'ow    ;; 
;     ;;     z rejestru esi w big_endian     ;;
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
;     push edx
;     push eax

;     add esi, edx
;     push esi
;     dec esi
; .loop:

;     xor eax, eax
;     mov al, byte [esi]

;     call print_byte

;     dec esi

;     dec edx
;     test edx, edx
;     jnz .loop

;     pop esi
;     pop eax
;     pop edx
;     ret

; bindec_wrote: dd 0

; binary_decimal:
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     ;; funkcja binary to decimal (16-bits) ;;
;     ;;           AX to wejsce              ;;
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     push edx
;     push ecx
;     push ebx
;     push eax

;     xor ebx, ebx

; .loop:
;     xor edx, edx
;     mov ecx, 10
;     div ecx
;     mov ecx, eax

;     mov al, dl
;     add al, 48
;     push eax

;     mov eax, ecx

;     inc ebx

;     test ecx, ecx
;     jnz .loop
;     mov dword [bindec_wrote], ebx
; .flip:
;     pop eax
;     mov ah, GLOBAL_COLOR
;     call write_char
;     inc word [cursor]

;     dec ebx
;     jnz .flip

;     pop eax
;     pop ebx
;     pop ecx
;     pop edx

;     call update_cursor
;     ret


; print_hex:
;     ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     ;;    funkcja print hex (4-bits)       ;;
;     ;;            AL to wejsce             ;;
;     ;; (funkcja nie updat'uje kursora vga) ;;
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
;     push eax
;     cmp al, 0xA
;     jge .letter
; .number:
;     add al, '0'
;     jmp .after
; .letter:

;     add al, 'A' - 0xA
; .after:
;     mov ah, GLOBAL_COLOR

;     call write_char
;     inc word [cursor]

;     pop eax

;     ret

; print_byte:
;     ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     ;;    funkcja print byte (8-bits)      ;;
;     ;;            AL to wejsce             ;;
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
;     push eax
;     push ebx
    
;     mov bl, al

;     shr al, 4
;     and al, 0b00001111
;     call print_hex
;     mov al, bl
;     and al, 0b00001111
;     call print_hex

;     pop ebx
;     pop eax

;     call update_cursor

;     ret

; binary_hexadecimal:
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     ;; funkcja binary to decimal (16-bits) ;;
;     ;;           AX to wejsce              ;;
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;     push edx
;     push ecx
;     push ebx
;     push eax

;     xor ebx, ebx

;     .loop:
;         xor edx, edx
;         mov ecx, 16
;         div ecx
;         mov ecx, eax

;         mov al, dl
;         cmp al, 10
;         jge .letter
;     .number:
;         add al, '0'
;         jmp .after
;     .letter:
;         add al, 'A' - 10
;     .after:
;         push eax

;         mov eax, ecx

;         inc ebx

;         test ecx, ecx
;         jnz .loop

;         mov ah, GLOBAL_COLOR
;         mov al, '0'
;         call write_char
;         inc word [cursor]
;         mov al, 'x'
;         call write_char
;         inc word [cursor]

;     .flip:
;         pop eax
;         mov ah, GLOBAL_COLOR
;         call write_char
;         inc word [cursor]

;         dec ebx
;         jnz .flip

;         pop eax
;         pop ebx
;         pop ecx
;         pop edx

;         call update_cursor
;         ret

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
    mov ah, GLOBAL_COLOR
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

; write_sized_buffer:
;     ; esi buffer
;     ; edx len
;     push eax
;     push edx

;     cld
;     mov ah, GLOBAL_COLOR
; .loop:
;     cmp edx, 0
;     je .after

;     lodsb
;     cmp al, 10
;     je .new_line

;     call write_char
;     inc word [cursor]

;     dec edx
;     jmp .loop
; .new_line:
;     call new_line
;     dec edx
;     jmp .loop
; .after:
;     call update_cursor

;     pop edx
;     pop eax
;     ret

write_buffer:
    ;color in ah
    push esi
    cld
.loop:
    lodsb
    cmp al, 0
    je .after
    cmp al, 10
    je .new_line

    call write_char
    inc word [cursor]

    jmp .loop
.new_line:
    call new_line
    jmp .loop

.after:
    call update_cursor
    pop esi
    ret
    
write_char:
    push ebx

    xor ebx, ebx
    mov bx, word [cursor]
    cmp bx, 80*25
    jl .after
    call scroll_down
    mov bx, word [cursor]
.after:
    mov word [ScreenBuffer+ebx*2], ax
    pop ebx
    ret

get_initial_cursor:
    push edx
    push eax
    
    mov edx, 0x3D4
    mov al, 0x0E
    out dx, al
    inc edx
    in al, dx
    mov ah, al
    dec edx
    mov al, 0x0F
    out dx, al
    inc edx
    in al, dx

    mov word [cursor], ax

    pop eax
    pop edx
    ret

update_cursor:
    push ebx
    push eax
    push edx

    mov bx, word [cursor]

    mov edx, 0x3D4
    mov al, 0x0F
    out dx, al
    mov al, bl
    inc edx
    out dx, al

    dec edx
    mov al, 0x0E
    out dx, al
    mov al, bh
    inc edx
    out dx, al

    pop edx
    pop ebx
    pop ebx
    ret

cursor: dw 0

; true_msg: db "true", 0
; false_msg: db "false", 0

; write_bool:
;     jz .false
; .true:
;     mov esi, true_msg
;     jmp .after
; .false:
;     mov esi, false_msg
; .after:
;     mov ah, GLOBAL_COLOR
;     call write_buffer
;     ret

; binary_8:
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     ;; funkcja binary to decimal (8-bits)  ;;
;     ;;           AL to wejsce              ;;
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     push eax
;     push ebx

;     push eax
;     mov ah, GLOBAL_COLOR
;     mov al, '0'
;     call write_char
;     inc word [cursor]

;     mov ah, GLOBAL_COLOR
;     mov al, 'b'
;     call write_char
;     inc word [cursor]
;     pop eax

;     mov bl, 128
;     mov ah, 8
; .loop:
;     test ah, ah
;     jz .exit

;     mov bh, al
;     and bh, bl
;     shr bl, 1
;     dec ah

;     test bh, bh
;     jnz .set_bit

;     push eax
;     mov ah, GLOBAL_COLOR
;     mov al, '0'
;     call write_char
;     inc word [cursor]
;     pop eax

;     jmp .loop

; .set_bit:
;     push eax
;     mov ah, GLOBAL_COLOR
;     mov al, '1'
;     call write_char
;     inc word [cursor]
;     pop eax

;     jmp .loop

; .exit:
;     pop ebx
;     pop eax
;     ret

; binary_16:
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     ;; funkcja binary to decimal (16-bits) ;;
;     ;;           AX to wejsce              ;;
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     push eax
;     push ebx

;     push eax
;     mov ah, GLOBAL_COLOR
;     mov al, '0'
;     call write_char
;     inc word [cursor]

;     mov ah, GLOBAL_COLOR
;     mov al, 'b'
;     call write_char
;     inc word [cursor]
;     pop eax

;     mov bx, 0b1000000000000000
; .loop:
;     test bx, bx
;     jz .exit

;     push eax
;     and ax, bx
;     shr bx, 1

;     test ax, ax
;     jnz .set_bit

;     mov ah, GLOBAL_COLOR
;     mov al, '0'
;     call write_char
;     inc word [cursor]
;     pop eax

;     jmp .loop

; .set_bit:
;     mov ah, GLOBAL_COLOR
;     mov al, '1'
;     call write_char
;     inc word [cursor]
;     pop eax

;     jmp .loop

; .exit:
;     pop ebx
;     pop eax
;     ret