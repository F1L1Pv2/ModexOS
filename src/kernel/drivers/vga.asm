bits 32

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

cursor: dd 0

vga_history: times 10*80*25 db 0
vga_history_len equ $ - vga_history

; Screen buffer address!
ScreenBuffer  equ 0xB8000