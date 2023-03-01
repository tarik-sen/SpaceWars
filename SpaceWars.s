# SpaceWars Game
.code16

.globl _KernelStart
.section .text

_KernelStart:
    #  CONSTANTS
    .equ SCREEN_LEFT,                      0
    .equ SCREEN_RIGHT,                   320
    .equ SCREEN_TOP,                       0
    .equ SCREEN_BOTTOM,                  200
    .equ SCREEN_END_POINT,             64000
        
    .equ RIGHT,                            6
    .equ UP,                               8
    .equ LEFT,                             4
    .equ DOWN,                             2

    .equ SHIP_TOP_LEFT_X,                 60
    .equ SHIP_TOP_LEFT_Y,                175
    .equ SHIP_BOTTOM_RIGHT_X,             90
    .equ SHIP_BOTTOM_RIGHT_Y,            180
    .equ SHIP_COLOR,                    0x04
    .equ SHIP_SPEED,                       3
    
    .equ GLOB_BOMB_SPEED,                  1
    .equ GLOB_BULLET_SPEED,                1
    .equ BOMB_PER_FRAME,                 100
    .equ GAME_FRAME_WAIT_MSEC,            20
    .equ SPACE_KEY_PRESS_PER_FRAME,       10
    .equ GAME_BG_COLOR,                 0x00
    .equ SCORE_TEXT_COLOR,              0x40

    .equ SHIP_TOP_LEFT_X_OFFSET,          -2
    .equ SHIP_TOP_LEFT_Y_OFFSET,          -4
    .equ SHIP_BOTTOM_RIGHT_X_OFFSET,      -6
    .equ SHIP_BOTTOM_RIGHT_Y_OFFSET,      -8
    .equ SHIP_COLOR_OFFSET,               -9
    .equ SHIP_SPEED_OFFSET,              -10
    .equ TEMP_CTR_OFFSET,                -11
    .equ BOMB_CTR_OFFSET,                -12
    .equ SPACE_CTR_OFFSET,               -13
    .equ RANDOM_CTR_OFFSET,              -14
    .equ MAX_BOMB_CTR_OFFSET,            -15
    .equ MAX_BULLET_CTR_OFFSET,          -16
    .equ BOMB_PER_FRAME_OFFSET,          -17
    .equ BOMB_SIDE_OFFSET,               -19
    .equ BOMB_COLOR_OFFSET,              -20
    .equ SCORE_CTR_OFFSET,               -22
    .equ LEVEL_CTR_OFFSET,               -23
    .equ BOMB_SPEED_OFFSET,              -24
    .equ LOOP_START_TIME_HIGH_OFFSET,    -26
    .equ LOOP_START_TIME_LOW_OFFSET,     -28

    .equ BOMB_START_Y,                    10
    .equ BOMB_SIDE,                       16
    .equ BOMB_COLOR,                    0x2b
    .equ BOMB_SIZE,                        8
            
    .equ BULLET_START_Y,                 160
    .equ BULLET_LENGTH,                    8
    .equ BULLET_WIDTH,                     4
    .equ BULLET_COLOR,                  0x20
    .equ BULLET_SIZE,                      8
           
    .equ OBJ_TOP_LEFT_X_LIST_OFFSET,       0
    .equ OBJ_TOP_LEFT_Y_LIST_OFFSET,       2
    .equ OBJ_BOTTOM_RIGHT_X_LIST_OFFSET,   4
    .equ OBJ_BOTTOM_RIGHT_Y_LIST_OFFSET,   6

    .equ BOMB_LIST_ADDR,              0x1200
    .equ BULLET_LIST_ADDR,            0x1400
    .equ VIDEO_MEM_ADDR,              0xA000
           
    .equ SPACE_KEY_CODE,                0x39

    .equ DELAY_AFTER_GAME_OVER,          500
    .equ GAME_WIN_SCORE,                 100
    .equ CONFIGURATION_SIZE,               6

    .equ GAME_OVER_STATUS_BG,           0x00
    .equ GAME_OVER_TEXT_X_LOC,            35
    .equ GAME_OVER_TEXT_Y_LOC,            10
    .equ GAME_OVER_TEXT_FG,             0x04
    .equ GAME_OVER_TEXT_BG,             0x12

    .equ GAME_WIN_STATUS_BG,            0x1a
    .equ GAME_WIN_TEXT_X_LOC,             40
    .equ GAME_WIN_TEXT_Y_LOC,             35
    .equ GAME_WIN_TEXT_FG,              0x43
    .equ GAME_WIN_TEXT_BG,              0x1c

    .equ SCORE_TEXT_X_LOC,                 2
    .equ SCORE_TEXT_Y_LOC,                 2

    .equ SCORE_CTR_X_LOC,                 42
    .equ SCORE_CTR_Y_LOC,                  3

    # Set video mode
    movw $0x0013, %ax
    int $0x10

    # Configuration of stack
    subw $32, %sp

    # Initialize variables
    movb $SPACE_KEY_PRESS_PER_FRAME, SPACE_CTR_OFFSET(%bp)
    movb $BOMB_PER_FRAME, BOMB_PER_FRAME_OFFSET(%bp)
    movw $BOMB_SIDE, BOMB_SIDE_OFFSET(%bp)
    movb $BOMB_COLOR, BOMB_COLOR_OFFSET(%bp)

    movb $0x00, TEMP_CTR_OFFSET(%bp)
    movb $0x00, BOMB_CTR_OFFSET(%bp)
    movb $0x00, MAX_BOMB_CTR_OFFSET(%bp)
    movb $0x00, MAX_BULLET_CTR_OFFSET(%bp)
    movb $0x00, RANDOM_CTR_OFFSET(%bp)
    movw $0x00, SCORE_CTR_OFFSET(%bp)
    movb $0x00, LEVEL_CTR_OFFSET(%bp)

    # Load start position of ship into registers.
    movw $SHIP_TOP_LEFT_X,      %cx
    movw $SHIP_TOP_LEFT_Y,      %dx
    movw $SHIP_BOTTOM_RIGHT_X,  %si
    movw $SHIP_BOTTOM_RIGHT_Y,  %di
    movb $SHIP_COLOR,           %bl
    movb $SHIP_SPEED,           %al

    # Load start position of ship into ram
    movw %cx, SHIP_TOP_LEFT_X_OFFSET(%bp)
    movw %dx, SHIP_TOP_LEFT_Y_OFFSET(%bp)
    movw %si, SHIP_BOTTOM_RIGHT_X_OFFSET(%bp)
    movw %di, SHIP_BOTTOM_RIGHT_Y_OFFSET(%bp)
    movb %bl, SHIP_COLOR_OFFSET(%bp)
    movb %al, SHIP_SPEED_OFFSET(%bp)

    # Configure keyboard interrupt handler
    call registerInterruptHandler
    
    call drawRect

    call levelConfiguration

    _game_loop:
        # Save time into defined ram locations.
        movb $0x00, %ah
        int $0x1A
        movw %cx, LOOP_START_TIME_HIGH_OFFSET(%bp)
        movw %dx, LOOP_START_TIME_LOW_OFFSET(%bp)

        call displayScore

        # Take possible last user input.
        movb _lastKey, %al

        cmpb $SPACE_KEY_CODE, %al
        jne _spaceActionJumperDone
        cmpb $SPACE_KEY_PRESS_PER_FRAME, SPACE_CTR_OFFSET(%bp)
        jb _spaceActionJumperDone
        _spaceActionJumperIf:
            movb $0, SPACE_CTR_OFFSET(%bp)
            call addBullet
        _spaceActionJumperDone:
            incb SPACE_CTR_OFFSET(%bp)

        _bullet_move_part_start:
            push %gs
            movw $BULLET_LIST_ADDR, %bx
            movw %bx, %gs
            xorw %bx, %bx

            movb MAX_BULLET_CTR_OFFSET(%bp), %al
            movb %al, TEMP_CTR_OFFSET(%bp)

            _bullet_move_loop_start:
                # Break the loop if max bullet count has reached
                cmpb $0, TEMP_CTR_OFFSET(%bp)
                je _bullet_move_part_end

                # Skip if empty (bullet is empty)
                cmpw $0, %gs:OBJ_TOP_LEFT_X_LIST_OFFSET(%bx)
                je _bullet_move_loop_end

                # If hits the top, kill it
                cmpw $SCREEN_TOP, %gs:OBJ_TOP_LEFT_Y_LIST_OFFSET(%bx)
                jne _killBulletJumperDone
                _killBulletJumperIf:
                    call killObj
                    jmp _bullet_move_loop_end
                _killBulletJumperDone:

            _bullet_move_loop_main:
                push %bx

                leaw OBJ_TOP_LEFT_X_LIST_OFFSET(%bx),     %cx
                leaw OBJ_TOP_LEFT_Y_LIST_OFFSET(%bx),     %dx
                leaw OBJ_BOTTOM_RIGHT_X_LIST_OFFSET(%bx), %si
                leaw OBJ_BOTTOM_RIGHT_Y_LIST_OFFSET(%bx), %di
                movb $UP,                                 %bh
                movb $BULLET_COLOR,                       %bl
                movb $GLOB_BULLET_SPEED,                  %al
                call moveRect

                pop %bx

            _bullet_move_loop_end:
                addw $BULLET_SIZE, %bx
                decb TEMP_CTR_OFFSET(%bp)
                jmp _bullet_move_loop_start

        _bullet_move_part_end:
            pop %gs

        _bomb_move_part:
            push %gs
            movw $BOMB_LIST_ADDR, %bx
            movw %bx, %gs
            xorw %bx, %bx

            movb MAX_BOMB_CTR_OFFSET(%bp), %al
            movb %al, TEMP_CTR_OFFSET(%bp)

            _bomb_move_loop_start:
                # Break the loop if max bomb count has reached
                cmpb $0, TEMP_CTR_OFFSET(%bp)
                je _bomb_move_part_end

                # Skip if zero
                cmpw $0, %gs:OBJ_TOP_LEFT_X_LIST_OFFSET(%bx)
                je _bomb_move_loop_end

                # If hits the ground, game is over.
                cmpw $SCREEN_BOTTOM, %gs:OBJ_BOTTOM_RIGHT_Y_LIST_OFFSET(%bx)
                je _GameOver

                # If cause a collision, kill it, and pass to next bomb.
                call checkRemoveCollision
                cmpb $1, %al
                jne _collisionJumperDone
                _collisionJumperIf:
                    incw SCORE_CTR_OFFSET(%bp)

                    # Check if score is 100
                    movw SCORE_CTR_OFFSET(%bp), %ax
                    cmpw $GAME_WIN_SCORE, %ax
                    je _WinStatus

                    call levelConfiguration

                    jmp _bomb_move_loop_end
                _collisionJumperDone:

            _bomb_move_loop_main:
                push %bx

                # Load bomb values
                leaw OBJ_TOP_LEFT_X_LIST_OFFSET(%bx),     %cx
                leaw OBJ_TOP_LEFT_Y_LIST_OFFSET(%bx),     %dx
                leaw OBJ_BOTTOM_RIGHT_X_LIST_OFFSET(%bx), %si
                leaw OBJ_BOTTOM_RIGHT_Y_LIST_OFFSET(%bx), %di
                movb $DOWN,                               %bh
                movb BOMB_COLOR_OFFSET(%bp),              %bl
                movb $GLOB_BOMB_SPEED,                    %al
                call moveRect

                pop %bx

            _bomb_move_loop_end:
                addw $BOMB_SIZE, %bx
                decb TEMP_CTR_OFFSET(%bp)
                jmp _bomb_move_loop_start

        _bomb_move_part_end:
            pop %gs

        _ship_move_part:
            testb $0x01, _curRightKeyStatus
            jz _leftKeyPress

            testb $0x01, _curLeftKeyStatus
            jz _rightKeyPress

            # If both right and left keys are being pressed, do nothing.
            jmp _game_loop_end

            _leftKeyPress:
                testb $0x01, _curLeftKeyStatus
                jz _game_loop_end

                # Check if there is enough space to move left
                movw $SCREEN_LEFT, %ax
                addw $2, %ax
                cmpw SHIP_TOP_LEFT_X_OFFSET(%bp), %ax
                jae _game_loop_end

                movb $LEFT, %bh
                jmp _moveShip

            _rightKeyPress:
                # Check if there is enough space to move left
                movw $SCREEN_RIGHT, %ax
                subw $2, %ax
                cmpw SHIP_BOTTOM_RIGHT_X_OFFSET(%bp), %ax
                jbe _game_loop_end

                movb $RIGHT, %bh

            _moveShip:
                # Load ship values
                leaw SHIP_TOP_LEFT_X_OFFSET(%bp)    , %cx
                leaw SHIP_TOP_LEFT_Y_OFFSET(%bp)    , %dx
                leaw SHIP_BOTTOM_RIGHT_X_OFFSET(%bp), %si
                leaw SHIP_BOTTOM_RIGHT_Y_OFFSET(%bp), %di
                movb SHIP_COLOR_OFFSET(%bp)         , %bl
                movb SHIP_SPEED_OFFSET(%bp)         , %al
                
                call moveRect

    _game_loop_end:
        # Create a new bomb if time is up
        movb BOMB_PER_FRAME_OFFSET(%bp), %al
        cmpb %al, BOMB_CTR_OFFSET(%bp)
        jb _bombCtrIncDone
        _bombCtrIncIf:
            movb $0x00, BOMB_CTR_OFFSET(%bp)
            call addBomb
        _bombCtrIncDone:
            incb BOMB_CTR_OFFSET(%bp)

        # Sleep for $GAME_FRAME_WAIT_MSEC at most!
        movb $0x00, %ah
        int $0x1A

        cmpw LOOP_START_TIME_LOW_OFFSET(%bp), %dx
        jae _game_loop_end_if_valid_time

        movw $GAME_FRAME_WAIT_MSEC - 2, %si
        jmp _game_loop_end_if_not_valid_time

        _game_loop_end_if_valid_time:
            subw LOOP_START_TIME_LOW_OFFSET(%bp), %dx

            cmpw $GAME_FRAME_WAIT_MSEC, %dx
            jae _game_loop

            movw $GAME_FRAME_WAIT_MSEC, %si
            subw %dx, %si

        _game_loop_end_if_not_valid_time:
            call wait_msec

        jmp _game_loop


