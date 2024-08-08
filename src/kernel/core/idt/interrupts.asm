idt_interrupt0:          ; Division Error
    .low_offset:         dw (ints.division_error and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.division_error shr 16)

idt_interrupt1:          ; Debug
    .low_offset:         dw (ints.debug and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.debug shr 16)

idt_interrupt2:          ; Non-maskable Interrupt
    .low_offset:         dw (ints.non_maskable_interrupt and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.non_maskable_interrupt shr 16)

idt_interrupt3:          ; Breakpoint
    .low_offset:         dw (ints.breakpoint and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.breakpoint shr 16)

idt_interrupt4:          ; Overflow
    .low_offset:         dw (ints.overflow and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.overflow shr 16)

idt_interrupt5:          ; Bound Range Exceeded
    .low_offset:         dw (ints.bound_range_exceeded and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.bound_range_exceeded shr 16)

idt_interrupt6:          ; Invalid Opcode 
    .low_offset:         dw (ints.invalid_opcode and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.invalid_opcode shr 16)

idt_interrupt7:          ; Device Not Available 
    .low_offset:         dw (ints.device_not_available and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.device_not_available shr 16)

idt_interrupt8:          ; Double Fault 
    .low_offset:         dw (ints.double_fault and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.double_fault shr 16)

idt_interrupt9:          ; Coprocessor Segment Overrun OLD
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt10:         ;  Invalid TSS 
    .low_offset:         dw (ints.invalid_tss and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.invalid_tss shr 16)

idt_interrupt11:         ; Segment Not Present 
    .low_offset:         dw (ints.segment_not_present and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.segment_not_present shr 16)

idt_interrupt12:         ; Stack-Segment Fault 
    .low_offset:         dw (ints.stack_segment_fault and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.stack_segment_fault shr 16)

 
idt_interrupt13:         ; General Protection Fault 
    .low_offset:         dw (ints.general_protection_fault and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.general_protection_fault shr 16)

idt_interrupt14:         ; Page Fault 
    .low_offset:         dw (ints.page_fault and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.page_fault shr 16)

idt_interrupt15:         ; Reserved
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt16:         ; x87 Floating-Point Exception 
    .low_offset:         dw (ints.x87_floating_point_exception and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.x87_floating_point_exception shr 16)

idt_interrupt17:         ; Alignment Check 
    .low_offset:         dw (ints.alignment_check and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.alignment_check shr 16)

idt_interrupt18:         ; Machine Check 
    .low_offset:         dw (ints.machine_check and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.machine_check shr 16)

idt_interrupt19:         ; SIMD Floating-Point Exception 
    .low_offset:         dw (ints.simd_floating_point_exception and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.simd_floating_point_exception shr 16)

idt_interrupt20:         ; Virtualization Exception 
    .low_offset:         dw (ints.virtualization_exception and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.virtualization_exception shr 16)

idt_interrupt21:         ; Control Protection Exception 
    .low_offset:         dw (ints.control_protection_exception and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.control_protection_exception shr 16)


idt_interrupt22:         ; Reserved
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt23:         ; Reserved
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt24:         ; Reserved
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt25:         ; Reserved
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt26:         ; Reserved
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt27:         ; Reserved
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt28:         ; Hypervisor Injection Exception 
    .low_offset:         dw (ints.hypervisor_injection_exception and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.hypervisor_injection_exception shr 16)

idt_interrupt29:         ; VMM Communication Exception 
    .low_offset:         dw (ints.vmm_communication_exception and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.vmm_communication_exception shr 16)

idt_interrupt30:         ; Security Exception 
    .low_offset:         dw (ints.security_exception and 0xffff)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101111b ; Trap
    .high_offset:        dw (ints.security_exception shr 16)

idt_interrupt31:         ; Reserved
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt32:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt33:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt34:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt35:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt36:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt37:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt38:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt39:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt40:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt41:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt42:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt43:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt44:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt45:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt46:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt47:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt48:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt49:         ;
    .low_offset:         dw (pic_ints.default_response and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (pic_ints.default_response shr 16)

idt_interrupt50:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt51:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt52:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt53:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt54:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt55:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt56:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt57:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt58:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt59:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt60:         ; Test interrupt
    .low_offset:         dw (int_test and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (int_test shr 16)

idt_interrupt61:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt62:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt63:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt64:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt65:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt66:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt67:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt68:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt69:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt70:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt71:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt72:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt73:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt74:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt75:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt76:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt77:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt78:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt79:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt80:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt81:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt82:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt83:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt84:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt85:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt86:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt87:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt88:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt89:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt90:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt91:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt92:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt93:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt94:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt95:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt96:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt97:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt98:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt99:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt100:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt101:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt102:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt103:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt104:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt105:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt106:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt107:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt108:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt109:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt110:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt111:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt112:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt113:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt114:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt115:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt116:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt117:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt118:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt119:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt120:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt121:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt122:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt123:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt124:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt125:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt126:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt127:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt128:        ; syscall!
    .low_offset:         dw (syscall_handler and 0xFFFF)
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 11101110b
    .high_offset:        dw (syscall_handler shr 16)

idt_interrupt129:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt130:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt131:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt132:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt133:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt134:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt135:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt136:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt137:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt138:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt139:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt140:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt141:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt142:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt143:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt144:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt145:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt146:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt147:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt148:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt149:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt150:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt151:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt152:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt153:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt154:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt155:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt156:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt157:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt158:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt159:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt160:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt161:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt162:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt163:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt164:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt165:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt166:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt167:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt168:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt169:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt170:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt171:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt172:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt173:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt174:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt175:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt176:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt177:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt178:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt179:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt180:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt181:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt182:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt183:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt184:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt185:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt186:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt187:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt188:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt189:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt190:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt191:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt192:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt193:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt194:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt195:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt196:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt197:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt198:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt199:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt200:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt201:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt202:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt203:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt204:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt205:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt206:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt207:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt208:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt209:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt210:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt211:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt212:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt213:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt214:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt215:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt216:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt217:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt218:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt219:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt220:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt221:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt222:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt223:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt224:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt225:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt226:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt227:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt228:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt229:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt230:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt231:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt232:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt233:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt234:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt235:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt236:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt237:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt238:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt239:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt240:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt241:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt242:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt243:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt244:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt245:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt246:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt247:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt248:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt249:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt250:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt251:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt252:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt253:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt254:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0

idt_interrupt255:
    .low_offset:         dw 0
    .segment_selector:   dw 0x8
    .reserved:           db 0
    .flags:              db 0
    .high_offset:        dw 0