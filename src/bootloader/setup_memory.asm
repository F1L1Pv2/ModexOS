use16

mmap_ent equ memmory_table_count             ; the number of entries will be stored at 0x8000
do_e820:
    mov ax, 0x2000
    mov es, ax
    mov di, (memmory_table and 0xFFFF)          ; Set di to 0x8004. Otherwise this code will get stuck in `int 0x15` after some entries are fetched 
	xor ebx, ebx		; ebx must be 0 to start
	xor bp, bp		; keep an entry count in bp
	mov edx, 0x0534D4150	; Place "SMAP" into edx
	mov eax, 0xe820
	mov [es:di + 20], dword 1	; force a valid ACPI 3.X entry
	mov ecx, 24		; ask for 24 bytes
	int 0x15
	jc short (.failed and 0xFFFF)	; carry set on first call means "unsupported function"
	mov edx, 0x0534D4150	; Some BIOSes apparently trash this register?
	cmp eax, edx		; on success, eax must have been reset to "SMAP"
	jne short (.failed and 0xFFFF)
	test ebx, ebx		; ebx = 0 implies list is only 1 entry long (worthless)
	je short (.failed and 0xFFFF)
	jmp short (.jmpin and 0xFFFF)
.e820lp:
	mov eax, 0xe820		; eax, ecx get trashed on every int 0x15 call
	mov [es:di + 20], dword 1	; force a valid ACPI 3.X entry
	mov ecx, 24		; ask for 24 bytes again
	int 0x15
	jc short (.e820f and 0xFFFF)		; carry set means "end of list already reached"
	mov edx, 0x0534D4150	; repair potentially trashed register
.jmpin:
	jcxz (.skipent and 0xFFFF)		; skip any 0 length entries
	cmp cl, 20		; got a 24 byte ACPI 3.X response?
	jbe short (.notext and 0xFFFF)
	test byte [es:di + 20], 1	; if so: is the "ignore this data" bit clear?
	je short (.skipent and 0xFFFF)
.notext:
	mov ecx, [es:di + 8]	; get lower uint32_t of memory region length
	or ecx, [es:di + 12]	; "or" it with upper uint32_t to test for zero
	jz (.skipent and 0xFFFF)		; if length uint64_t is 0, skip entry
	inc bp			; got a good entry: ++count, move to next storage spot
	add di, 24
.skipent:
	test ebx, ebx		; if ebx resets to 0, list is complete
	jne short (.e820lp and 0xFFFF)
.e820f:
	mov [(mmap_ent and 0xFFFF)], bp	; store the entry count
	clc			; there is "jc" on end of list to this point, so the carry must be cleared
	ret
.failed:
	stc			; "function unsupported" error exit
	ret

; memmory_table equ 0x20000 - 20*24

memmory_table: times 20*24 db 0
memmory_table_len equ ($-memmory_table)
memmory_table_end equ $

memmory_table_count: dw 0