_GameOver:
    movw $DELAY_AFTER_GAME_OVER, %si
    call wait_msec

    movb $GAME_OVER_STATUS_BG, %cs:_background_color
    call refreshBackground

    movw $GAME_OVER_TEXT_X_LOC,   %bx
    movw $GAME_OVER_TEXT_Y_LOC,   %dx
    movb $GAME_OVER_TEXT_FG, %ah
    movb $GAME_OVER_TEXT_BG, %al
    leaw _game_over_text, %di
    call printColoredString

    jmp _end

_WinStatus:
    movb $GAME_WIN_STATUS_BG, %cs:_background_color
    call refreshBackground

    movw $GAME_WIN_TEXT_X_LOC, %bx
    movw $GAME_WIN_TEXT_Y_LOC, %dx
    movb $GAME_WIN_TEXT_FG, %ah
    movb $GAME_WIN_TEXT_BG, %al
    leaw _game_win_text, %di
    call printColoredString

    jmp _end
    
_end:
    jmp _end


_score_text:
    .asciz "Score:"


_game_over_text:
    .ascii " #####     #    #     # #######\n\r"
    .ascii "#     #   # #   ##   ## #      \n\r" 
    .ascii "#        #   #  # # # # #      \n\r" 
    .ascii "#  #### #     # #  #  # #####  \n\r" 
    .ascii "#     # ####### #     # #      \n\r" 
    .ascii "#     # #     # #     # #      \n\r" 
    .ascii " #####  #     # #     # #######\n\n\r"

    .ascii "####### #     # ####### ###### \n\r"
    .ascii "#     # #     # #       #     #\n\r"
    .ascii "#     # #     # #       #     #\n\r"
    .ascii "#     # #     # #####   ###### \n\r"
    .ascii "#     #  #   #  #       #   #  \n\r" 
    .ascii "#     #   # #   #       #    # \n\r"
    .asciz "#######    #    ####### #     #"


