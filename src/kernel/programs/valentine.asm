valentine:
    mov bx, proj01
    call write_buffer
    mov bx, proj02
    call write_buffer
    mov bx, proj03
    call write_buffer
    mov bx, proj04
    call write_buffer
    mov bx, proj05
    call write_buffer

    mov bx, proj11
    call write_buffer
    mov bx, proj12
    call write_buffer
    mov bx, proj13
    call write_buffer
    mov bx, proj14
    call write_buffer
    mov bx, proj15
    call write_buffer
    mov bx, proj16
    call write_buffer
    mov bx, proj17
    call write_buffer
    mov bx, proj18
    call write_buffer
    mov bx, proj19
    call write_buffer
    mov bx, proj21
    call write_buffer
    mov bx, proj22
    call write_buffer
    mov bx, proj23
    call write_buffer
    mov bx, proj24
    call write_buffer
    mov bx, proj25
    call write_buffer

    mov bx, proj06
    call write_buffer
    mov bx, proj07
    call write_buffer
    mov bx, proj08
    call write_buffer
    mov bx, proj09
    call write_buffer
    mov bx, proj10
    call write_buffer

    ; call new_line
    ret

%include "programs/valentine_text.asm"