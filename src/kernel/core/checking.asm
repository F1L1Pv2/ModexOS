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


if_ascii_number:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja sprawdzania znakow innych niz cyfra w tablicy ;;
    ;;       ESI to informacja o poczatkowym adresie         ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push esi
    push ebx
    push edx

    mov ebx, esi

    xor esi, esi

    mov dl, byte [ebx] 
    cmp dl, 45
    jne .loop

    inc ebx

.loop:
    mov dl, byte [ebx+esi]
    inc esi

    test dl, dl
    jz .valid

    cmp dl, 48
    jl .exit ; Invalid number
    cmp dl, 57
    jg .exit ; Invalid number

    jmp .loop

.valid:
    xor esi, esi

.exit:
    ; cmp dl, 45
    ; je .valid ; valid number

    test esi, esi

    pop edx
    pop ebx
    pop esi
    ret