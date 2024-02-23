; %define KeyCodeTab_Press 0x0F
; %define KeyCodeTab_Break 0x8F

; %define KeyCodeCtrl_Press 0x1D
; %define KeyCodeCtrl_Break 0x9D

; %define KeyCodeShift_Press 0x2A
; %define KeyCodeShift_Break 0xAA

; %define KeyCodeAlt_Press 0x38
; %define KeyCodeAlt_Break 0xB8

; %define KeyCodeCapslock_Press 0x3A
; %define KeyCodeCapslock_Break 0xBA



; %define SpecialKey_Shift         0b00000001
; %define SpecialKey_Control       0b00000010
; %define SpecialKey_Alt           0b00000100
; %define SpecialKey_Command       0b00001000
; %define SpecialKey_Capslock      0b00010000
; %define SpecialKey_Tab           0b00100000
; %define SpecialKey_RightControl  0b01000000
; %define SpecialKey_RightAlt      0b10000000
; special_keys: db 0

shift: db 0
capslock: db 0

; code key table
code_key_table: 
               db 27,'1','2','3','4','5','6','7','8','9','0','-','=',8,0xfe,'q','w','e','r','t','y','u','i','o','p','[',']',10,0xfe,'a','s','d','f','g','h','j','k','l'
               db ';',39,'`',0xfe,92,'z','x','c','v','b','n','m',',','.','/',0xfe
               db '*',0xfe,' ',0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,'7','8','9','-','4','5','6','+','1','2','3','0','.',0xff,0xff,0xff,0xfe,0xfe,0xff,0xff,0xff,0xff
    times 4*20 db 0xfe
               db 0xff,0xff,0xff,0xfe,0xfe,0xff,0xff,0xff
    times 4*41 db 0xff
               db 0

shift_code_key_table: 
               db 27,'!','@','#','$','%','&','&','*','(',')','_','+',8,0xfe,'Q','W','E','R','T','Y','U','I','O','P','{','}',10,0xfe,'A','S','D','F','G','H','J','K','L'
               db ':',34,'~',0xfe,'|','Z','X','C','V','B','N','M','<','>','?',0xfe
               db '*',0xfe,' ',0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,'7','8','9','-','4','5','6','+','1','2','3','0','.',0xff,0xff,0xff,0xfe,0xfe,0xff,0xff,0xff,0xff
    times 4*20 db 0xfe
               db 0xff,0xff,0xff,0xfe,0xfe,0xff,0xff,0xff
    times 4*41 db 0xff
               db 0
; code key table