_game_win_text:
    .ascii  "                             \n\r"
    .ascii  "                             \n\r"
    .ascii  "   #     # ####### #     #   \n\r"
    .ascii  "   #  #  # #     # ##    #   \n\r"
    .ascii  "   #  #  # #     # # #   #   \n\r"
    .ascii  "   #  #  # #     # #  #  #   \n\r"
    .ascii  "   #  #  # #     # #   # #   \n\r"
    .ascii  "   #  #  # #     # #    ##   \n\r"
    .ascii  "    ## ##  ####### #     #   \n\r"
    .ascii  "                             \n\r"
    .asciz  "                             "


.type displayScore, @function
displayScore:
    push %bx
    push %dx
    push %ax
    push %di
    push %si

    movw $SCORE_TEXT_X_LOC, %bx
    movw $SCORE_TEXT_Y_LOC, %dx
    movb $SCORE_TEXT_COLOR, %ah
    movb %cs:_background_color, %al
    leaw _score_text, %di
    call printColoredString

    movw $SCORE_CTR_X_LOC, %bx
    movw $SCORE_CTR_Y_LOC, %dx
    movb $SCORE_TEXT_COLOR, %ah
    movb %cs:_background_color, %al
    movw SCORE_CTR_OFFSET(%bp), %cx
    call printColoredDecimal

    pop %si
    pop %di
    pop %ax
    pop %dx
    pop %bx
    ret


