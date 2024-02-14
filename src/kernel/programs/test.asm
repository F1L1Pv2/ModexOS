test:
    ; call calculator

    ; call cls
    ; call valentine

    ;  mov bx, 16
    ; mov ax, 2
    ; call power
    ; call binary_decimal

    ; add ax, 48
    ; call write_char
    ; call new_line
    ; call new_line

    ; mov ax, 6
    ; call binary_decimal
    ; call new_line
    ; call new_line

    mov bx, number_input
    ; call write_buffer
    ; call flip_bytes_table
    call decimal_binary
    ; call flip_bytes_table
    call binary_decimal
    call new_line
    call new_line

    ; mov bx, calculator_command
    ; call decimal_binary
    ; call binary_decimal
    ; call new_line
    ; call new_line

    ; mov bx, number_input
    ; call decimal_binary
    ; call binary_decimal
    ret

number_input: db "9", 0




; calculator_input:
;     mov bx, calculator_input_a_msg
;     call write_buffer

;     mov bx, calculator_command
;     mov dx, calculator_command_len
;     call clear_buffer
;     call read_buffer

;     call decimal_binary
;     push ax ; zapis w cx ktory zostanie przeniesionydo ax
;     ; mov cx, ax ; zapis w cx ktory zostanie przeniesionydo ax
;     call new_line

;     mov bx, calculator_input_b_msg
;     call write_buffer

;     mov bx, calculator_command
;     mov dx, calculator_command_len
;     call clear_buffer
;     call read_buffer
    
;     call decimal_binary
;     mov bx, ax ; (liczba B)
;     pop ax ; przeniesienie do ax (liczba A)
;     ; mov ax, cx ; przeniesienie do ax (liczba A)

;     call new_line

;     ; dekoder komendy z reg si (wybor operacji) 
;     cmp si, 2
;     jz .add

;     cmp si, 3
;     jz .sub

;     cmp si, 4
;     jz .mul

;     cmp si, 5
;     jz .div

;     cmp si, 6
;     jz .pow
;     ;

;     push bx
;     mov bx, calculator_help_command
;     call write_buffer
;     pop bx

;     jmp .exit

; .add:
;     add ax, bx
;     ret
; .sub:
;     ret
; .mul:
;     ret
; .div:
;     ret
; .pow:
;     ; call power
;     ret

; .exit:
;     call new_line
;     xor si, si
;     ret



; .sub:    
;     jz .mode1
;     jmp .mode2

;     .mode1:
;     sub ax, bx
;     jmp .sub_exit

;     .mode2:
;     sub bx, ax
;     mov ax, bx
;     jmp .sub_exit
    
;     .sub_exit:
;     ret