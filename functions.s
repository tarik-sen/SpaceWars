# Generic function library
.code16

# (x, y)   -> (%bx, %dx)
# (fg, bg) -> (%ah, %al)
# Decimal  -> %cx
.type printColoredDecimal, @function
printColoredDecimal:
    .equ DECIMAL_FG_LOC_OFFSET, -1
    .equ DECIMAL_BG_LOC_OFFSET, -2
    _printColoredDecimalStart:
        push %bp
        push %ax
        push %cx
        push %si
        push %dx

        movw %sp, %bp
        subw $16, %sp

        movb %ah, DECIMAL_FG_LOC_OFFSET(%bp)
        movb %al, DECIMAL_BG_LOC_OFFSET(%bp)

        movw %cx, %ax

        movw $10, %cx
        movw %dx, %si

        push $256  # random value to keep start point

    _printColoredDecimalLoadLoopStart:
        cmpw $0, %ax
        je _printColoredDecimalLoadLoopEnd

        xorw %dx, %dx
        divw %cx
        push %dx

        jmp _printColoredDecimalLoadLoopStart

    _printColoredDecimalLoadLoopEnd:
        movw %si, %dx

    _printColoredDecimalEmptyLoop:
        pop %ax

        cmpw $256, %ax
        je _printColoredDecimalEnd

        movb %al, %cl
        addb $'0', %cl
        movb DECIMAL_FG_LOC_OFFSET(%bp), %ah
        movb DECIMAL_BG_LOC_OFFSET(%bp), %al
        call printColoredChar

        xorb %ah, %ah
        addw %ax, %bx

        jmp _printColoredDecimalEmptyLoop

    _printColoredDecimalEnd:
        movw %bp, %sp

        pop %dx
        pop %si
        pop %cx
        pop %ax
        pop %bp

        ret


# (x, y)          -> (%bx, %dx)
# String Location -> %di
# (fg, bg)        -> (%ah, %al)
.type printColoredString, @function
printColoredString:
    .equ START_X_LOC_OFFSET,   -2
    .equ START_Y_LOC_OFFSET,   -4
    .equ STRING_FG_LOC_OFFSET, -5
    .equ STRING_BG_LOC_OFFSET, -6

    _printColoredStringStart:
        pusha
        movw %sp, %bp
        subw $16, %sp

        movw %bx, START_X_LOC_OFFSET(%bp)
        movw %dx, START_Y_LOC_OFFSET(%bp)
        movb %ah, STRING_FG_LOC_OFFSET(%bp)
        movb %al, STRING_BG_LOC_OFFSET(%bp)

    _printColoredStringLoopStart:
        movb (%di), %al

        cmpb $0, %al
        je _printColoredStringEnd

        cmpb $'\n', %al
        jne _printColoredStringLoopIfNotNewLine
        _printColoredStringLoopIfNewLine:
        addw $LINE_GAP, START_Y_LOC_OFFSET(%bp)
        movw START_Y_LOC_OFFSET(%bp), %dx
        jmp _printColoredStringLoopEnd
        _printColoredStringLoopIfNotNewLine:

        cmpb $'\r', %al
        jne _printColoredStringLoopIfNotCarriage
        _printColoredStringLoopIfCarriage:
        movw START_X_LOC_OFFSET(%bp), %bx
        jmp _printColoredStringLoopEnd
        _printColoredStringLoopIfNotCarriage:

        movb %al, %cl
        movb STRING_FG_LOC_OFFSET(%bp), %ah
        movb STRING_BG_LOC_OFFSET(%bp), %al
        call printColoredChar

        xorb %ah, %ah
        addw %ax, %bx  # Move the cursor
        incw %bx       # Extra space

    _printColoredStringLoopEnd:
        incw %di
        jmp _printColoredStringLoopStart

    _printColoredStringEnd:
        movw %bp, %sp
        popa

        ret


