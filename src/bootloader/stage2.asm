include "initial_setup.asm"
use32

GLOBAL_COLOR equ 0x0a
KERNEL_LOAD_OFFSET equ 0x100000

main:
    ; [bits 32]

    ;setup segment registers
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax

    call get_initial_cursor

    call ata_init
    call fat_init

    mov ah, GLOBAL_COLOR
    mov esi, stage2_msg
    call write_buffer

    mov esi, KERNEL_LOAD_OFFSET
    mov edi, file_kernel_bin
    call fat_load_file_root_dir
    jne .kernel_not_found

    call update_cursor

    ;setup things for kernel
    mov eax, memmory_table
    xor ebx, ebx
    mov bx, word [memmory_table_count]
    mov edx, dword [kernel_size_in_bytes]
    jmp KERNEL_LOAD_OFFSET    

    cli
    hlt

.kernel_not_found:
    mov esi, kernel_not_found_msg
    call panic

panic:
    push esi
    push eax

    mov ah, 0x04
    push esi
    mov esi, panic_msg
    call write_buffer

    pop esi
    call write_buffer

    mov al, 32
    call write_char
    call update_cursor

    pop eax
    pop esi

    cli
    hlt



panic_msg: db "BOOT PANIC: ", 0

stage2_msg: db "STAGE2 bootloader loading KERNEL",10,0
file_kernel_bin: db 'KERNEL  BIN'
kernel_not_found_msg: db "kernel.bin not found!",10, 0
kernel_size_in_bytes: dd 0


include "boot_io.asm"
include "drivers/ata.asm"
include "drivers/fat16.asm"

; times (512*6)-($-$$) db 0xFE