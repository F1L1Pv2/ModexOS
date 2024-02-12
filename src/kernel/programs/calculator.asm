;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  ||                                             ||  ;;;
;;;  ||    This program is create made by RILAX     ||  ;;;
;;;  \/                                             \/  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

calculator:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;  program kalkulator (16-bits)  ;;
    ;;         AX to wejscie A        ;;
    ;;         BX to wejscie B        ;;
    ;;          CX to output          ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push ax
    push bx
    push dx
    push si

    xor si, si

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
    jnz .exit

    jmp .loop
    
.exit:
    mov bx, calculator_exit_msg
    call write_buffer

    pop si
    pop dx
    pop bx
    pop ax

    ret

calculator_choose_command:
    mov bx, calculator_command

    mov dx, calculator_exit_command
    call cmp_str
    je .exit_cmd

    cmp byte [bx], 0
    je .nothing

    mov bx, calculator_unknown_command_msg
    call write_buffer
    call new_line
    ret

    .exit_cmd:
    inc si
    ret

    .nothing:
    ret

calculator_command_msg: db "Calculator> ", 0
calculator_input_a_msg: db "Number A> ", 0
calculator_input_b_msg: db "Number B> ", 0

calculator_welcome_msg: db "=========================================",NEW_LINE,"==  Welcome to the calculator program  ==",NEW_LINE,"=========================================", 0
calculator_help_msg: db "heeelp",NEW_LINE, 0
calculator_exit_msg: db "Exit calculator!",NEW_LINE, 0
calculator_error_msg: db "Error!",NEW_LINE, 0
calculator_unknown_command_msg: db "Error command!",NEW_LINE, 0

calculator_help_command: db "help", 0
calculator_exit_command: db "exit", 0

calculator_command: times 8 db 0
calculator_command_len: equ $ - calculator_command