# Level Configuration Key
#   level_code:
#       .word {BOMB_PER_FRAME, BOMB_SIDE, BOMB_COLOR, BG, SHIP_SPEED, BOMB_SPEED}

_background_color:
    .byte 0x00

_levelConfigurations:
_level_1:
    .byte 100, 16, 0x41, 0x00, 3, 1
_level_2:
    .byte 90,  14, 0x42, 0x03, 3, 1
_level_3:
    .byte 80,  12, 0x43, 0x0C, 3, 1
_level_4:
    .byte 70,  10, 0x44, 0x05, 3, 1
_level_5:
    .byte 60,   8, 0x45, 0x06, 3, 1
_level_6:
    .byte 80,  60, 0x46, 0x07, 1, 1
_level_7:
    .byte 60,  12, 0x47, 0x08, 3, 2
_level_8:
    .byte 50,  10, 0x48, 0x09, 4, 2
_level_9:
    .byte 45,   8, 0x4e, 0x1f, 4, 2
_level_10:
    .byte 40,   8, 0x4f, 0x0f, 4, 2


.type levelConfiguration, @function
levelConfiguration:
    _levelConfigurationStart:
        push %ax
        push %dx
        push %cx
        push %bx


    _levelConfigurationMain:
        movw $10, %cx
        xorw %dx, %dx
        movw SCORE_CTR_OFFSET(%bp), %ax
        divw %cx
        
        cmpw $0, %dx
        jne _levelConfigurationEnd

        movb $CONFIGURATION_SIZE, %cl
        movb LEVEL_CTR_OFFSET(%bp), %al
        mulb %cl

        movw %ax, %bx

        movb _levelConfigurations(%bx), %dl
        movb %dl, BOMB_PER_FRAME_OFFSET(%bp)
        addw $1, %bx
        
        movb _levelConfigurations(%bx), %dl
        movb %dl, BOMB_SIDE_OFFSET(%bp)
        addw $1, %bx
        
        movb _levelConfigurations(%bx), %dl
        movb %dl, BOMB_COLOR_OFFSET(%bp)
        addw $1, %bx
        
        movb _levelConfigurations(%bx), %dl
        movb %dl, %cs:_background_color
        addw $1, %bx
        
        movb _levelConfigurations(%bx), %dl
        movb %dl, SHIP_SPEED_OFFSET(%bp)
        addw $1, %bx
        
        movb _levelConfigurations(%bx), %dl
        movb %dl, BOMB_SPEED_OFFSET(%bp)
        addw $1, %bx

        incb LEVEL_CTR_OFFSET(%bp)

        call refreshBackground
        call refreshShip

    _levelConfigurationEnd:
        pop %bx
        pop %cx
        pop %dx
        pop %ax

        ret



