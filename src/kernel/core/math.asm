; math_power:
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     ;; funkcja potegowania (32-bits) ;;
;     ;;       EBX to wykladnik        ;;
;     ;;   EAX to podstawa / output    ;;
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;     push ebx
;     push ecx
;     push edx

;     mov ecx, 1

; .loop:
;     test ecx, ecx
;     jnz .after_loop

;     push eax
;     mov eax, 2
;     xor edx, edx
;     div ebx
;     mov ebx, eax
;     pop eax

;     push eax

;     dec edx
;     jnz .is_false

;     mul ecx
;     mov ecx, eax

; .is_false:
;     pop eax

;     mul eax

;     jmp .loop
; .after_loop:

;     mov eax, ecx

;     pop edx
;     pop ecx
;     pop ebx

;     ret


math_power:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja potegowania (32-bits) ;;
    ;;       EBX to wykladnik        ;;
    ;;   EAX to podstawa / output    ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push ebx
    push ecx
    push edx

    mov ecx, eax
    xor eax, eax

    cmp ebx, 0
    jl .after_loop

    mov eax, 1

.loop:
    test ebx, ebx
    jz .after_loop

    mul ecx

    dec ebx
    jmp .loop
.after_loop:

    pop edx
    pop ecx
    pop ebx

    ret

; math_power:
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     ;; funkcja potegowania (32-bits) ;;
;     ;;       EBX to wykladnik        ;;
;     ;;   EAX to podstawa / output    ;;
;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;     push ebx
;     push ecx
;     push edx

;     mov ecx, eax     ; copy base to ecx
;     mov edx, ebx     ; copy exponent to edx
;     mov ebx, 1       ; result initialized to 1

;     .loop:
;         test edx, edx    ; check if exponent is zero
;         jz .done

;         test edx, 1      ; check if exponent is odd
;         jz .even

;         mul ecx          ; multiply result by current base
;         dec edx          ; decrement exponent

;     .even:
;         imul ecx, ecx    ; square the base
;         shr edx, 1       ; divide exponent by 2

;         jmp .loop

;     .done:
;         mov eax, ebx     ; move result to eax

;     pop edx
;     pop ecx
;     pop ebx

;     ret

math_sqrt:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; funkcja pierwiastkowania (32-bits) ;;
    ;;                                    ;;
    ;;                                    ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ret