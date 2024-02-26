org 0x20000

bits 16

mov byte [disk_num], dl

call do_e820

%include "core/switch_mode_gdt.asm"
%include "core/setup_memmory.asm"