.type refreshBackground, @function
refreshBackground:
    _refreshBackgroundStart:
        push %es
        push %bx
        push %ax

        movw $VIDEO_MEM_ADDR, %bx
        movw %bx, %es

        xorw %bx, %bx
        movb %cs:_background_color, %al

    _refreshBackgroundLoop:
        cmpw $SCREEN_END_POINT, %bx
        ja _refreshBackgroundEnd

        movb %al, %es:(%bx)
        incw %bx

        jmp _refreshBackgroundLoop

    _refreshBackgroundEnd:
        pop %ax
        pop %bx
        pop %es

        ret


.type refreshShip, @function
refreshShip:
    _refreshShipStart:
        push %cx
        push %dx
        push %si
        push %di
        push %bx

    _refreshShipMain:
        movw SHIP_TOP_LEFT_X_OFFSET(%bp),     %cx
        movw SHIP_TOP_LEFT_Y_OFFSET(%bp),     %dx
        movw SHIP_BOTTOM_RIGHT_X_OFFSET(%bp), %si
        movw SHIP_BOTTOM_RIGHT_Y_OFFSET(%bp), %di
        movb SHIP_COLOR_OFFSET(%bp),          %bl

        call drawRect

    _refreshShipEnd:
        pop %bx
        pop %di
        pop %si
        pop %dx
        pop %cx

        ret


.type addBullet, @function
addBullet:
    _addBulletStart:
        push %bx
        push %gs
        push %ax
        push %bp

        movw $BULLET_LIST_ADDR, %bx
        movw %bx, %gs

    _addBulletMain:
        xorw %bx, %bx
        xorw %ax, %ax
        _addBulletMainInnerLoopStart:
            # If end of Bullet list is reached
            cmpb %al, MAX_BULLET_CTR_OFFSET(%bp)
            je _loadNewBullet

            # If not empty skip.
            cmpw $0, %gs:OBJ_TOP_LEFT_X_LIST_OFFSET(%bx)
            je _loadBullet

        _addBulletMainInnerLoopEnd:
            incb %al
            addw $BULLET_SIZE, %bx
            jmp _addBulletMainInnerLoopStart

        _loadNewBullet:
            incb MAX_BULLET_CTR_OFFSET(%bp)

        # Get and Set coordinates
        _loadBullet:
            call getBulletLoc

            movw %ax, %gs:OBJ_TOP_LEFT_X_LIST_OFFSET(%bx)
            addw $BULLET_WIDTH, %ax
            movw %ax, %gs:OBJ_BOTTOM_RIGHT_X_LIST_OFFSET(%bx)

            movw $BULLET_START_Y, %ax
            movw %ax, %gs:OBJ_TOP_LEFT_Y_LIST_OFFSET(%bx)
            addw $BULLET_LENGTH, %ax
            movw %ax, %gs:OBJ_BOTTOM_RIGHT_Y_LIST_OFFSET(%bx)
        
        # Draw it!
        _drawBullet:
            movw %gs:OBJ_TOP_LEFT_X_LIST_OFFSET(%bx),     %cx
            movw %gs:OBJ_TOP_LEFT_Y_LIST_OFFSET(%bx),     %dx
            movw %gs:OBJ_BOTTOM_RIGHT_X_LIST_OFFSET(%bx), %si
            movw %gs:OBJ_BOTTOM_RIGHT_Y_LIST_OFFSET(%bx), %di
            movb $BULLET_COLOR,                           %bl
            call drawRect

    _addBulletEnd:
        pop %bp
        pop %ax
        pop %gs
        pop %bx

        ret


.type addBomb, @function
addBomb:
    _addBombStart:
        push %bx
        push %es
        push %ax
        push %bp

        movw $BOMB_LIST_ADDR, %bx
        movw %bx, %es

    _addBombMain:
        xorw %bx, %bx
        xorw %ax, %ax
        _addBombMainInnerLoopStart:
            # If end of bomb list is reached
            cmpb %al, MAX_BOMB_CTR_OFFSET(%bp)
            je _loadNewBomb

            # If not empty skip.
            cmpw $0, %es:OBJ_TOP_LEFT_X_LIST_OFFSET(%bx)
            je _loadBomb

        _addBombMainInnerLoopEnd:
            incb %al
            addw $BOMB_SIZE, %bx
            jmp _addBombMainInnerLoopStart

        _loadNewBomb:
            incb MAX_BOMB_CTR_OFFSET(%bp)

        # Get and Set coordinates
        _loadBomb:
            call getRandomBombLoc

            movw %ax, %es:OBJ_TOP_LEFT_X_LIST_OFFSET(%bx)
            addw BOMB_SIDE_OFFSET(%bp), %ax
            movw %ax, %es:OBJ_BOTTOM_RIGHT_X_LIST_OFFSET(%bx)

            movw $BOMB_START_Y, %ax
            movw %ax, %es:OBJ_TOP_LEFT_Y_LIST_OFFSET(%bx)
            addw BOMB_SIDE_OFFSET(%bp), %ax
            movw %ax, %es:OBJ_BOTTOM_RIGHT_Y_LIST_OFFSET(%bx)
        
        # Draw it!
        _drawBomb:
            movw %es:OBJ_TOP_LEFT_X_LIST_OFFSET(%bx),     %cx
            movw %es:OBJ_TOP_LEFT_Y_LIST_OFFSET(%bx),     %dx
            movw %es:OBJ_BOTTOM_RIGHT_X_LIST_OFFSET(%bx), %si
            movw %es:OBJ_BOTTOM_RIGHT_Y_LIST_OFFSET(%bx), %di
            movb BOMB_COLOR_OFFSET(%bp),                  %bl
            call drawRect

    _addBombEnd:
        pop %bp
        pop %ax
        pop %es
        pop %bx

        ret



