    processor 6502

    include "vcs.h"
    include "macro.h"

    seg code
    org $F000       ; defines the origin of the ROM at &F000

START:
    CLEAN_START     ; Macro to safely clear the memory 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Set background luminosity color to yellow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #$1E        ; Load color into A ($1E is NTSC yellow)
    sta COLUBK      ; store A to Backgroundcolor Adress $09

    jmp START       ; Repeat from START

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Fill ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

    org $FFFC       ; Defines the origin to $FFFC
    .word START     ; Reset vector at $FFFC
    .word START     ; Interrupt vector at $FFFE
