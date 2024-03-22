; 0x    00        00         00        00
; 0b (00000000 00)(000000 0000)0000 00000000
;      PD index     PT index     PT offset

; 0x       C0      00        00        00
; 0b   1100 0000  00 

; 1111 1111 1111 1111 1111 0000 0000 0000
;  F    F    F    F    F    0     0    0
; 0xFFFFF000

virtual_memory_init:
    call alloc_page
    mov dword [page_directory], esi

    mov edi, esi
    add edi, 4096

.loop1:
    cmp esi, edi
    jge .after1

    or dword [esi], 2

    add esi, 4
    jmp .loop1
.after1:

    call alloc_page
    mov dword [page_table], esi

    ; mov edi, esi
    ; add edi, 4096
    mov ecx, 0
    
.loop2:
    cmp ecx, 1024
    jge .after2

    xor edx, edx
    mov eax, 4096
    mul ecx

    or eax, 3

    mov [esi+ecx*4], eax

    inc ecx
    jmp .loop2
.after2:

    mov esi, dword [page_directory]
    mov edi, dword [page_table]
    sub edi, 0xC0000000
    or edi, 3
    mov [esi], edi
    mov [esi+768*4], edi

    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax

    jmp 0x08:(.normal_addr - 0xC0000000)


.normal_addr:

    mov eax, dword [(page_directory - 0xC0000000)]
    sub eax, 0xC0000000
    mov cr3, eax

    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax

    jmp 0x08:.after_paging

.after_paging:

    ;getting rid of 0x00000000 map (cuz its useless)
    mov esi, dword [page_directory]
    mov dword [esi], 2

    ret

map_physical_to_virtual:
    ; esi physical page addr
    ; edi virtual page addr
   
    ;; TODO create this function

    ret


page_directory: dd 0
page_table: dd 0