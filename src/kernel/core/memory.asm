use32

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
memdump_kernel_size_msg: db "Kernel size: ",0
memdump_kernel_size_pages_msg: db "Kernel size (pages): ",0

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
    push esi
    push ecx
    push edx
    push eax

    mov esi, memdup_top_msg
    call write_buffer

    mov esi, dword [memmory_table_ptr]
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
    mov esi, memdump_kernel_size_msg
    call write_buffer
    mov eax, dword [kernel_size_in_bytes]
    call write_in_correct_size
    call new_line

    mov ah, [global_color]
    mov esi, memdump_kernel_size_pages_msg
    call write_buffer
    mov eax, dword [kernel_use_page_count]
    call binary_decimal
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
    mov esi, dword [memmory_table_ptr]
.loop:
    cmp esi, dword [memmory_table_end_ptr]
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

    mov esi, dword [memmory_table_ptr]
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

    ;calculate membit table byte size
    mov eax, dword [max_page_count] ;allocating bits for bit_map
    mov edx, 0
    mov ecx, 8
    div ecx
    call round_up
    mov dword [membit_table_size_bytes], eax

    ;calculate how much kernel uses pages
    mov eax, dword [kernel_size_in_bytes]
    mov edx, 0
    mov ecx, 4096
    div ecx
    call round_up
    mov dword [kernel_use_page_count], eax

    ;calculate  how many pages will be allocated at the start of running kernel
    mov eax, dword [kernel_size_in_bytes]
    add eax, dword [membit_table_size_bytes]
    mov edx, 0
    mov ecx, 4096
    div ecx
    call round_up
    mov dword [initial_allocated_pages], eax

    ;allocate initial pages
    xor edx, edx
    mov eax, dword [initial_allocated_pages]
    cmp eax, 8
    jge .more_than_byte

.less_than_byte:
    mov al, dl
    call fill_bits
    mov [memmory_bit_map], al
    jmp .exit


.more_than_byte:
    mov ecx, 8
    div ecx
    push edx
    mov esi, memmory_bit_map
.alloc_loop:
    mov byte [esi], 0xFF
    inc esi
    dec eax
    jnz .alloc_loop

    pop edx
    mov eax, edx
    call fill_bits
    mov byte [esi], al
.exit:
    pop ecx
    pop edx
    pop esi
    pop edi
    ret

alloc_page:
    ;output in esi adress
    push eax
    push ebx
    push ecx
    push edx

    xor edx, edx
.iter_bytes:
    cmp edx, dword [membit_table_size_bytes]
    jge .not_enough_memmory

    xor ecx, ecx
    .iter_bits:
        cmp ecx, 8
        jge .after_bits

        mov al, byte [memmory_bit_map+edx]

        mov bl, 10000000b
        shr bl, cl
        
        and al, bl
        jz .found_free

        inc ecx
        jmp .iter_bits
    .after_bits:

    inc edx
    jmp .iter_bytes

.found_free:
    
    ; allocating free page
    mov al, byte [memmory_bit_map+edx]
    mov bl, 10000000b
    shr bl, cl
    or al, bl
    mov byte [memmory_bit_map+edx], al

    ; mov eax, edx
    ; call binary_decimal
    ; call new_line
    ; mov eax, ecx
    ; call binary_decimal
    ; call new_line
    mov ebx, ecx

    mov eax, edx
    xor edx, edx
    mov ecx, 8
    mul ecx

    add eax, ebx

    mov ecx, 4096
    mul ecx
    add eax, 0x100000 + 0xC0000000
    mov esi, eax

    jmp .after
.not_enough_memmory:
    mov esi, not_enough_memmory_msg
    call panic
.after:

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

free_page:
    ; input in esi address
    push eax
    push ebx
    push ecx
    push edx

    mov eax, esi
    sub eax, 0x100000 + 0xC0000000
    xor edx, edx
    mov ecx, 4096
    div ecx
    cmp edx, 0
    jnz .not_page_aligned

    mov ecx, 8
    div ecx

    mov ecx, edx
    mov edx, eax

    mov al, byte [memmory_bit_map+edx]
    mov bl, 10000000b
    shr bl, cl
    not bl
    and al, bl
    mov byte [memmory_bit_map+edx], al

    jmp .after
.not_page_aligned:
    mov esi, not_page_aligned_msg
    call panic
.after:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

not_enough_memmory_msg: db "Not enough memmory. Buy more RAM lol",0
not_page_aligned_msg: db "This address is not page aligned (aligned to 4kb)",0

max_page_count: dd 0
page_table_size: dd 0
kernel_use_page_count: dd 0
membit_table_size_bytes: dd 0
initial_allocated_pages: dd 0