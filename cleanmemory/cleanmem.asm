    processor 6502

    seg code
    org $F000   ; defines the code origin at $F000

Start:
    sei         ; disable interrupts
    cld         ; disable the BCD decimal math mode
    ldx #$FF    ; loads the X register with #$FF
    txs         ; transfer x register to stack pointer (S Register)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear the Zero Page region ($00 to $FF)
; Meaning the entire TIA Register space and also RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda #0      ; A = 0
    ldx #$FF    ; X = #$FF
    sta X       ; store 0 to $FF before loop starts

MemLoop: 
    dex         ; X--
    sta $0,X    ; Store A register (Value 0) at adress $0 + X (sta doesnt modify flags!)
    bne MemLoop ; loop until X == 0 (z flag set)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    org $FFFC
    .word Start ; reset vector at $FFFC (where program starts)
    .word Start ; interrupt vector at $FFFE (unused in VCS)
