use32
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  ||                                             ||  ;;;
;;;  ||    This program is create made by RILAX     ||  ;;;
;;;  \/                                             \/  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

calculator:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;  program kalkulator (32-bits)  ;;
    ;;         EAX to output          ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; w EAX jest trzymana liczba A i output
    ; w EBX jest trzymana liczba B

    push eax
    push ebx
    push ecx
    push edx
    push edi
    push esi

    mov [.exit_bool], byte 0

    mov ah, [global_color]
    mov esi, .welcome_msg
    call write_buffer

.loop:
    mov ah, [global_color]
    mov esi, .command_prefix
    call write_buffer
    call read_buffer

    cmp word [read_cursor], 0
    call calculator_choose_operation

    cmp [.exit_bool], 0
    jz .loop

    mov ah, [global_color]
    mov esi, .exit_msg
    call write_buffer

    pop esi
    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret


.command_prefix: db "Calculator> ", 0
.input_a_tag: db "Number A> ", 0
.input_b_tag: db "Number B> ", 0

.welcome_msg: 
    db "=========================================",10
    db "==  Welcome to the calculator program  ==",10
    db "=========================================",10,10, 0

.help_command_msg: 
    db 10
    db "1. help => Help.",10
    db "2. exit => Exit form program.",10
    db "3. cls  => Clear text.",10
    db "4. +    => Add.",10
    db "5. -    => Sub. (A-B)",10
    db "6. *    => Mul.",10
    db "7. /    => Div. (A/B)",10
    db "8. ^    => Pow. (A^B)",10,10
    db 0

.exit_msg: db "Exit calculator!",10, 0
.error_msg: db "Error!",10, 0
.no_div_zero_msg: db "You cannot divide by zero!",10,10, 0
.unknown_command_msg: db "Invaild command! Use the help command.",10, 0
.div_r_msg: db "r.", 0
.add_msg: db "Addition", 0
.sub_msg: db "Subtraction", 0
.mul_msg: db "Multiplication", 0
.div_msg: db "Divide", 0
.pow_msg: db "Power", 0

.cls_command: db "cls", 0
.help_command: db "help", 0
.exit_command: db "exit", 0
 
.add_command: db "+", 0
.sub_command: db "-", 0
.mul_command: db "*", 0
.div_command: db "/", 0
.pow_command: db "^", 0

.exit_bool db 0
.operation_number db 0
.nul: db 0

calculator_choose_operation:
    mov esi, read_content

    mov edi, calculator.exit_command
    call cmp_str
    je .exit

    mov edi, calculator.help_command
    call cmp_str
    je .help

    mov edi, calculator.cls_command
    call cmp_str
    je .cls


    mov edi, calculator.add_command
    call cmp_str
    je .add

    mov edi, calculator.sub_command
    call cmp_str
    je .sub

    mov edi, calculator.mul_command
    call cmp_str
    je .mul

    mov edi, calculator.div_command
    call cmp_str
    je .div

    mov edi, calculator.pow_command
    call cmp_str
    je .pow

    mov edi, calculator.nul
    call cmp_str
    jz .space

    mov ah, [global_color]
    mov esi, calculator.unknown_command_msg
    call write_buffer
    ret

    .space:
    ret

    .help:
    mov esi, calculator.help_command_msg
    call write_buffer
    jmp .after

    .cls:
    call clear_screen
    jmp .after

    .add:
    mov [calculator.operation_number], byte 2
    call calculator_inputs
    jmp .after

    .sub:
    mov [calculator.operation_number], byte 3
    call calculator_inputs
    jmp .after

    .mul:
    mov [calculator.operation_number], byte 4
    call calculator_inputs
    jmp .after

    .div:
    mov [calculator.operation_number], byte 5
    call calculator_inputs
    jmp .after

    .pow:
    mov [calculator.operation_number], byte 6
    call calculator_inputs
    jmp .after

    .exit:
    mov [calculator.exit_bool], byte 1
    ret

.error:
    call panic

.after:
    ret

calculator_inputs:
    mov ah, [global_color]
    mov esi, calculator.input_a_tag
    call write_buffer

    mov esi, read_content
    call read_buffer

    cmp word [esi], 0
    je .error_exit

    call if_ascii_number
    jz .calculator_valid_num_a
    xor esi, esi
    call error
    call new_line
    jmp .exit
.calculator_valid_num_a:

    call s_decimal_binary
    push eax ; zapis eax poniewaz jest potem tymczasowo modyfikowany (liczba A)
    ; call new_line

    mov ah, [global_color]
    mov esi, calculator.input_b_tag
    call write_buffer

    mov esi, read_content
    call read_buffer

    cmp byte [esi], 0
    je .error_exit

    call if_ascii_number
    jz .calculator_valid_num_b
    pop eax
    xor esi, esi
    call error
    call new_line
    jmp .exit
.calculator_valid_num_b:
    
    call s_decimal_binary
    mov ebx, eax ; odczyt zawartosci ax do bx (liczba B)
    pop eax ; odczyt zawartosci ax do ax (liczba A)
    mov edx, 0

    cmp [calculator.operation_number], 2
    je .add

    cmp [calculator.operation_number], 3
    je .sub

    cmp [calculator.operation_number], 4
    je .mul

    cmp [calculator.operation_number], 5
    je .div

    cmp [calculator.operation_number], 6
    je .pow

.exit:
    ret

    .add:
    add eax, ebx

    push eax
    mov ah, [global_color]
    mov esi, .msg_add
    call write_buffer
    pop eax
    call s_binary_decimal
    call new_line
    jmp .exit

    .sub:
    sub eax, ebx

    push eax
    mov ah, [global_color]
    mov esi, .msg_add
    call write_buffer
    pop eax
    call s_binary_decimal
    call new_line
    jmp .exit

    .mul:
    push edx
    imul ebx
    pop edx

    push eax
    mov ah, [global_color]
    mov esi, .msg_add
    call write_buffer
    pop eax
    call s_binary_decimal
    call new_line
    jmp .exit

    .div:
    test ebx, ebx
    jz .div_exit

    xor edx, edx  

    cmp eax, 0
    jge .after_div

    not edx

.after_div:
    idiv ebx

    push eax
    mov ah, [global_color]
    mov esi, .msg_div
    call write_buffer
    pop eax
    call s_binary_decimal
    mov ah, [global_color]
    mov esi, .msg_r
    call write_buffer
    mov eax, edx
    call s_binary_decimal
    call new_line
    
    jmp .exit

.div_exit:
    mov ah, [global_color]
    mov esi, calculator.no_div_zero_msg
    call write_buffer
    jmp .exit


    .pow:
    call math_power

    push eax
    mov ah, [global_color]
    mov esi, .msg_pow
    call write_buffer
    pop eax
    call s_binary_decimal
    call new_line
    jmp .exit

.msg_add: db "+= ", 0
.msg_sub: db "-= ", 0
.msg_mul: db "*= ", 0
.msg_div: db "/= ", 0
.msg_r: db " r. ", 0
.msg_pow: db "^= ", 0

.error_exit:
    ret
