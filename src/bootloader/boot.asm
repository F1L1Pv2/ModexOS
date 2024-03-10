org 0x7c00
use16

STAGE2_LOAD_SEGMENT equ 0x2000
STAGE2_LOAD_OFFSET equ 0x0

; bits 16

;
; FAT16 header
; 
jmp short start
nop

; thoose values will be created by mkfs.fat during compilation date

bdb_oem:                    times 8 db 0         ; 8 bytes
bdb_bytes_per_sector:       dw 0
bdb_sectors_per_cluster:    db 0
bdb_reserved_sectors:       dw 0
bdb_fat_count:              db 0
bdb_dir_entries_count:      dw 0
bdb_total_sectors:          dw 0
bdb_media_descriptor_type:  db 0
bdb_sectors_per_fat:        dw 0
bdb_sectors_per_track:      dw 0
bdb_heads:                  dw 0
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           db 0                 
                            db 0                 ; reserved
ebr_signature:              db 0
ebr_volume_id:              times 4 db 0         ; serial number, value doesn't matter
ebr_volume_label:           times 11 db 0        ; 11 bytes, padded with spaces
ebr_system_id:              times 8 db 0         ; 8 bytes

;
; Code goes here
;

start:

mov ax, 0
mov ds, ax
mov es, ax

mov ss, ax
mov sp, 0x7C00

push es
push word .after
retf

.after:

    mov si, stage1_msg
    call puts

    mov al, 6
    mov bx, STAGE2_LOAD_SEGMENT
    mov es, bx
    mov bx, STAGE2_LOAD_OFFSET
    mov ch, 0
    mov cl, 2
    mov dh, 0

    mov ah, 2
    int 0x13

    mov bx, STAGE2_LOAD_SEGMENT
    mov ds, bx
    jmp STAGE2_LOAD_SEGMENT:STAGE2_LOAD_OFFSET

    mov ah, 0x0e
    mov al, 'N'
    mov bl, 0
    int 0x10


    cli
    hlt

puts:
    ; save registers we will modify
    push si
    push bx
    push ax

.loop:
    lodsb               ; loads next character in al
    or al, al           ; verify if next character is null?
    jz .done

    mov ah, 0x0E        ; call bios interrupt
    mov bh, 0           ; set page number to 0
    int 0x10

    jmp .loop

.done:
    pop ax
    pop bx
    pop si    
    ret

stage1_msg: db "STAGE1 bootloader loading STAGE2",13,10,0

times 510-($-$$) db 0
dw 0xAA55