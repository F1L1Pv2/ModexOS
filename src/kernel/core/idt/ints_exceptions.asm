
ints:

.non:
    iret

.division_error:
    mov esi, division_error_msg
    call panic

.debug:
    mov esi, debug_error_msg
    call panic
    iret

.non_maskable_interrupt:
    mov esi, non_maskable_interrupt_error_msg
    call panic
    iret

.breakpoint:
    mov esi, breakpoint_error_msg
    call panic
    iret

.overflow:
    push esi

    mov esi, overflow_error_msg
    call write_buffer

    pop esi

    ; mov esi, overflow_error_msg
    ; call panic
    iret

.bound_range_exceeded:
    mov esi, bound_range_exceeded_error_msg
    call panic
    iret

.invalid_opcode:
    mov esi, invalid_opcode_error_msg
    call panic
    iret

.device_not_available:
    mov esi, device_not_available_error_msg
    call panic
    iret

.double_fault:
    mov esi, double_fault_error_msg
    call panic
    iret

.invalid_tss:
    mov esi, invalid_tss_error_msg
    call panic
    iret

.segment_not_present:
    mov esi, segment_not_present_error_msg
    call panic
    iret

.stack_segment_fault:
    mov esi, stack_segment_fault_error_msg
    call panic
    iret

.general_protection_fault:
    mov esi, general_protection_fault_error_msg
    call panic
    iret

.page_fault:
    mov esi, page_fault_error_msg
    call panic
    iret

.x87_floating_point_exception:
    mov esi, x87_floating_point_exception_error_msg
    call panic
    iret

.alignment_check:
    mov esi, alignment_check_error_msg
    call panic
    iret

.machine_check:
    mov esi, machine_check_error_msg
    call panic
    iret

.simd_floating_point_exception:
    mov esi, simd_floating_point_exception_error_msg
    call panic
    iret

.virtualization_exception:
    mov esi, virtualization_exception_error_msg
    call panic
    iret

.control_protection_exception:
    mov esi, control_protection_exception_error_msg
    call panic
    iret

.hypervisor_injection_exception:
    mov esi, hypervisor_injection_exception_error_msg
    call panic
    iret

.vmm_communication_exception:
    mov esi, vmm_communication_exception_error_msg
    call panic
    iret

.security_exception:
    mov esi, security_exception_error_msg
    call panic
    iret

division_error_msg:                         db "Division by zero exception",10, 0
debug_error_msg:                            db "Debug",10, 0
non_maskable_interrupt_error_msg:           db "",10, 0
breakpoint_error_msg:                       db "Overf",10, 0
overflow_error_msg:                         db 255,0x0c,"OverFlow!",10, 0
bound_range_exceeded_error_msg:             db "",10, 0
invalid_opcode_error_msg:                   db "",10, 0
device_not_available_error_msg:             db "",10, 0
double_fault_error_msg:                     db "",10, 0
invalid_tss_error_msg:                      db "",10, 0
segment_not_present_error_msg:              db "",10, 0
stack_segment_fault_error_msg:              db "",10, 0
general_protection_fault_error_msg:         db "",10, 0
page_fault_error_msg:                       db "",10, 0
x87_floating_point_exception_error_msg:     db "",10, 0
alignment_check_error_msg:                  db "",10, 0
machine_check_error_msg:                    db "",10, 0
simd_floating_point_exception_error_msg:    db "",10, 0
virtualization_exception_error_msg:         db "",10, 0
control_protection_exception_error_msg:     db "",10, 0
hypervisor_injection_exception_error_msg:   db "",10, 0
vmm_communication_exception_error_msg:      db "",10, 0
security_exception_error_msg:               db "",10, 0