org 0x20000
bits 16

mov byte [disk_num], dl

%include "terminal.asm"

; disk byte table
disk_num: db 0
cylinder_num: db 0 
sector_num:   db 0
head_num:     db 0