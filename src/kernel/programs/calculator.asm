;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  ||                                             ||  ;;;
;;;  ||    This program is create made by RILAX     ||  ;;;
;;;  \/                                             \/  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

calculator:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;  program kalkulator (16-bits)  ;;
    ;;          AX to output          ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; w AX jest trzymana liczba A i output
    ; w BX jest trzymana liczba B

    push bx
    push dx
    push si

    xor si, si
    xor cx, cx

    call new_line
    mov bx, calculator_welcome_msg
    call write_buffer
    call new_line
    call new_line

.loop:
    mov bx, calculator_command_msg
    call write_buffer

    mov bx, calculator_command
    mov dx, calculator_command_len
    call clear_buffer
    call read_buffer

    call new_line
    call calculator_choose_command

    test si, si
    jz .loop

    mov bx, calculator_exit_msg
    call write_buffer

    pop si
    pop dx
    pop bx

    ret

calculator_choose_command:
    mov bx, calculator_command

    mov dx, calculator_exit_command
    call cmp_str
    je .exit_cmd

    mov dx, calculator_help_command
    call cmp_str
    je .help_cmd

    mov dx, calculator_cls_command
    call cmp_str
    je .cls_cmd

    ; Operacje
    mov dx, calculator_add_command
    call cmp_str
    je .add_cmd

    mov dx, calculator_sub_command
    call cmp_str
    je .sub_cmd

    mov dx, calculator_mul_command
    call cmp_str
    je .mul_cmd

    mov dx, calculator_div_command
    call cmp_str
    je .div_cmd

    mov dx, calculator_pow_command
    call cmp_str
    je .pow_cmd
    ; Operacje

    cmp byte [bx], 0
    je .nothing

    mov bx, calculator_unknown_command_msg
    call write_buffer

    ; mov al, '"'
    ; call write_char
    ; mov bx, calculator_command
    ; call write_buffer
    ; mov al, '"'
    ; call write_char

    call new_line
    call new_line
    ret

    .help_cmd:
    mov bx, calculator_help_command_msg
    call write_buffer
    ret

    .cls_cmd:
    call cls
    ; call new_line
    ; mov bx, calculator_welcome_msg
    ; call write_buffer
    ; call new_line
    ; call new_line
    ret

    ; Operacje
    .add_cmd:
    mov bx, calculator_add_msg
    call write_buffer
    call new_line
    call new_line

    mov si, 2
    call calculator_input
    ret

    .sub_cmd:
    mov bx, calculator_sub_msg
    call write_buffer
    call new_line
    call new_line

    xor cx, cx

    mov si, 3
    call calculator_input
    ret

    .mul_cmd:
    mov bx, calculator_mul_msg
    call write_buffer
    call new_line
    call new_line

    mov si, 4
    call calculator_input
    ret

    .div_cmd:
    mov bx, calculator_div_msg
    call write_buffer
    call new_line
    call new_line

    mov si, 5
    call calculator_input
    ret

    .pow_cmd:
    mov bx, calculator_pow_msg
    call write_buffer
    call new_line
    call new_line

    mov si, 6
    call calculator_input
    ret
    ; Operacje

    .exit_cmd:
    inc si
    ret

    .nothing:
    ret

calculator_input:
    mov bx, calculator_input_a_msg
    call write_buffer

    mov bx, calculator_command
    mov dx, calculator_command_len
    call clear_buffer
    call read_buffer

    cmp byte [bx], 0
    je .error_exit

    call if_ascii_number
    jz .calculator_valid_num_a
    xor si, si
    call error
    call new_line
    ret
.calculator_valid_num_a:

    call decimal_binary
    push ax ; zapis ax poniewaz jest potem tymczasowo modyfikowany (liczba A)
    call new_line

    mov bx, calculator_input_b_msg
    call write_buffer

    mov bx, calculator_command
    mov dx, calculator_command_len
    call clear_buffer
    call read_buffer

    cmp byte [bx], 0
    je .error_exit

    call if_ascii_number
    jz .calculator_valid_num_b
    pop ax
    xor si, si
    call error
    call new_line
    ret
.calculator_valid_num_b:
    
    call decimal_binary
    mov bx, ax ; odczyt zawartosci ax do bx (liczba B)
    pop ax ; odczyt zawartosci ax do ax (liczba A)

    call new_line

    ; dekoder komendy z reg si (wybor operacji) 
    cmp si, 2
    jz .add

    cmp si, 3
    jz .sub

    cmp si, 4
    jz .mul

    cmp si, 5
    jz .div

    cmp si, 6
    jz .pow

    call error
    jnz .error_exit

.add:
    add ax, bx
    jmp .exit
.sub:    
    sub ax, bx
    jmp .exit
.mul:
    mul bx
    jmp .exit
.div:
    xor dx, dx

    test bx, bx
    jz .no_div_zero

    div bx
    call binary_decimal
    mov cx, dx
    mov dx, ax
    mov ax, cx
    call space
    mov bx, calculator_div_r_msg
    call write_buffer
    jmp .exit
.pow:
    call power
    ; konec .pow

.exit:
    call binary_decimal
    call new_line
    xor si, si
    ret

.no_div_zero:
    mov bx, calculator_no_div_zero_msg
    call write_buffer
.error_exit:
    call new_line
    xor si, si
    ret

calculator_command_msg: db "Calculator> ", 0
calculator_input_a_msg: db "Number A> ", 0
calculator_input_b_msg: db "Number B> ", 0

calculator_welcome_msg: db "=========================================",NEW_LINE,"==  Welcome to the calculator program  ==",NEW_LINE,"=========================================", 0

calculator_help_command_msg: 
db NEW_LINE,"1. help => Help.",NEW_LINE,"2. exit => Exit form program.",NEW_LINE,"3. cls  => Clear text.",NEW_LINE,"4. +    => Add.",NEW_LINE,"5. -    => Sub. (A-B)",NEW_LINE,"6. *    => Mul.",NEW_LINE,"7. /    => Div. (A/B)",NEW_LINE,"8. ^    => Pow. (A^B)",NEW_LINE,NEW_LINE, 0

calculator_exit_msg: db "Exit calculator!",NEW_LINE, 0
calculator_error_msg: db "Error!",NEW_LINE, 0
calculator_no_div_zero_msg: db "You cannot divide by zero!",NEW_LINE, 0
calculator_unknown_command_msg: db "Invaild command! Use the help command.", 0
calculator_div_r_msg: db "r.", 0
calculator_add_msg: db "Addition", 0
calculator_sub_msg: db "Subtraction", 0
calculator_mul_msg: db "Multiplication", 0
calculator_div_msg: db "Divide", 0
calculator_pow_msg: db "Power", 0

calculator_cls_command: db "cls", 0
calculator_help_command: db "help", 0
calculator_exit_command: db "exit", 0
 
calculator_add_command: db "+", 0
calculator_sub_command: db "-", 0
calculator_mul_command: db "*", 0
calculator_div_command: db "/", 0
calculator_pow_command: db "^", 0

calculator_command: times 8 db 0
calculator_command_len: equ $ - calculator_command - 1