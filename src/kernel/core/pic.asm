PIC1            equ 0x20	; IO base address for master PIC
PIC2            equ 0xA0	; IO base address for slave PIC
PIC_EOI         equ 0x20    ; End-of-interrupt command code
PIC1_COMMAND    equ PIC1
PIC1_DATA       equ PIC1+1
PIC2_COMMAND    equ PIC2
PIC2_DATA       equ PIC2+1

ICW1_ICW4       equ 0x01		; Indicates that ICW4 will be present 
ICW1_SINGLE     equ 0x02		; Single (cascade) mode 
ICW1_INTERVAL4  equ 0x04		; Call address interval 4 (8) 
ICW1_LEVEL      equ 0x08		; Level triggered (edge) mode 
ICW1_INIT       equ 0x10		; Initialization - required! 

ICW4_8086       equ 0x01		; 8086/88 (MCS-80/85) mode 
ICW4_AUTO       equ 0x02		; Auto (normal) EOI 
ICW4_BUF_SLAVE  equ 0x08		; Buffered mode/slave 
ICW4_BUF_MASTER equ 0x0C		; Buffered mode/master 
ICW4_SFNM       equ 0x10		; Special fully nested (not) 

; **************************************************************************
; * Map the 8259A PIC to use interrupts 32-47 within our interrupt table   *
; **************************************************************************
 
ICW_1       equ 0x11				; 00010001 binary. Enables initialization mode and we are sending ICW 4

PIC_1_CTRL  equ 0x20				; Primary PIC control register
PIC_2_CTRL  equ 0xA0				; Secondary PIC control register

PIC_1_DATA  equ 0x21				; Primary PIC data register
PIC_2_DATA  equ 0xA1				; Secondary PIC data register

IRQ_0       equ 0x20				; IRQs 0-7 mapped to use interrupts 0x20-0x27
IRQ_8       equ 0x28				; IRQs 8-15 mapped to use interrupts 0x28-0x36
 
pic_init:
    cli
    push eax
 
; Send ICW 1 - Begin initialization -------------------------
 
	; Setup to initialize the primary PIC. Send ICW 1
 
	mov	al, ICW_1
	out	PIC_1_CTRL, al
 
; Send ICW 2 - Map IRQ base interrupt numbers ---------------
 
	; Remember that we have 2 PICs. Because we are cascading with this second PIC, send ICW 1 to second PIC command register
 
	out	PIC_2_CTRL, al
 
	; send ICW 2 to primary PIC
 
	mov	al, IRQ_0
	out	PIC_1_DATA, al
 
	; send ICW 2 to secondary controller
 
	mov	al, IRQ_8
	out	PIC_2_DATA, al
 
; Send ICW 3 - Set the IR line to connect both PICs ---------
 
	; Send ICW 3 to primary PIC
 
	mov	al, 0x4			; 0x04 => 0100, second bit (IR line 2)
	out	PIC_1_DATA, al		; write to data register of primary PIC
 
	; Send ICW 3 to secondary PIC
 
	mov	al, 0x2			; 010=> IR line 2
	out	PIC_2_DATA, al		; write to data register of secondary PIC
 
; Send ICW 4 - Set x86 mode --------------------------------
 
	mov	al, 1			; bit 0 enables 80x86 mode
 
	; send ICW 4 to both primary and secondary PICs
 
	out	PIC_1_DATA, al
	out	PIC_2_DATA, al
 
; All done.
 
	mov	al, 0xFD
	out	PIC_1_DATA, al
	mov	al, 0xFF
	out	PIC_2_DATA, al

    pop eax
    ret


pic_send_eoi:
    ; al is irq input
    
    push eax

    xor ah, ah
    cmp ax, 8
    jl .after

    mov al, PIC_EOI
    out PIC2_COMMAND, al

.after:
    mov al, PIC_EOI
    out PIC1_COMMAND, al

.exit:
    pop eax
    sti
    ret


; ************************
; * Interrupts functions *
; ************************

pic_ints:
    .default_response:
        call pic_send_eoi

        push eax
        ; smothing
        pop eax

        iret