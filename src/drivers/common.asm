bits 32

check_bit:
    ; al to check
    ; bl bitmask
    push eax
    and al, bl
    cmp al, 0
    pop eax
    ret

panic:
    push esi
    push eax

    mov ah, 0x04
    push esi
    mov esi, panic_msg
    call write_buffer

    pop esi
    call write_buffer

    pop eax
    pop esi

    cli
    hlt


GLOBAL_COLOR equ 0x0a

panic_msg: db "PANIC: ", 0