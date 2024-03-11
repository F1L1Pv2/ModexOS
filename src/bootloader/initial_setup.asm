org 0x20000
use16

mov byte [(disk_num and 0xFFFF)], dl

call (do_e820 and 0xFFFF)
include "switch_mode_gdt.asm"
disk_num: db 0
include "setup_memory.asm"
