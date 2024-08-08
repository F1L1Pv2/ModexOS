include "ints_exceptions.asm"
include "syscalls.asm"

idt:
    include "interrupts.asm"

idt_descriptor:
    .size:      dw idt_descriptor-idt-1
    .offset:    dd idt