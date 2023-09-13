# msdos-keyboard-asm


Written by Aydin T.BAKIR around 1991 and 1992. 

Shows the interrupt handling in 80x86 ASM in MSDOS.

Compiled with TLINK, TASM or MASM.

keyboard com file runs on MSDOS.  
Hooks the keyboard interrupt, stays resident in the memory. 

When ALT-key combinations are pressed, replaced by the corresponding turkish character.

such as

    Alt-o = ö 
    Alt-u = ü
    
    etc
    

Clock.asm were used to show realtime clock on MSDOS screen.


