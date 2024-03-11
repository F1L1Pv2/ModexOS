ATA_Data_Register equ 0x1F0
ATA_Error_Features_Register equ 0x1F1
ATA_Sector_Count_Register equ 0x1F2
ATA_LBAlo_Register equ 0x1F3
ATA_LBAmid_Register equ 0x1F4
ATA_LBAhi_Register equ 0x1F5
ATA_Drive_Head_Register equ 0x1F6
ATA_Status_Register equ 0x1F7
ATA_Command_Register equ 0x1F7

ATA_CONTROL_Alternate_status_register_Device_control_register equ 0x3F6
ATA_Drive_Adress_register equ 0x3F7
ATA_PRIMARY_DRIVE equ 0xE0

ata_init:

    call ata_check_status
    mov ah, 0x0e
    mov esi, status_msg
    call write_buffer

    call ata_identify

    mov ah, 0x0e
    mov esi, identify_msg
    call write_buffer

    call turn_on_lba_mode

    ret

wait_400ns:
    push edx
    push eax
    push ecx

    mov ecx, 0
    mov edx, ATA_Status_Register
.loop:
    in al, dx

    inc ecx
    cmp ecx, 15
    jl .loop

    pop ecx
    pop eax
    pop edx
    ret

ata_read_sectors:
    ; esi buffer offset
    ; edi LBA (28 bit)
    ; edx sector count
    push eax
    push ebx
    push ecx
    push edx
    push edi
    push esi

    push edx
    push esi
    

    mov eax, ATA_PRIMARY_DRIVE
    
    push edi
    shr edi, 24
    mov ebx, edi
    or al, bl

    push edx
    mov dx, ATA_Drive_Head_Register
    out dx, al


    pop edx
    mov al, dl
    mov dx, ATA_Sector_Count_Register
    out dx, al

    pop edi

    mov eax, edi
    ; call binary_8
    ; call new_line
    mov dx, ATA_LBAlo_Register
    out dx, al

    shr eax, 8
    ; call binary_8
    ; call new_line
    mov dx, ATA_LBAmid_Register
    out dx, al

    shr eax, 8
    ; call binary_8
    ; call new_line
    mov dx, ATA_LBAhi_Register
    out dx, al

    mov al, 0x20
    mov dx, ATA_Command_Register
    out dx, al

    mov dx, ATA_Status_Register
    mov bl, 10000000b
    call wait_until_bit_clear

    in al, dx
    ; call binary_8
    ; call new_line


    mov ebx, 0
    xor eax, eax

    pop esi
    pop edx
    mov ecx, edx

    mov dx, ATA_Data_Register
.loop:

    in ax, dx

    mov word [esi+ebx*2], ax ; writing data

    inc ebx
    cmp ebx, 256
    jl .loop

    dec ecx
    cmp ecx, 0
    jne .call_next_sector
    jmp .after_loop

.call_next_sector:
    mov al, 0x20
    mov dx, ATA_Command_Register
    out dx, al

    mov dx, ATA_Status_Register
    mov bl, 10000000b
    call wait_until_bit_clear
    
    mov dx, ATA_Data_Register
    mov ebx, 0
    add esi, 512
    jmp .loop


.after_loop:
    call wait_400ns

    pop esi
    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


turn_on_lba_mode:
    push edx
    push eax

    mov dx, ATA_Drive_Head_Register
    in al, dx

    or al, 01000000b
    out dx, al
    
    pop eax
    pop edx
    ret

turn_on_chs_mode:
    push edx
    push eax

    mov dx, ATA_Drive_Head_Register
    in al, dx

    and al, 011011111b
    out dx, al

    pop eax
    pop edx
    ret

ata_identify:

    mov dx, ATA_Drive_Head_Register
    mov al, 0xA0 ; primary drive
    out dx, al

    ; clearing

    mov dx, ATA_Sector_Count_Register
    mov al, 0x0
    out dx, al

    mov dx, ATA_LBAlo_Register
    out dx, al

    mov dx, ATA_LBAmid_Register
    out dx, al

    mov dx, ATA_LBAhi_Register
    out dx, al

    mov dx, ATA_Command_Register
    mov al, 0xEC ; identify command
    out dx, al

    in al, dx
    cmp al, 0
    je .drive_dont_exist

    mov dx, ATA_Status_Register
    mov bl, 10000000b
    call wait_until_bit_clear

    mov dx, ATA_LBAmid_Register
    in al, dx
    cmp al, 0
    jnz .not_ata

    mov dx, ATA_LBAhi_Register
    in al, dx
    cmp al, 0
    jnz .not_ata

    mov dx, ATA_Status_Register
    mov bl, 00001000b
    call wait_until_bit_set

    mov ebx, 0
    mov dx, ATA_Data_Register
.loop:
    in ax, dx
    mov word [identify_table+ebx*2], ax
    
    inc ebx
    cmp ebx, 256
    jl .loop

    jmp .after

.drive_dont_exist:
    mov esi, no_drive_msg
    call panic

.not_ata:
    mov esi, not_ata_msg
    call panic

.after:
    ret

wait_until_bit_set:
    push eax
    ; dx port
    ; bl bitmask
.loop:
    in al, dx
    and al, bl ; checking if bit is set
    jz .loop
    pop eax
    ret

wait_until_bit_clear:
    push eax
    ; dx port
    ; bl bitmask
.loop:
    in al, dx
    and al, bl ; checking if bit is set
    jnz .loop
    pop eax
    ret

ata_check_status:
    push edx
    push eax

    mov dx, ATA_Status_Register
    in al, dx

    cmp al, 0xFF
    je .no_drive
    jmp .after
.no_drive:
    mov esi, no_drive_msg
    call panic

.after:
    pop eax
    pop edx
    ret

identify_table: times 256 dw 0

status_msg: db "ATA status passed",      10, 0
identify_msg: db "ATA identify passed",  10, 0
no_drive_msg: db "No drive was found",   10, 0
not_ata_msg: db "This device is not ata",10, 0
