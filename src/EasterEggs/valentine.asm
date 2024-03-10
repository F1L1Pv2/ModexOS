valentine:
    mov esi, proj01
    call write_buffer
    mov esi, proj02
    call write_buffer
    mov esi, proj03
    call write_buffer
    mov esi, proj04
    call write_buffer
    mov esi, proj05
    call write_buffer

    mov esi, proj11
    call write_buffer
    mov esi, proj12
    call write_buffer
    mov esi, proj13
    call write_buffer
    mov esi, proj14
    call write_buffer
    mov esi, proj15
    call write_buffer
    mov esi, proj16
    call write_buffer
    mov esi, proj17
    call write_buffer
    mov esi, proj18
    call write_buffer
    mov esi, proj19
    call write_buffer
    mov esi, proj21
    call write_buffer
    mov esi, proj22
    call write_buffer
    mov esi, proj23
    call write_buffer
    mov esi, proj24
    call write_buffer
    mov esi, proj25
    call write_buffer

    mov esi, proj06
    call write_buffer
    mov esi, proj07
    call write_buffer
    mov esi, proj08
    call write_buffer
    mov esi, proj09
    call write_buffer
    mov esi, proj10
    call write_buffer

    ; call new_line
    ret

include "../eastereggs/valentine_text.asm"