# Returns character width via %al
# (x, y)   -> (%bx, %dx)
# (fg, bg) -> (%ah, %al)
# char     -> %cl
.type printColoredChar, @function
printColoredChar:
    .equ PRINT_COLORED_CHAR_LOCAL_WIDTH_OFFSET,    -1
    .equ PRINT_COLORED_CHAR_LOCAL_FG_COLOR_OFFSET, -2
    .equ PRINT_COLORED_CHAR_LOCAL_BG_COLOR_OFFSET, -3
    _printColoredCharStart:
        push %bp
        push %cx
        push %dx
        push %si
        push %di
        push %es
        push %bx

        movw %sp, %bp
        subw $16, %sp

        movb %ah, PRINT_COLORED_CHAR_LOCAL_FG_COLOR_OFFSET(%bp)
        movb %al, PRINT_COLORED_CHAR_LOCAL_BG_COLOR_OFFSET(%bp)

        # Configure %bx which holds screen ram location, with %es register.
        movw %dx, %ax
        xorw %dx, %dx
        movw $320, %di
        mulw %di
        addw %ax, %bx

        movw $0xA000, %ax
        movw %ax, %es

        # Configure %si which holds char location.
        movb %cl, %al
        call getChar

        xorw %di, %di  # Make it zero, since it will be used as character counter.

    _printColoredCharLoopStart:
        movb (%si), %al

        cmpb $0, %al
        je _printColoredCharEnd

        cmpb $'\n', %al
        je _printColoredCharLoopNextLine

        cmpb $' ', %al
        jne _printColoredCharLoopIfNotSpace
        _printColoredCharLoopIfSpace:
        movb PRINT_COLORED_CHAR_LOCAL_BG_COLOR_OFFSET(%bp), %ch
        jmp _printColoredCharLoopSpaceContinue

        _printColoredCharLoopIfNotSpace:
        movb PRINT_COLORED_CHAR_LOCAL_FG_COLOR_OFFSET(%bp), %ch

        _printColoredCharLoopSpaceContinue:
        movb %ch, %es:(%bx, %di)

    _printColoredCharLoopEnd:
        incw %si
        incw %di
        jmp _printColoredCharLoopStart

    _printColoredCharLoopNextLine:
        movw %di, %ax
        movb %al, PRINT_COLORED_CHAR_LOCAL_WIDTH_OFFSET(%bp)
        xorw %di, %di
        addw $320, %bx
        incw %si

        jmp _printColoredCharLoopStart

    _printColoredCharEnd:
        movb PRINT_COLORED_CHAR_LOCAL_WIDTH_OFFSET(%bp), %al

        movw %bp, %sp
    
        pop %bx
        pop %es
        pop %di
        pop %si
        pop %dx
        pop %cx
        pop %bp
        
        ret



# Used to draw rectangles on video mode 0x13
# (%cx, %dx) will hold top left corner coordinates.
# (%si, %di) will hold bottom right corner coordinates.
# %bl will hold the color.
.type drawRect, @function
drawRect:
    .equ RECT_LENGTH_OFFSET,     -2  # |
    .equ RECT_WIDTH_OFFSET,      -4  # _
    .equ RECT_COLOR_OFFSET,      -5

    _drawRectStart:
        # Configuration of stack
        push %bp
        push %ax
        push %bx
        push %es
        movw %sp, %bp
        subw $8, %sp

        movb %bl, RECT_COLOR_OFFSET(%bp)

        subw %cx, %si
        incw %si
        movw %si, RECT_WIDTH_OFFSET(%bp)

        subw %dx, %di
        incw %di
        movw %di, RECT_LENGTH_OFFSET(%bp)

        movw $0xA000, %bx
        movw %bx, %es

        movw %dx, %bx
        movw $320, %ax
        mulw %bx
        addw %cx, %ax
        movw %ax, %bx # %bx register will hold the current cursor location.

        movb RECT_COLOR_OFFSET(%bp), %dl
        movw RECT_LENGTH_OFFSET(%bp), %cx

        _drawRectLoop:
            call rectFillRow

            addw $320, %bx
            loopw _drawRectLoop

    _drawRectEnd:
        # Reconfiguration stack
        movw %bp, %sp
        pop %es
        pop %bx
        pop %ax
        pop %bp
        
        ret


    # %es and %bx points to a video ram location
    # %dl is set to the color
    .type rectFillRow, @function
    rectFillRow:
        push %bx
        push %cx
        movw RECT_WIDTH_OFFSET(%bp), %cx

        _rectFillRowLoop:  
            movb %dl, %es:(%bx)
            incw %bx

            loopw _rectFillRowLoop

        pop %cx
        pop %bx
        ret


# Used to draw squares on video mode 0x13
# (%cx, %dx) will hold top left corner coordinates.
# %si will hold side length of the square and %bl will hold the color id.
.type drawSquare, @function
drawSquare:
    _drawSquareStart:
        push %di

    _drawSquarePhase:
        movw %dx, %di
        addw %si, %di
        addw %cx, %si

        call drawRect

    _drawSquareEnd:
        pop %di

        ret



# %si is set to miliseconds
.type wait_msec, @function
wait_msec:
    movw $0x8600, %ax
    movw %si, %cx
    movw %si, %dx
    shr $6,   %cx
    shl $10,  %dx
    int $0x15

    ret
