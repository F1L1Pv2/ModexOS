bdb_oem                         equ 0x7c03 ; 8  bytes
bdb_bytes_per_sector            equ 0x7c0b ; 2  bytes
bdb_sectors_per_cluster         equ 0x7c0d ; 1  bytes
bdb_reserved_sectors            equ 0x7c0e ; 2  bytes
bdb_fat_count                   equ 0x7c10 ; 1  bytes
bdb_root_entry_count            equ 0x7c11 ; 2  bytes
bdb_total_sectors               equ 0x7c13 ; 2  bytes
bdb_media_descriptor_type       equ 0x7c15 ; 1  bytes
bdb_sectors_per_fat             equ 0x7c16 ; 2  bytes
bdb_sectors_per_track           equ 0x7c18 ; 2  bytes
bdb_heads                       equ 0x7c1a ; 2  bytes
bdb_hidden_sectors              equ 0x7c1c ; 4  bytes
bdb_large_sector_count          equ 0x7c20 ; 4  bytes

; extended boot record
ebr_drive_number                equ 0x7c24 ; 1  bytes
ebr_signature                   equ 0x7c26 ; 1  bytes
ebr_volume_id                   equ 0x7c27 ; 4  bytes
ebr_volume_label                equ 0x7c2b ; 11 bytes
ebr_system_id                   equ 0x7c36 ; 8  bytes

buffer equ 0x7c00 + 512

fat_init:
    ; calculate total sectors
    xor eax, eax
    mov ax,  word [bdb_total_sectors]
    mov dword [total_sectors], eax

    ;calculate fat size
    xor eax, eax
    mov ax, word [bdb_sectors_per_fat]
    mov dword [fat_size], eax


    ;calculate first fat sector
    xor eax, eax
    mov ax, word [bdb_reserved_sectors]
    mov dword [first_fat_sector], eax

    ;calculate root dir sectors
    xor eax, eax
    mov ax, word [bdb_root_entry_count]
    mov ecx, 32
    mul ecx
    xor ecx, ecx
    mov cx, word [bdb_bytes_per_sector]
    add eax, ecx
    dec eax
    xor edx, edx
    div ecx
    mov dword [root_dir_sectors], eax

    ;calculate first root dir sector
    xor eax, eax
    mov ax, word [bdb_fat_count]
    mov ecx, dword [fat_size]
    mul ecx
    xor ecx, ecx
    mov cx, word [bdb_reserved_sectors]
    add eax, ecx
    mov dword [first_root_dir_sector], eax

    ;calculate first data sector

    xor eax, eax
    mov ax, word [bdb_fat_count]
    mov ecx, dword [fat_size]
    mul ecx
    xor ecx, ecx
    mov cx, word [bdb_reserved_sectors]
    add eax, ecx
    add eax, dword [root_dir_sectors]

    mov dword [first_data_sector], eax

    ret

fat_load_and_update_cluster:
    ;saving cluster number
    push eax
    push edi
    push edx
    push ecx

    call claculate_first_sector_of_cluster

    mov edi, eax
    mov cl, byte [bdb_sectors_per_cluster]
    mov dl, 1

    ;; TODO: for some reason ata doesnt work good if it needs to load more than 1 sector so for now im manually loading one sector at a time

; .load_loop:
;     cmp cl, 0
;     je .after

;     call ata_read_sectors

;     dec cl
;     inc edi
;     add esi, 512
;     jmp .load_loop
; .after:

    mov edi, eax
    xor edx, edx
    mov dl, byte [bdb_sectors_per_cluster]
    call ata_read_sectors
    xor eax, eax
    mov al, byte [bdb_sectors_per_cluster]
    xor ecx, ecx
    mov cx, word [bdb_bytes_per_sector]
    xor edx, edx
    mul ecx
    add esi, eax

    pop ecx
    pop edx
    pop edi
    pop eax
    ret

fat_get_next_cluster:
    mov ax, word [buffer+eax*2]
    ret

claculate_first_sector_of_cluster:
    ;input cluster in ax
    ;output adress in eax
    push ecx
    push edx

    sub eax, 2
    xor ecx, ecx
    mov cl, byte [bdb_sectors_per_cluster]
    mul ecx
    add eax, dword [first_data_sector]

    pop edx
    pop ecx
    ret


fat_load_file_root_dir:
    ; esi load offset
    ; edi filename
    ; success in zero flag
    push esi
    push edi
    push edx
    push ecx
    push ebx
    push eax

    mov dword [fat_imm_load_offset], esi
    mov dword [fat_imm_filename_ptr], edi

.search_file:
    ; load root dir
    mov esi, buffer
    mov edi, dword [first_root_dir_sector]
    xor edx, edx
    mov dx, word [bdb_sectors_per_fat]
    call ata_read_sectors

    mov edi, esi
    mov ebx, 0
.search_kernel_loop:
    mov esi, dword [fat_imm_filename_ptr]
    mov ecx, 11
    push edi
    repe cmpsb
    pop edi
    je .kernel_found

    add edi, 32
    inc ebx
    cmp bx, word [bdb_root_entry_count]
    jl .search_kernel_loop

    ; clearing zero flag for failure
    mov eax, 1
    cmp eax, 0
    jmp .after

    ; mov esi, kernel_not_found_msg
    ; call panic

.kernel_found:

    mov esi, edi
    mov eax, dword [esi+28]
    mov dword [kernel_size_in_bytes], eax
    add esi, 26
    ;getting first cluster
    xor eax, eax
    mov ax, word [esi]

    ;load fat table
    mov esi, buffer
    mov edi, dword [first_fat_sector]
    mov edx, dword [fat_size]
    call ata_read_sectors

    mov esi, dword [fat_imm_load_offset]
.fat_load_loop:
    call fat_load_and_update_cluster
    call fat_get_next_cluster
    cmp eax, 0xFFF8
    jl .fat_load_loop

    ; setting zero flag for success
    mov eax, 0
    cmp eax, 0
.after:
    pop eax
    pop ebx
    pop ecx
    pop edx
    pop edi
    pop esi

    ret

fat_imm_load_offset: dd 0
fat_imm_filename_ptr: dd 0

total_sectors: dd 0
fat_size: dd 0
root_dir_sectors: dd 0

first_data_sector: dd 0
first_fat_sector: dd 0
first_root_dir_sector: dd 0
