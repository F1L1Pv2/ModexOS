syscall_handler:
    cmp eax, 10
    jz .binary_decimal

    jmp .panic

.binary_decimal:
    jmp .exit

.exit:
    iret

.panic:
    mov esi, panic_syscall_msg
    call panic

    cli
    hlt

cache: dd 0

panic_syscall_msg: db "Invalid interrupt function!", 10, 0