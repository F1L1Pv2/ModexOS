[org 0x7c00]
[bits 16]
xor ax, ax                          
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp

mov ah, 2
mov al, 1 ; number of sectors
mov ch, 0 ; cylinder number
mov cl, 2 ; sector number
mov dh, 0 ; head number
mov bx, 0x7e00
int 0x13


%include "main.asm"

jmp $

times 510 - ($-$$) db 0
db 0x55, 0xaa

new_sector:
%include "core.asm"
times 512 - ($-new_sector) db 0