# %bx and %gs must be defined to point the location of object
.type killObj, @function
killObj:
    push %cx
    push %dx
    push %si
    push %di

    # Update screen
    push %bx
    movw %gs:OBJ_TOP_LEFT_X_LIST_OFFSET(%bx),     %cx
    movw %gs:OBJ_TOP_LEFT_Y_LIST_OFFSET(%bx),     %dx
    movw %gs:OBJ_BOTTOM_RIGHT_X_LIST_OFFSET(%bx), %si
    movw %gs:OBJ_BOTTOM_RIGHT_Y_LIST_OFFSET(%bx), %di
    movb %cs:_background_color, %bl
    call drawRect
    pop %bx

    # Update bullet data
    movw $0x00, %gs:OBJ_TOP_LEFT_X_LIST_OFFSET(%bx)
    movw $0x00, %gs:OBJ_TOP_LEFT_Y_LIST_OFFSET(%bx)
    movw $0x00, %gs:OBJ_BOTTOM_RIGHT_X_LIST_OFFSET(%bx)
    movw $0x00, %gs:OBJ_BOTTOM_RIGHT_Y_LIST_OFFSET(%bx)

    pop %di
    pop %si
    pop %dx
    pop %cx

    ret


.type getBulletLoc, @function
getBulletLoc:
    push %bx
    push %dx

    movw SHIP_TOP_LEFT_X_OFFSET(%bp), %ax
    addw SHIP_BOTTOM_RIGHT_X_OFFSET(%bp), %ax

    xorw %dx, %dx
    movw $2, %bx
    divw %bx

    pop %dx
    pop %bx

    ret


.type getRandomBombLoc, @function
getRandomBombLoc:
    _getRandomBombLocStart:
        push %cx
        push %dx
        push %es
        push %bx
        push %si

        xorw %bx, %bx
        movw %bx, %es

    _getRandomBombLocMain:
        xorw %ax, %ax
        int $0x1a

        movw SHIP_BOTTOM_RIGHT_X_OFFSET(%bp), %si

        cmpb $-1, RANDOM_CTR_OFFSET(%bp)
        jne _SpaceCtrZeroDone
        _SpaceCtrZeroIf:
            movb $0x00, RANDOM_CTR_OFFSET(%bp)
        _SpaceCtrZeroDone:
        
        incb RANDOM_CTR_OFFSET(%bp)

        movb RANDOM_CTR_OFFSET(%bp), %bl
        movw %es:10(%bx, %si), %cx
        
        movw %dx, %ax
        xorw %cx, %ax

        xorw %dx, %dx
        xorw %cx, %cx
        subb BOMB_SIDE_OFFSET(%bp), %cl
        subb BOMB_SIDE_OFFSET(%bp), %cl
        divw %cx
        addw BOMB_SIDE_OFFSET(%bp), %dx

        movw %dx, %ax

    _getRandomBombLocEnd:
        pop %si
        pop %bx
        pop %es
        pop %dx
        pop %cx

        ret


# %bx must point to a bomb location when segment register is taken as $BOMB_LIST_ADDR.
.type checkRemoveCollision, @function
checkRemoveCollision:
    _check_remove_collision_start:
        push %gs
        push %es
        push %bx
        push %si
        push %dx
        
        movw $BULLET_LIST_ADDR, %cx
        movw %cx, %gs
        movw $BOMB_LIST_ADDR, %cx
        movw %cx, %es

    _check_remove_collision_main:
        xorw %ax, %ax
        xorw %si, %si
        xorw %dx, %dx

        _collision_loop:
            cmpb %al, MAX_BULLET_CTR_OFFSET(%bp)
            je _check_remove_collision_end

            movw %es:OBJ_TOP_LEFT_Y_LIST_OFFSET(%bx), %cx      # bomb
            cmpw %cx, %gs:OBJ_BOTTOM_RIGHT_Y_LIST_OFFSET(%si)  # bullet
            jb _collision_loop_end

            movw %es:OBJ_BOTTOM_RIGHT_Y_LIST_OFFSET(%bx), %cx
            cmpw %cx, %gs:OBJ_TOP_LEFT_Y_LIST_OFFSET(%si)
            ja _collision_loop_end

            movw %es:OBJ_TOP_LEFT_X_LIST_OFFSET(%bx), %cx
            cmpw %cx, %gs:OBJ_BOTTOM_RIGHT_X_LIST_OFFSET(%si)
            jb _collision_loop_end

            movw %es:OBJ_BOTTOM_RIGHT_X_LIST_OFFSET(%bx), %cx
            cmpw %cx, %gs:OBJ_TOP_LEFT_X_LIST_OFFSET(%si)
            ja _collision_loop_end

            # Collision Case
            _collision_occur:
                push %bx

                # Kill the bullet
                movw %si, %bx
                call killObj

                # Kill the bomb
                pop %bx
                movw %es, %cx
                movw %cx, %gs
                call killObj

                movw $0x0001, %dx
                jmp _check_remove_collision_end
            
        _collision_loop_end:
            incb %al
            addw $BULLET_SIZE, %si
            jmp _collision_loop

    _check_remove_collision_end:
        movw %dx, %ax

        pop %dx
        pop %si
        pop %bx
        pop %es
        pop %gs
        
        ret


