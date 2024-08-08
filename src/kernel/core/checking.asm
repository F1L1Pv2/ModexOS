cmp_str:
    ; first string address in bx
    ; second string address in dx
    push eax
    push esi
    push edi

.loop:
    mov al, byte [esi]
    mov ah, byte [edi]

    cmp ah, al
    jne .exit

    cmp al, 0
    je .exit

    inc esi
    inc edi

    jmp .loop
.exit:

    pop edi
    pop esi
    pop eax
    ret

; cmp_cmd:
;     ; first cmd address in esi
;     ; second cmd address in edi
;     push eax
;     push esi
;     push edi

; .loop:
;     mov al, byte [esi]
;     mov ah, byte [edi]

;     cmp al, 32
;     jz .args

;     cmp al, ah
;     jne .exit

;     cmp al, 0
;     je .exit

;     inc esi
;     inc edi

;     jmp .loop

; .args:
;     mov edi, dword [args_buffer_offset]
;     inc esi

;     mov al, byte [esi]

;     cmp al, 0
;     jz .exit

;     cmp al, 32
;     jz .args

;     cmp al, 10
;     jz .args
; .args_loop:
;     mov al, byte [esi]
;     mov byte [edi], al

;     cmp al, 0
;     jz .exit

;     inc esi
;     inc edi

;     jmp .args_loop

; .exit:
;     pop edi
;     pop esi
;     pop eax
;     ret