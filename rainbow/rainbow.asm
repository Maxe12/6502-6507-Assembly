    processor 6502

    include "vcs.h"
    include "macro.h"

    seg code
    org $F000

Start:
    CLEAN_START

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Start new frame by turning on VBLANK and VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NextFrame: 
    lda #2          ; same as binary %00000010
    sta VBLANK      ; turn on vblanc
    sta VSYNC       ; turn on vsync

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Generate the tree lines of VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    sta WSYNC       ; first scanline
    sta WSYNC       ; second scanline
    sta WSYNC       ; third scanline

    lda #0
    sta VSYNC       ; turn off VSYNC
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Let TIA Output the recommendet 37 lines of VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #37         ; X = 37 (counter)
VBlankLoop: 
    sta WSYNC       ; hit WSYNC and wait for next scanline
    dex             ; X--
    bne VBlankLoop  ; Loop while X != 0  

    lda #0
    sta VBLANK      ; turn off VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Render visible scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #192        ; counter 192 (visible scanlines)
LoopVisible: 
    stx COLUBK      ; Save X into COLUBK (Backgroundcolor)
    sta WSYNC       ; wait for the next line
    dex             ; X--
    bne LoopVisible ; Loop while x != 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Output 30 more lines to complete frame (overscan)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #2          ; hit and turn on VBLANK again
    sta VBLANK

    ldx #30         ; counter
LoopOverscan:
    sta WSYNC       ; hit WSYNC and wait for next scanline
    dex             ; X--
    bne LoopOverscan; loop while X != 0

    jmp NextFrame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Complete ROM Size to 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    org $FFFC
    .word Start
    .word Start
