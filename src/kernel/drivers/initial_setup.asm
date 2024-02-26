org 0x20000

bits 16

mov byte [disk_num], dl

call do_e820

%include "drivers/switch_mode_gdt.asm"
%include "drivers/setup_memmory.asm"
