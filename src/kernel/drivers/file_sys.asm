file_sys:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;                                                       ;;
    ;;                                                       ;;
    ;;                                                       ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push bx
    push cx
    push dx
    push si

    xor dx, dx ; dx = 0
    ; xor bx, bx ; bx = 0

    ; mov ax, 36 ; ax = 1007 ; TESTS
    ; inc ax
    call lba_chs ; lba to chs (input in *ax*, output in *bx.ch.cl*)
    call test_file_sys ; TESTS
    
    pop si
    pop dx
    pop cx
    pop bx
    ret

fat16:
    ret

lba_chs: ; lba to chs
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ; BX - S
    ;;   funkcja lba to chs    ;; ; CH - H
    ;;    AX to wejscie lba    ;; ; CL - S
    ;;  BX i CX to wyjscie chs ;;  
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ; BX.CH.CL

    push ax ; ax save
    call disk_info
    pop ax  ; ax restore

    push ax ; ax save 
    xor ax, ax                ; ax = 0
    mov al, byte [head_num]   ; al = head number (byte)
    mul byte [sector_num]     ; ax = al * sector number (byte)
    mov cx, ax                ; cx = ax
    pop ax  ; ax restore

    push ax ; ax save 
    push dx ; dx save 
    xor dx, dx                ; dx = 0
    div cx                    ; ax = ax / cx
    mov bx, ax                ; bx = ax
    pop dx  ; dx restore
    pop ax  ; ax restore

    push ax ; ax save
    push cx ; cx save
    push dx ; dx save                   
    xor dx, dx                ; dx = 0
    xor cx, cx                ; cx = 0
    mov cl, byte [sector_num] ; 
    div cx                    ; al = ax / cx
                              ; dx = ax % cx
    pop cx  ; cx restore

    inc dl                    ; dl++
    mov cl, dl                ; cl = dl
    pop dx  ; dx restore

    push dx ; dx save 
    push cx ; cx save 
    xor cx, cx                ; cx = 0
    xor dx, dx                ; dx = 0
    mov cl, byte [head_num]   ; cl = head number (byte)
    div cx                    ; dl = al % cx
    pop cx  ; cx restore

    mov ch, dl                ; ch = dl
    pop dx  ; dx restore
    pop ax  ; ax restore
    ret

disk_info:
    mov ah, 0x08 ; bios interrupt disk info
    int 0x13

    mov byte [cylinder_num], ch ; wpis do byte table (ktora przechowuje info o dysku)
    mov byte [sector_num],   cl
    inc dh
    mov byte [head_num],     dh
    mov dl, byte [disk_num]

    call test_file_sys2
    ret

test_file_sys2:
    xor ax, ax
    mov al, byte [cylinder_num]
    call binary_decimal
    call space
    mov al, byte [sector_num]
    call binary_decimal
    call space
    mov al, byte [head_num]
    call binary_decimal
    call space
    mov al, byte [disk_num]
    call binary_decimal
    call new_line
    call new_line
    ret

test_file_sys:
    mov ax, bx
    call binary_decimal
    mov al, '.'
    call write_char
    xor ax, ax
    mov al, ch
    call binary_decimal
    mov al, '.'
    call write_char
    xor ax, ax
    mov al, cl
    call binary_decimal
    ret

call fatal_error