# Used to move rectangles on video mode 0x13 with respect to %gs segment register.
# (%cx, %dx) will hold top left corner coordinates.
# (%si, %di) will hold bottom right corner coordinates.
# %bh and %bl will hold direction and color respectively.
# %al will hold the move speed.
.type moveRect, @function
moveRect:
    .equ TOP_LEFT_X_ADDR_OFFSET,     -2
    .equ TOP_LEFT_Y_ADDR_OFFSET,     -4
    .equ BOTTOM_RIGHT_X_ADDR_OFFSET, -6
    .equ BOTTOM_RIGHT_Y_ADDR_OFFSET, -8
    .equ DIRECTION_OFFSET,           -9
    .equ COLOR_OFFSET,               -10
    .equ LENGTH_OFFSET,              -12
    .equ WIDTH_OFFSET,               -14
    .equ SPEED_OFFSET,               -15

    _moveRectStart:
        push %bp
        push %bx
        push %es
        movw %sp, %bp
        subw $16, %sp

        # Load addresses and values
        movw %cx, TOP_LEFT_X_ADDR_OFFSET(%bp)
        movw %dx, TOP_LEFT_Y_ADDR_OFFSET(%bp)
        movw %si, BOTTOM_RIGHT_X_ADDR_OFFSET(%bp)
        movw %di, BOTTOM_RIGHT_Y_ADDR_OFFSET(%bp)
        movb %bh, DIRECTION_OFFSET(%bp)
        movb %bl, COLOR_OFFSET(%bp)
        movb %al, SPEED_OFFSET(%bp)

        # Load video memory address into %es segment register
        movw $VIDEO_MEM_ADDR, %bx
        movw %bx, %es

        # Calculate and load length and width values
        movw TOP_LEFT_Y_ADDR_OFFSET(%bp), %bx
        movw %gs:(%bx), %ax
        movw BOTTOM_RIGHT_Y_ADDR_OFFSET(%bp), %bx
        movw %gs:(%bx), %cx
        subw %ax, %cx
        incw %cx
        movw %cx, LENGTH_OFFSET(%bp)

        movw TOP_LEFT_X_ADDR_OFFSET(%bp), %bx
        movw %gs:(%bx), %ax
        movw BOTTOM_RIGHT_X_ADDR_OFFSET(%bp), %bx
        movw %gs:(%bx), %cx
        subw %ax, %cx
        incw %cx
        movw %cx, WIDTH_OFFSET(%bp)

        ###########   Update display   ###########

        # %si and %di will hold top left corner's x and y values respectively.
        movw TOP_LEFT_X_ADDR_OFFSET(%bp), %bx
        movw %gs:(%bx), %si
        movw TOP_LEFT_Y_ADDR_OFFSET(%bp), %bx
        movw %gs:(%bx), %di

        # Calculate the location of top left corner and move into %bx
        xorw %dx, %dx
        movw $320, %ax
        mulw %di
        addw %si, %ax
        movw %ax, %bx

        # load color value into %dl
        movb COLOR_OFFSET(%bp), %dl

        # call function to clear/fill rows/columns
        xorw %ax, %ax
        movb DIRECTION_OFFSET(%bp), %al
        subb $2, %al
        movw %ax, %si
        call *_directionFunctions(%si)

    _moveRectEnd:
        movw %bp, %sp
        pop %es
        pop %bx
        pop %bp

        ret
    
    _directionFunctions:
        .word go_down, go_left, go_right, go_up

    .type go_down, @function
    go_down:
        xorw %cx, %cx
        movb SPEED_OFFSET(%bp), %dh
        movb %dh, %cl

        _dclearLoop:
            call clearRow
            addw $320, %bx

            loopw _dclearLoop

        movb LENGTH_OFFSET(%bp), %cl
        subb %dh, %cl
        xorw %ax, %ax

        _dcalcLoop:
            addw $320, %ax
            loopw _dcalcLoop

        addw %ax, %bx
        movb %dh, %cl
        _dfillLoop:
            call fillRow
            addw $320, %bx
            loopw _dfillLoop

        # Update location
        movb %dh, %cl
        movw TOP_LEFT_Y_ADDR_OFFSET(%bp), %bx
        addw %cx, %gs:(%bx)
        movw BOTTOM_RIGHT_Y_ADDR_OFFSET(%bp), %bx
        addw %cx, %gs:(%bx)

        ret

    .type go_left, @function
    go_left:
        xorw %cx, %cx
        movb SPEED_OFFSET(%bp), %dh
        movb %dh, %cl

        _lfillLoop:
            decw %bx
            call fillColumn
            
            loopw _lfillLoop

        addw WIDTH_OFFSET(%bp), %bx
        movb %dh, %cl

        _lclearLoop:
            call clearColumn

            incw %bx
            loopw _lclearLoop

        # Update location
        movb %dh, %cl
        movw TOP_LEFT_X_ADDR_OFFSET(%bp), %bx
        subw %cx, %gs:(%bx)
        movw BOTTOM_RIGHT_X_ADDR_OFFSET(%bp), %bx
        subw %cx, %gs:(%bx)

        ret

    .type go_up, @function
    go_up:
        xorw %cx, %cx
        movb SPEED_OFFSET(%bp), %dh
        movb %dh, %cl

        _ufillLoop:
            subw $320, %bx
            call fillRow

            loopw _ufillLoop

        movb LENGTH_OFFSET(%bp), %cl
        xorw %ax, %ax
        _ucalcLoop:
            addw $320, %ax
            loopw _ucalcLoop
        
        addw %ax, %bx
        movb %dh, %cl

        _uclearLoop:
            call clearRow
            addw $320, %bx

            loopw _uclearLoop

        # Update location
        movb %dh, %cl
        movw TOP_LEFT_Y_ADDR_OFFSET(%bp), %bx
        subw %cx, %gs:(%bx)
        movw BOTTOM_RIGHT_Y_ADDR_OFFSET(%bp), %bx
        subw %cx, %gs:(%bx)

        ret

    .type go_right, @function
    go_right:
        xorw %cx, %cx
        movb SPEED_OFFSET(%bp), %dh
        movb %dh, %cl

        _rclearLoop:
            call clearColumn

            incw %bx
            loopw _rclearLoop

        movb %dh, %cl
        addw WIDTH_OFFSET(%bp), %bx
        subw %cx, %bx
        
        _rfillLoop:
            call fillColumn
            
            incw %bx
            loopw _rfillLoop

        # Update location
        movb %dh, %cl
        movw TOP_LEFT_X_ADDR_OFFSET(%bp), %bx
        addw %cx, %gs:(%bx)
        movw BOTTOM_RIGHT_X_ADDR_OFFSET(%bp), %bx
        addw %cx, %gs:(%bx)

        ret


    # %bx is a video ram location
    .type clearColumn, @function
    clearColumn:
        _clearColumStart:
            push %bx
            push %cx
            push %dx

            movw LENGTH_OFFSET(%bp), %cx
            movb %cs:_background_color, %dl

        _clearColumnLoop:
            movb %dl, %es:(%bx)
            addw $320, %bx

            loopw _clearColumnLoop
        
        clearColumnEnd:
            pop %dx
            pop %cx
            pop %bx
            ret


    # %bx is a video ram location
    .type fillColumn, @function
    fillColumn:
        _fillColumnStart:
            push %bx
            push %cx
            movw LENGTH_OFFSET(%bp), %cx
        
        # This loop will display new pixels
        _displayNewPixels:
            movb %dl, %es:(%bx)
            addw $320, %bx

            loopw _displayNewPixels

        fillColumnEnd:
            pop %cx
            pop %bx
            ret


    # %bx is a video ram location
    .type clearRow, @function
    clearRow:
        _clearRowStart:
            push %bx
            push %cx
            push %dx

            movw WIDTH_OFFSET(%bp), %cx
            movb %cs:_background_color, %dl

        _clearRowLoop:
            movb %dl, %es:(%bx)
            incw %bx

            loopw _clearRowLoop

        _clearRowEnd:
            pop %dx
            pop %cx
            pop %bx
            ret

    # %bx is a video ram location
    .type fillRow, @function
    fillRow:
        _fillRowStart:
            push %bx
            push %cx
            movw WIDTH_OFFSET(%bp), %cx

        _fillRowLoop:  
            movb %dl, %es:(%bx)
            incw %bx

            loopw _fillRowLoop

        _fillRowEnd:
            pop %cx
            pop %bx
            ret



