%define SECTOR_NUM 4

[org 0x7c00]
[bits 16]
xor ax, ax                          
mov es, ax
mov ds, ax
mov bp, 0x7c00+512*(SECTOR_NUM+1)
mov sp, bp

mov ah, 2
mov al, SECTOR_NUM ; number of sectors
mov ch, 0 ; cylinder number
mov cl, 2 ; sector number
mov dh, 0 ; head number
mov bx, 0x7c00 + 512
int 0x13

jmp new_sector

times 510 - ($-$$) db 0
db 0x55, 0xaa

new_sector:
%include "main.asm"
%include "core.asm"
times 512*SECTOR_NUM - ($-new_sector) db 0
