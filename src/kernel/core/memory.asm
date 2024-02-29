
memmory_between_msg: db " | ",0

memmory_type1_msg: db "1 - Usable (normal) RAM",0
memmory_type2_msg: db "2 - Reserved - unusable",0
memmory_type3_msg: db "3 - ACPI reclaimable memory",0
memmory_type4_msg: db "4 - ACPI NVS memory",0
memmory_type5_msg: db "5 - Area containing bad memory",0

memmory_types_table:
    dd 0
    dd memmory_type1_msg
    dd memmory_type2_msg
    dd memmory_type3_msg
    dd memmory_type4_msg
    dd memmory_type5_msg

memdup_top_msg: db "Base Address       | Length             | Type",10,0
memdup_entry: db "0x",0
memdump_total_mem_msg: db "Total Usable Memory: ",0
memdump_total_page_msg: db "Number of usable Pages: ",0

write_in_correct_size:

    ;
    ;   TODO: when value is 3GB it breaks
    ;

    push eax
    push ecx
    push edx

    mov ecx, 1024

    cmp eax, 1024
    jge .kilo_bytes

.bytes:
    call binary_decimal
    mov ah, [global_color]
    mov al, 'B'
    call write_char
    inc word [cursor]
    inc word [cursor]

    jmp .after

.kilo_bytes:
    mov edx, 0
    div ecx

    cmp eax, 1024
    jge .mega_bytes


    call binary_decimal
    mov ah, [global_color]
    mov al, 'K'
    call write_char
    inc word [cursor]
    mov al, 'B'
    call write_char
    inc word [cursor]

    jmp .after

.mega_bytes:
    mov edx, 0
    div ecx

    cmp eax, 1024
    jge .giga_bytes



    call binary_decimal
    mov ah, [global_color]
    mov al, 'M'
    call write_char
    inc word [cursor]
    mov al, 'B'
    call write_char
    inc word [cursor]
    
    jmp .after

.giga_bytes:
    mov edx, 0
    div ecx

    call binary_decimal
    mov ah, [global_color]
    mov al, 'G'
    call write_char
    inc word [cursor]
    mov al, 'B'
    call write_char
    inc word [cursor]
.after:

    pop edx
    pop ecx
    pop eax
    ret


memmory_dump:
    [bits 32]
    push esi
    push ecx
    push edx
    push eax

    mov esi, memdup_top_msg
    call write_buffer

    mov esi, memmory_table
    mov cx, word[memmory_table_count]
.loop:
    test cx, cx
    jz .after

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;        Base offset        ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    push esi
    mov esi, memdup_entry
    call write_buffer
    pop esi

    mov edx, 8
    call dump_xbytes_big_endian

    mov ah, [global_color]
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;                           ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    push esi
    mov esi, memmory_between_msg
    call write_buffer
    pop esi
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;         Length            ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; push esi
    ; mov esi, memdup_entry
    ; call write_buffer
    ; pop esi

    ; call dump_xbytes_big_endian
    mov eax, dword [esi]
    call write_in_correct_size


    mov ah, [global_color]
    push esi

    mov esi, 18 - 2
    sub esi, dword [bindec_wrote]
    mov al, 32
    .fill:
        call write_char
        inc word [cursor]
        dec esi
        test esi, esi
        jnz .fill

    pop esi
    add esi, 8
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;                           ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    

    push esi
    mov esi, memmory_between_msg
    call write_buffer
    pop esi

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;          Type             ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov eax, dword [esi]
    push esi
    mov esi, dword [memmory_types_table+eax*4]
    mov ah, byte [global_color]
    call write_buffer


    pop esi
    add esi, 4
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;                           ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;    ACPI 3.0 (not used)    ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    add esi, 4
    call new_line
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;                           ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    

    dec cx
    jmp .loop


.after:

    call new_line
    mov esi, memdump_total_mem_msg
    call write_buffer
    mov eax, dword [avaliable_ram]
    inc eax
    call write_in_correct_size
    call new_line

    mov ah, [global_color]
    mov esi, memdump_total_page_msg
    call write_buffer
    mov eax, dword [max_page_count]
    call binary_decimal
    call new_line

    call new_line

    pop eax
    pop edx
    pop ecx
    pop esi
    ret

calculate_ram:
    mov esi, memmory_table
.loop:
    cmp esi, memmory_table_end
    jge .after

    add esi, 24

    cmp dword [esi-4-4], 1
    jne .loop

    mov eax, dword [esi-4-4-8]
    add dword [avaliable_ram], eax
    jmp .loop
.after:
    ret

avaliable_ram: dd 0

setup_physical_alloc:
    push edi
    push esi
    push edx
    push ecx

    mov esi, memmory_table
    mov edi, 0
.loop:

    mov eax, dword [esi]
    cmp eax, 0x100000
    je .found_entry

    add esi, 8
    add esi, 8
    add esi, 4
    add esi, 4

    inc edi
    cmp edi, memmory_table_count
    je .after
    jmp .loop

.found_entry:
    add esi, 8
    mov eax, dword [esi]
    mov edx, 0
    mov ecx, 4096
    div ecx
    mov dword [max_page_count], eax
.after:

    pop ecx
    pop edx
    pop esi
    pop edi
    ret

max_page_count: dd 0

pages_bitmap: times 131072 db 0