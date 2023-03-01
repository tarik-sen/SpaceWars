.code16

.equ KERNEL_ADDR, 0x9000

.globl _start
.section .text

_start:
    # Configuration of stack
    movw $0x0900, %bx
    movw %bx, %es
    
    xorw %bx, %bx
    movw %bx, %ss
    movw %bx, %ds
    movw %bx, %gs
    movw %bx, %fs

    # Store boot drive
    movb %dl, BOOT_DRIVE

    # Initalization of stack
    movw $0x8000, %bp
    movw %bp, %sp

    # Load kernel to address 0x9000  // 16384 byte
    movb $32, %dh
    movb $2, %cl
    movb BOOT_DRIVE, %dl

    call sectorLoad

    jmp KERNEL_ADDR

BOOT_DRIVE:
    .byte 0


# Read from hard disk to memory.
# BIOS will read %dh sectors into %es:%bx from drive %dl and sector %cl
.type sectorLoad, @function
sectorLoad:
    _sectorLoadStart:
        push %dx

        movb $0x02, %ah     # Tell bios to read.
        movb %dh, %al       # Tell bios to read %dh sectors.
        movb $0x00, %ch     # Cylinder => 0
        movb $0x00, %dh     # Head => 0

        int $0x13

        jc _sectorLoadError

        pop %dx
        cmpb %al, %dh
        jne _sectorLoadError

        leaw _sectorLoadSuccessMsg, %bx
        jmp _sectorLoadEnd

        _sectorLoadError:
            leaw _sectorLoadUnsuccessMsg, %bx
            
    _sectorLoadEnd:
        call printString
        ret

    _sectorLoadSuccessMsg:
        .asciz "###########   KERNEL IS LOADED   ###########\n\r"

    _sectorLoadUnsuccessMsg:
        .asciz "KERNEL COULDN'T BE LOADED!!!\n\r"



# Function to display a string. Location to the first argumen must be given to %bx register as an argument.
.type printString, @function
printString:
    _printStringStart:
        # Save previous destiny index register value to not alter it.
        push %di

        movb $0x0e, %ah
        movw $0, %di

    _printStringLoop:
        movb (%bx, %di, 1), %al

        cmpb $0, %al
        je _printStringEnd

        int $0x10

        incw %di
        jmp _printStringLoop

    _printStringEnd:        
        # Retrieve previous destiny index register value.
        pop %di
        ret


.fill 510 - (. - _start), 1, 0
.word 0xaa55
