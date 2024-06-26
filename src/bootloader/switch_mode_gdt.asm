switching:
cli
in al, 0x92
test al, 2
jnz (.after and 0xFFFF)
or al, 2
and al, 0xFE
out 0x92, al
.after:
lgdt [(g_GDTDesc and 0xFFFF)]

mov eax, cr0
or eax, 1

mov cr0, eax


jmp pword 0x8:main

g_GDT:      ; NULL descriptor
            dq 0

            ; 32-bit code segment
            dw 0FFFFh                               ; limit (bits 0-15) = 0xFFFFF for full 32-bit range
            dw (0 and 0xFFFF)                       ; base (bits 0-15) = 0x0
            db ((0 shr 16) and 0xFF)                ; base (bits 16-23)
            db 10011010b                            ; access (present, ring 0, code segment, executable, direction 0, readable)
            db 11001111b                            ; granularity (4k pages, 32-bit pmode) + limit (bits 16-19)
            db ((0 shr 24) and 0xFF)                ; base high

            ; 32-bit data segment
            dw 0FFFFh                               ; limit (bits 0-15) = 0xFFFFF for full 32-bit range
            dw (0 and 0xFFFF)                       ; base (bits 0-15) = 0x0
            db ((0 shr 16) and 0xFF)                ; base (bits 16-23)
            db 10010010b                            ; access (present, ring 0, data segment, executable, direction 0, writable)
            db 11001111b                            ; granularity (4k pages, 32-bit pmode) + limit (bits 16-19)
            db ((0 shr 24) and 0xFF)                ; base high

            ; Pre virtual memory

            ; 32-bit code segment
            dw 0FFFFh                               ; limit (bits 0-15) = 0xFFFFF for full 32-bit range
            dw (0x40000000 and 0xFFFF)              ; base (bits 0-15) = 0x0
            db ((0x40000000 shr 16) and 0xFF)       ; base (bits 16-23)
            db 10011010b                            ; access (present, ring 0, code segment, executable, direction 0, readable)
            db 11001111b                            ; granularity (4k pages, 32-bit pmode) + limit (bits 16-19)
            db ((0x40000000 shr 24) and 0xFF)       ; base high

            ; 32-bit data segment
            dw 0FFFFh                               ; limit (bits 0-15) = 0xFFFFF for full 32-bit range
            dw (0x40000000 and 0xFFFF)              ; base (bits 0-15) = 0x0
            db ((0x40000000 shr 16) and 0xFF)       ; base (bits 16-23)
            db 10010010b                            ; access (present, ring 0, data segment, executable, direction 0, writable)
            db 11001111b                            ; granularity (4k pages, 32-bit pmode) + limit (bits 16-19)
            db ((0x40000000 shr 24) and 0xFF)       ; base high

g_GDTDesc:  dw g_GDTDesc - g_GDT - 1    ; limit = size of GDT
            dd g_GDT                    ; address of GDT