.type registerInterruptHandler, @function
registerInterruptHandler:
    movw $keyboardInterruptHandler, 0x0024
    movw $0x0000, 0x0026

    ret


_lastKey:           .byte 0x00
_curRightKeyStatus: .byte 0x00
_curLeftKeyStatus:  .byte 0x00

keyboardInterruptHandler:
    _keyboardInterruptHandlerStart:
        pusha
    
    _keyboardInterruptHandlerMain:
        inb $0x60, %al

        cmpb $0x4d, %al
        je _right_pressed

        cmpb $0xcd, %al
        je _right_released

        cmpb $0x4b, %al
        je _left_pressed

        cmpb $0xcb, %al
        je _left_released

        movb %al, %cs:_lastKey
        jmp _keyboardInterruptHandlerEnd

        _right_pressed:
            movb $0x01, %cs:_curRightKeyStatus
            jmp _keyboardInterruptHandlerEnd

        _right_released:
            movb $0x00, %cs:_curRightKeyStatus
            jmp _keyboardInterruptHandlerEnd

        _left_pressed:
            movb $0x01, %cs:_curLeftKeyStatus
            jmp _keyboardInterruptHandlerEnd

        _left_released:
            movb $0x00, %cs:_curLeftKeyStatus

    _keyboardInterruptHandlerEnd:
        # Enable further input
        movb $0x20, %al
        outb %al, $0x20

        popa
        iret

.include "functions.s"
.include "CharSet.s"
.fill 16384 - (. - _KernelStart), 1, 0
