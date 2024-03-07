org 0x20000
bits 16

mov byte [disk_num], dl


call do_e820

%include "switch_mode_gdt.asm"
disk_num: db 0
%include "setup_memmory.asm"
