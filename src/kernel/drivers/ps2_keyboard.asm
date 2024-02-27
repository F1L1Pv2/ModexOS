bits 32

ps2_read_char:
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;   ta funkcja czyta jeden klawisz    ;;
    ;;    z klawiatury należy ignorować    ;;
    ;;          0xFE oraz 0xFF             ;;
    ;;       funkcja tez updatuje          ;;
    ;;    ps2_shift oraz ps2_control       ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;

    ;left_arrow     0xFA
    ;right_arrow    0xFB
    ;up_arrow       0xFC
    ;down_arrow     0xFD
    ;page_up        0xF9
    ;page_down      0xF8

    push edi
    call ps2_wait_set_output
    in al, 0x60
    cmp al, 0xE0
    je .special_key_handle
    
    cmp al, 0x3A
    je .toggle_caps_lock
    cmp al, 0x2A
    je .turn_on_shift
    cmp al, 0xAA
    je .turn_off_shift
    
    mov edi, eax
    and edi, 0xFF

    mov al, byte[ps2_capslock]

    cmp byte[ps2_shift], al
    je .normal_key
    jmp .alt_key


    .normal_key:
    mov al, [edi+ps2_code_key_table-1]
    jmp .after

    .alt_key:
    mov al, [edi+ps2_shift_code_key_table-1]
    jmp .after


    .special_key_handle:

    call ps2_wait_set_output

    in al, 0x60

    ; TODO: Change into table not an hardcoded if else if else
    cmp al, 0x4B
    je .left_arrow
    cmp al, 0x4D
    je .right_arrow
    cmp al, 0x48
    je .up_arrow
    cmp al, 0x50
    je .down_arrow
    cmp al, 0x49
    je .page_up
    cmp al, 0x51
    je .page_down

    mov al, 0xFF
    jmp .after
    .toggle_caps_lock:
    mov al, 1
    sub al, byte [ps2_capslock]
    mov byte [ps2_capslock], al
    mov al, 0xFF
    jmp .after
    .turn_on_shift:
    mov byte [ps2_shift], 1
    mov al, 0xFF
    jmp .after
    .turn_off_shift:
    mov byte [ps2_shift], 0
    mov al, 0xFF
    jmp .after
    .left_arrow:
    mov al, 0xFE - 4 ; 0xFA
    jmp .after
    .right_arrow:
    mov al, 0xFF - 3 ; 0xFB
    jmp .after
    .up_arrow:
    mov al, 0xFF - 2 ; 0xFC
    jmp .after
    .down_arrow:
    mov al, 0xFF - 1 ; 0xFD
    jmp .after
    .page_up:        ; 0xF9
    mov al, 0xF9
    jmp .after
    .page_down:      ; 0xF8
    mov al, 0xF8
    jmp .after
    .after:
    pop edi
    ret

ps2_wait_clear_input:
    push ecx
    mov cl, 3
    .loop:
    in al, 0x64
    and al, 0b00000010
    cmp al, 0
    jne .loop
    pop ecx
    ret

ps2_wait_set_input:
    push ecx
    mov cl, 3
    .loop:
    in al, 0x64
    and al, 0b00000010
    cmp al, 0
    je .loop
    pop ecx
    ret

ps2_wait_clear_output:
    push ecx
    mov cl, 3
    .loop:
    in al, 0x64
    and al, 0b00000001
    cmp al, 0
    jne .loop
    pop ecx
    ret

ps2_wait_set_output:
    ;;F1L1P;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;     funkcja służąca do czekania     ;;
    ;;         do momentu aż można         ;;
    ;;         czytać z portu 0x60         ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;F1L1P;;
    push ecx
    mov cl, 3
    .loop:
    in al, 0x64
    and al, 0b00000001
    cmp al, 0
    je .loop
    pop ecx
    ret

ps2_shift:    db 0
ps2_capslock: db 0

; code key table
ps2_code_key_table: 
               db 27,'1','2','3','4','5','6','7','8','9','0','-','=',8,0xfe,'q','w','e','r','t','y','u','i','o','p','[',']',10,0xfe,'a','s','d','f','g','h','j','k','l'
               db ';',39,'`',0xfe,92,'z','x','c','v','b','n','m',',','.','/',0xfe
               db '*',0xfe,' ',0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,'7','8','9','-','4','5','6','+','1','2','3','0','.',0xff,0xff,0xff,0xfe,0xfe,0xff,0xff,0xff,0xff
    times 4*20 db 0xfe
               db 0xff,0xff,0xff,0xfe,0xfe,0xff,0xff,0xff
    times 4*41 db 0xff
               db 0

ps2_shift_code_key_table: 
               db 27,'!','@','#','$','%','&','&','*','(',')','_','+',8,0xfe,'Q','W','E','R','T','Y','U','I','O','P','{','}',10,0xfe,'A','S','D','F','G','H','J','K','L'
               db ':',34,'~',0xfe,'|','Z','X','C','V','B','N','M','<','>','?',0xfe
               db '*',0xfe,' ',0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,'7','8','9','-','4','5','6','+','1','2','3','0','.',0xff,0xff,0xff,0xfe,0xfe,0xff,0xff,0xff,0xff
    times 4*20 db 0xfe
               db 0xff,0xff,0xff,0xfe,0xfe,0xff,0xff,0xff
    times 4*41 db 0xff
               db 0