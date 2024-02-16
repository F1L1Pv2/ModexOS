%define VIDEO_MODE 3

clear_buffer:
    ; input buffer in bx
    ; buffer len in dx
    push dx
    push bx

.loop:

    cmp dx, 0
    je .exit

    mov byte [bx],  byte 0

    dec dx
    inc bx

    jmp .loop
.exit:

    pop bx
    pop dx
    ret

read_buffer:
    ; input buffer in bx
    ; buffer len in dx
    push ax
    push cx
    push dx
    push bx
.loop:
    ; capturing character
    mov ah, 0
    int 0x16
    ; capturing character

    ; handling other character
    push ax
    cmp ah, 0x48
    jz .block
    cmp ah, 0x4D
    jz .block
    cmp ah, 0x4B
    jz .block
    cmp ah, 0x50
    jz .block

    cmp al, 0x0a
    jnz .ctrl_j
    cmp ah, 0x24
    jz .block
    .ctrl_j:

    cmp al, 0x07
    jnz .ctrl_g
    cmp ah, 0x22
    jz .block
    .ctrl_g:
    pop ax
    ; handling other character

    ; handling enter
    cmp ah, 28
    je .exit
    ; handling enter

    pop cx
    push cx
    add cx, dx

    ; handling backspace
    cmp al, 8
    je .backward
    ; handling backspace

    cmp bx, cx
    jge .loop

    call write_char

    mov [bx], al
    inc bx

    jmp .loop

.backward:
    pop cx
    cmp bx, cx
    push cx
    jng .exit_back
    dec bx
    mov byte [bx], 0
    mov al, 8
    call write_char
    mov al, 32
    call write_char
    mov al, 8
    call write_char
    .exit_back:
    jmp .loop

.block:
    jmp .loop

.exit:
    pop bx
    pop dx
    pop cx
    pop ax
    ret


write_buffer:
    push ax
    push bx
    push si
    ; input buffer in bx
    mov si, bx
    cld
.loop:
    lodsb
    test al, al
    jz .exit
    call write_char

    jmp .loop
.exit:
    pop si
    pop bx
    pop ax
    ret

cmp_str:
    ; first string address in bx
    ; second string address in dx
    ;

    push ax
    push bx
    push dx

.loop:
    mov al, byte [bx]
    push bx
    mov bx, dx
    mov ah, byte [bx]
    pop bx

    cmp ah, al
    jne .exit

    cmp al, 0
    je .exit

    inc bx
    inc dx

    jmp .loop
.exit:

    pop dx
    pop bx
    pop ax
    ret

write_char:
    push ax

    mov ah, 0x0e
    int 0x10

    pop ax
    ret

cls:
    push ax
    mov ah, 0
    mov al, VIDEO_MODE
    int 0x10
    pop ax
    ret

new_line:
    push ax
    mov al, 10
    call write_char
    mov al, 13
    call write_char
    pop ax
    ret

say:
    mov bx, command
    mov dx, command_len

    ; call new_line

    call clear_buffer
    call read_buffer

    call new_line
    call new_line
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  ||         modifications made by RILAX         ||  ;;;
;;;  \/  minor additions to the core of the system  \/  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

space:
    push ax
    mov al, ' '
    call write_char
    pop ax
    ret

shutdown: ; nie dziala dobrze!
    mov ax, 0x1000
    mov ax, ss
    mov sp, 0xf000
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15

    call error

    mov eax, 0xE820
    int 0x15

    call fatal_error ; if interrupt doesnt work
    ret              ; if interrupt doesnt work

error: 
    push bx

    call new_line
    mov bx, error_msg
    call write_buffer
    call new_line

    inc bx
    test bx, bx

    pop bx
    ret
    error_msg: db "Error!", 0

fatal_error: 
    call new_line
    mov bx, fatal_error_msg
    call write_buffer
    call new_line

    mov bx, fatal_error_info_msg
    call write_buffer
    call new_line

.loop
    jmp .loop
    fatal_error_msg: db "!!! Fatal error !!!", 0
    fatal_error_info_msg: db "Restart your computer, click Ctrl+Alt+Del or turn off.", 0

date_time:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja wyswiatlania obecnego czasu i daty ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push ax
    push cx
    push dx

    mov ah, 0x02 ;; Time ;;
    int 0x1a     ;; Time ;;

    mov al, ch
    call print_bcd

    mov al, ':'
    call write_char

    mov al, cl
    call print_bcd

    mov al, ':'
    call write_char

    mov al, dh
    call print_bcd

    mov al, ' '
    call write_char
    mov al, '/' 
    call write_char
    mov al, ' '
    call write_char

    mov ah, 0x04 ;; Date ;;
    int 0x1a     ;; Date ;;

    mov al, dl
    call print_bcd

    mov al, '.'
    call write_char

    mov al, dh
    call print_bcd

    mov al, '.'
    call write_char

    mov al, ch
    call print_bcd
    mov al, cl
    call print_bcd

    call new_line

    pop dx
    pop cx
    pop ax

    ret

print_bcd:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;     funkcja bin to bcd z print (8-bits)     ;;
    ;;               (AX -> 2x4 bits)              ;;
    ;;                 AX to wejsce                ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push ax

    push ax

    shr al, 4
    add al, 48

    call write_char

    pop ax

    shl al, 4
    shr al, 4
    add al, 48

    call write_char

    pop ax

    ret

binary_decimal:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja binary to decimal (16-bits) ;;
    ;;           AX to wejsce              ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push dx
    push cx
    push bx
    push ax

    xor bx, bx

.loop:
    xor dx, dx
    mov cx, 10
    div cx
    mov cx, ax

    mov al, dl
    add al, 48
    push ax

    mov ax, cx

    inc bx

    test cx, cx
    jnz .loop

.flip:
    pop ax
    call write_char

    dec bx
    jnz .flip

    pop ax
    pop bx
    pop cx
    pop dx

    ret

decimal_binary:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;   funkcja decimal to binary (16-bits)  ;;
    ;; BX to informacja o poczatkowym adresie ;;
    ;;              AX to output              ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    call flip_bytes_table

    push si
    push dx
    push bx


    xor si, si
    xor dx, dx

.loop:
    mov dl, byte [bx+si]
    push dx
    inc si

    test dl, dl
    jnz .loop

    pop ax ; usuwanie null z konca string'a
    dec si
    xor dx, dx

.loop2:
    mov ax, 10
    mov bx, si
    dec bx
    call power

    pop bx
    sub bx, 48
    push dx
    xor dx, dx
    mul bx
    pop dx

    add dx, ax

    dec si
    jnz .loop2

    mov ax, dx


    pop bx
    pop dx
    pop si

    call flip_bytes_table

    ret

power:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja potegowania (16-bits) ;;
    ;;        BX to wykladnik        ;;
    ;;    AX to podstawa / output    ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push bx
    push cx 
    push dx ; ax (low), dx (hight)

    mov cx, ax
    mov ax, 1

    test bx, bx
    jz .sum_one

.loop:
    mul cx

    dec bx
    jnz .loop

.sum_one:

    pop dx
    pop cx
    pop bx

    ret

flip_bytes_table:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;       funkcja ktora obraca bytes w tablicy        ;;
    ;;      BX to informacja o poczatkowym adresie       ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push si
    push dx
    push bx

    xor si, si
    push si ; 0 ktore mowi gdzie konczy sie bytes table

.loop:
    mov dl, byte [bx+si]
    push dx
    inc si

    test dl, dl
    jnz .loop

    pop si ; usuwanie 0 z poczatku tablicy
    xor si, si

.loop2:
    pop dx
    mov byte [bx+si], dl
    inc si

    test dl, dl
    jnz .loop2

    pop bx
    pop dx
    pop si

    ret

if_ascii_number:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja sprawdzania znakow innych niz cyfra w tablicy ;;
    ;;        BX to informacja o poczatkowym adresie         ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push si
    push bx
    push dx

    xor si, si

.loop:
    mov dl, byte [bx+si]
    inc si

    test dl, dl
    jz .valid

    cmp dl, 48
    jl .exit ; Invalid number
    cmp dl, 57
    jg .exit ; Invalid number

    jmp .loop

.valid:
    xor si, si

.exit:
    test si, si

    pop dx
    pop bx
    pop si
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  \/  include drivers  \/  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%include "drivers/file_sys.asm" ; File system driver

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  /\  include drivers  /\  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  \/  include programs  \/  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%include "drivers/programs/calculator.asm" ; Calculator
%include "drivers/programs/test.asm"       ; Test (tests core fn. and more) 
%include "drivers/programs/valentine.asm"  ; <333

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  /\  include programs  /\  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

exit_core:
call fatal_error