.code16

# Char -> (%al)
# Returns the location of char via %si
.type getChar, @function
getChar:
    _getCharStart:
        push %dx
        push %ax
        push %bx

    _getCharCalc:
        xorw %dx, %dx
        xorb %ah, %ah
        movw $2, %bx

        subb $32, %al
        mulw %bx

        movw %ax, %bx

        movw charSet(%bx), %si

    _getCharEnd:
        pop %bx
        pop %ax
        pop %dx

        ret

charSet:
    .word character_space, character_exclamation, character_double_quotes, character_hash, character_dollar
    .word character_percent, character_and, character_single_quote, character_open_paranthesis
    .word character_close_parenthesis, character_asterisk, character_plus, character_comma
    .word character_minus, character_dot, character_slash, character_0, character_1, character_2
    .word character_3, character_4, character_5, character_6, character_7, character_8, character_9
    .word character_colon, character_semi_colon, character_less_than, character_equals_to, character_greater_than
    .word character_question_mark, character_rate
    .word character_A, character_B, character_C, character_D
    .word character_E, character_F, character_G, character_H
    .word character_I, character_J, character_K, character_L
    .word character_M, character_N, character_O, character_P
    .word character_Q, character_R, character_S, character_T, character_U
    .word character_V, character_W, character_X, character_Y, character_Z
    .word character_open_square_bracket, character_back_slash, character_close_square_bracket
    .word character_circumflex, character_underscore, character_apostrophe
    .word character_a, character_b, character_c, character_d
    .word character_e, character_f, character_g, character_h
    .word character_i, character_j, character_k, character_l
    .word character_m, character_n, character_o, character_p
    .word character_q, character_r, character_s, character_t, character_u
    .word character_v, character_w, character_x, character_y, character_z
    .word character_open_curly_braces, character_bar, character_close_curly_braces
    .word character_approximate, character_block

.equ LINE_GAP,         12  # Done


character_space:
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \0"

character_exclamation:
    .ascii " # \n"
    .ascii " # \n"
    .ascii " # \n"
    .ascii " # \n"
    .ascii " # \n"
    .ascii " # \n"
    .ascii "   \n"
    .ascii "   \n"
    .ascii " # \0"

character_double_quotes:
    .ascii "### ###\n"
    .ascii "### ###\n"
    .ascii " #   # \n"
    .ascii "       \n" 
    .ascii "       \n" 
    .ascii "       \n" 
    .ascii "       \0" 

character_hash:
    .ascii "  # #  \n"
    .ascii "  # #  \n"
    .ascii "#######\n"
    .ascii "  # #  \n"
    .ascii "#######\n"
    .ascii "  # #  \n"
    .ascii "  # #  \0"

character_dollar:
    .ascii " ##### \n"
    .ascii "#  #  #\n"
    .ascii "#  #   \n"
    .ascii " ##### \n"
    .ascii "   #  #\n"
    .ascii "#  #  #\n"
    .ascii " ##### \0"

character_percent:
    .ascii "###   #\n"
    .ascii "# #  # \n"
    .ascii "### #  \n"
    .ascii "   #   \n"
    .ascii "  # ###\n"
    .ascii " #  # #\n"
    .ascii "#   ###\0"


character_and:
    .ascii "  ##   \n"
    .ascii " #  #  \n"
    .ascii "  ##   \n"
    .ascii " ###   \n"
    .ascii "#   # #\n"
    .ascii "#    # \n"
    .ascii " #### #\0"

character_single_quote:
    .ascii "  ###  \n"
    .ascii "  ###  \n"
    .ascii "   #   \n"
    .ascii "  #    \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \0"

character_open_paranthesis:
    .ascii "   ##  \n"
    .ascii "  #    \n"
    .ascii " #     \n"
    .ascii " #     \n"
    .ascii " #     \n"
    .ascii "  #    \n"
    .ascii "   ##  \0"

character_close_parenthesis:
    .ascii "  ##   \n"
    .ascii "    #  \n"
    .ascii "     # \n"
    .ascii "     # \n"
    .ascii "     # \n"
    .ascii "    #  \n"
    .ascii "  ##   \0"

character_asterisk:
    .ascii "       \n"
    .ascii " #   # \n"
    .ascii "  # #  \n"
    .ascii "### ###\n"
    .ascii "  # #  \n"
    .ascii " #   # \n"
    .ascii "       \0"

character_plus:
    .ascii "       \n"
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii " ##### \n"
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii "       \0"

character_comma:
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii " ###   \n"
    .ascii " ###   \n"
    .ascii "  #    \n"
    .ascii " #     \0"

character_minus:
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii " ##### \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \0"

character_dot:
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "  ###  \n"
    .ascii "  ###  \n"
    .ascii "  ###  \0"

character_slash:
    .ascii "      #\n"
    .ascii "     # \n"
    .ascii "    #  \n"
    .ascii "   #   \n"
    .ascii "  #    \n"
    .ascii " #     \n"
    .ascii "#      \0"

character_0:
    .ascii "  ###  \n"
    .ascii " #   # \n"
    .ascii "# #   #\n"
    .ascii "#  #  #\n"
    .ascii "#   # #\n"
    .ascii " #   # \n"
    .ascii "  ###  \0"

character_1:
    .ascii "   #   \n"
    .ascii "  ##   \n"
    .ascii " # #   \n"
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii " ##### \0"

character_2:
    .ascii " ##### \n"
    .ascii "#     #\n"
    .ascii "      #\n"
    .ascii " ##### \n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#######\0"

character_3:
    .ascii " ##### \n"
    .ascii "#     #\n"
    .ascii "      #\n"
    .ascii " ##### \n"
    .ascii "      #\n"
    .ascii "#     #\n"
    .ascii " ##### \0"

character_4:
    .ascii "#      \n"
    .ascii "#    # \n"
    .ascii "#    # \n"
    .ascii "#######\n"
    .ascii "     # \n"
    .ascii "     # \n"
    .ascii "     # \0"

character_5:
    .ascii "#######\n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii " ##### \n"
    .ascii "      #\n"
    .ascii "#     #\n"
    .ascii " ##### \0"

character_6:
    .ascii " ##### \n"
    .ascii "#     #\n"
    .ascii "#      \n"
    .ascii "###### \n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii " ##### \0"

character_7:
    .ascii "#######\n"
    .ascii "#    # \n"
    .ascii "    #  \n"
    .ascii "   #   \n"
    .ascii "  #    \n"
    .ascii "  #    \n"
    .ascii "  #    \0"

character_8:
    .ascii " ##### \n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii " ##### \n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii " ##### \0"

character_9:
    .ascii " ##### \n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii " ######\n"
    .ascii "      #\n"
    .ascii "#     #\n"
    .ascii " ##### \0"

character_colon:
    .ascii "       \n"
    .ascii "       \n"
    .ascii "  ##   \n"
    .ascii "  ##   \n"
    .ascii "       \n"
    .ascii "  ##   \n"
    .ascii "  ##   \0"

character_semi_colon:
    .ascii "  ###  \n"
    .ascii "  ###  \n"
    .ascii "       \n"
    .ascii "  ###  \n"
    .ascii "  ###  \n"
    .ascii "   #   \n"
    .ascii "  #    \0"

character_less_than:
    .ascii "    #  \n"
    .ascii "   #   \n"
    .ascii "  #    \n"
    .ascii " #     \n"
    .ascii "  #    \n"
    .ascii "   #   \n"
    .ascii "    #  \0"

character_equals_to:
    .ascii "       \n"
    .ascii "       \n"
    .ascii " ##### \n"
    .ascii "       \n"
    .ascii " ##### \n"
    .ascii "       \n"
    .ascii "       \0"

character_greater_than:
    .ascii "  #    \n"
    .ascii "   #   \n"
    .ascii "    #  \n"
    .ascii "     # \n"
    .ascii "    #  \n"
    .ascii "   #   \n"
    .ascii "  #    \0"

character_question_mark:
    .ascii " ##### \n"
    .ascii "#     #\n"
    .ascii "      #\n"
    .ascii "    ## \n"
    .ascii "   #   \n"
    .ascii "       \n"
    .ascii "   #   \0"

character_rate:
    .ascii " ##### \n"
    .ascii "#     #\n"
    .ascii "# ### #\n"
    .ascii "# # # #\n"
    .ascii "# #### \n"
    .ascii "#     #\n"
    .ascii " ##### \0"

character_A:
    .ascii "   #   \n"   
    .ascii "  # #  \n"   
    .ascii " #   # \n"   
    .ascii "#     #\n"   
    .ascii "#######\n"   
    .ascii "#     #\n"   
    .ascii "#     #\0"   

character_B:
    .ascii "###### \n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "###### \n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "###### \0"

character_C:
    .ascii " ##### \n"
    .ascii "#     #\n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#     #\n"
    .ascii " ##### \0"

character_D:
    .ascii "###### \n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "###### \0"

character_E:
    .ascii "#######\n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#####  \n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#######\0"

character_F:
    .ascii "#######\n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#####  \n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#      \0"

character_G:
    .ascii " ##### \n"
    .ascii "#     #\n"
    .ascii "#      \n"
    .ascii "#  ####\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii " ##### \0"

character_H:
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#######\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\0"

character_I:
    .ascii " ### \n"
    .ascii "  #  \n"
    .ascii "  #  \n"
    .ascii "  #  \n"
    .ascii "  #  \n"
    .ascii "  #  \n"
    .ascii " ### \0"

character_J:
    .ascii "      #\n"
    .ascii "      #\n"
    .ascii "      #\n"
    .ascii "      #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii " ##### \0"

character_K:
    .ascii "#    #\n"   
    .ascii "#   # \n"   
    .ascii "#  #  \n"   
    .ascii "###   \n"   
    .ascii "#  #  \n"   
    .ascii "#   # \n"   
    .ascii "#    #\0"   

character_L:
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#######\0"

character_M:
    .ascii "#     #\n"
    .ascii "##   ##\n"
    .ascii "# # # #\n"
    .ascii "#  #  #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\0"

character_N:
    .ascii "#     #\n"
    .ascii "##    #\n"
    .ascii "# #   #\n"
    .ascii "#  #  #\n"
    .ascii "#   # #\n"
    .ascii "#    ##\n"
    .ascii "#     #\0"

character_O:
    .ascii "#######\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#######\0"

character_P:
    .ascii "###### \n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "###### \n"
    .ascii "#      \n"
    .ascii "#      \n"
    .ascii "#      \0"

character_Q:
    .ascii " ##### \n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#   # #\n"
    .ascii "#    # \n"
    .ascii " #### #\0"

character_R:
    .ascii "###### \n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "###### \n"
    .ascii "#   #  \n"
    .ascii "#    # \n"
    .ascii "#     #\0"

character_S:
    .ascii " ##### \n"
    .ascii "#     #\n"
    .ascii "#      \n"
    .ascii " ##### \n"
    .ascii "      #\n"
    .ascii "#     #\n"
    .ascii " ##### \0"

character_T:
    .ascii "#######\n"
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii "   #   \0"

character_U:
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii " ##### \0"

character_V:
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii "#     #\n"
    .ascii " #   # \n"
    .ascii "  # #  \n"
    .ascii "   #   \0"

character_W:
    .ascii "#     #\n"
    .ascii "#  #  #\n"
    .ascii "#  #  #\n"
    .ascii "#  #  #\n"
    .ascii "#  #  #\n"
    .ascii "#  #  #\n"
    .ascii " ## ## \0"

character_X:
    .ascii "#     #\n"
    .ascii " #   # \n"
    .ascii "  # #  \n"
    .ascii "   #   \n"
    .ascii "  # #  \n"
    .ascii " #   # \n"
    .ascii "#     #\0"

character_Y:
    .ascii "#     #\n"
    .ascii " #   # \n"
    .ascii "  # #  \n"
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii "   #   \0"

character_Z:
    .ascii "#######\n"
    .ascii "     # \n"
    .ascii "    #  \n"
    .ascii "   #   \n"
    .ascii "  #    \n"
    .ascii " #     \n"
    .ascii "#######\0"

character_open_square_bracket:
    .ascii " ##### \n"
    .ascii " #     \n"
    .ascii " #     \n" 
    .ascii " #     \n"
    .ascii " #     \n"
    .ascii " #     \n"            
    .ascii " ##### \0"

character_back_slash:
    .ascii "#      \n"
    .ascii " #     \n"
    .ascii "  #    \n"
    .ascii "   #   \n"
    .ascii "    #  \n"
    .ascii "     # \n"
    .ascii "      #\0"

character_close_square_bracket:
    .ascii " ##### \n"
    .ascii "     # \n"
    .ascii "     # \n"
    .ascii "     # \n"
    .ascii "     # \n"
    .ascii "     # \n"
    .ascii " ##### \0"

character_circumflex:
    .ascii "   #   \n"
    .ascii "  # #  \n"
    .ascii " #   # \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \0"

character_underscore:
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "#######\0"


character_apostrophe:
    .ascii "  ###  \n"
    .ascii "  ###  \n"
    .ascii "   #   \n"
    .ascii "    #  \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \0"


character_a:
    .ascii "     \n"
    .ascii "     \n"
    .ascii " ####\n"
    .ascii "    #\n"
    .ascii "#####\n"
    .ascii "#   #\n"
    .ascii "#####\0"

character_b:
    .ascii "#    \n"
    .ascii "#    \n"
    .ascii "#### \n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#### \0"

character_c:
    .ascii "     \n"
    .ascii "     \n"
    .ascii " ### \n"
    .ascii "#   #\n"
    .ascii "#    \n"
    .ascii "#   #\n"
    .ascii " ### \0"

character_d:
    .ascii "    #\n"
    .ascii "    #\n"
    .ascii " ####\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii " ####\0"

character_e:
    .ascii "     \n"
    .ascii "     \n"
    .ascii " ### \n"
    .ascii "#   #\n"
    .ascii "#### \n"
    .ascii "#    \n"
    .ascii " ### \0"

character_f:
    .ascii " ####\n"
    .ascii "#    \n"
    .ascii "###  \n"
    .ascii "#    \n"
    .ascii "#    \n"
    .ascii "#    \n"
    .ascii "#    \0"

character_g:
    .ascii "     \n"
    .ascii "     \n"
    .ascii " ####\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii " ####\n"
    .ascii "    #\n"
    .ascii " ### \0"

character_h:
    .ascii "#    \n"
    .ascii "#    \n"
    .ascii "#### \n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\0"

character_i:
    .ascii "   \n"
    .ascii " # \n"
    .ascii "   \n"
    .ascii " # \n"
    .ascii " # \n"
    .ascii " # \n"
    .ascii "###\0"

character_j:
    .ascii "     \n"
    .ascii "    #\n"
    .ascii "     \n"
    .ascii "  ###\n"
    .ascii "    #\n"
    .ascii "    #\n"
    .ascii "    #\n"
    .ascii "#   #\n"
    .ascii " ### \0"

character_k:
    .ascii "#    \n"
    .ascii "#    \n"
    .ascii "#  # \n"
    .ascii "# #  \n"
    .ascii "###  \n"
    .ascii "#  # \n"
    .ascii "#   #\0"

character_l:
    .ascii "## \n"
    .ascii " # \n"
    .ascii " # \n"
    .ascii " # \n"
    .ascii " # \n"
    .ascii " # \n"
    .ascii " ##\0"

character_m:
    .ascii "     \n"
    .ascii "     \n"
    .ascii "#####\n"
    .ascii "# # #\n"
    .ascii "# # #\n"
    .ascii "#   #\n"
    .ascii "#   #\0"

character_n:
    .ascii "     \n"
    .ascii "     \n"
    .ascii "#### \n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\0"

character_o:
    .ascii "     \n"
    .ascii "     \n"
    .ascii " ### \n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii " ### \0"

character_p:
    .ascii "     \n"
    .ascii "     \n"
    .ascii " ### \n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#### \n"
    .ascii "#    \n"
    .ascii "#    \0"

character_q:
    .ascii "     \n"
    .ascii "     \n"
    .ascii " ### \n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii " ####\n"
    .ascii "    #\n"
    .ascii "    #\0"

character_r:
    .ascii "     \n"
    .ascii "     \n"
    .ascii " ####\n"
    .ascii "#    \n"
    .ascii "#    \n"
    .ascii "#    \n"
    .ascii "#    \0"

character_s:
    .ascii "     \n"
    .ascii "     \n"
    .ascii " ####\n"
    .ascii "#    \n"
    .ascii " ### \n"
    .ascii "    #\n"
    .ascii "#### \0"

character_t:
    .ascii "  #  \n"
    .ascii "  #  \n"
    .ascii "#####\n"
    .ascii "  #  \n"
    .ascii "  #  \n"
    .ascii "  #  \n"
    .ascii "  ## \0"

character_u:
    .ascii "     \n"
    .ascii "     \n"
    .ascii "#   #\n" 
    .ascii "#   #\n" 
    .ascii "#   #\n"   
    .ascii "#   #\n" 
    .ascii " ### \0"  

character_v:
    .ascii "     \n"
    .ascii "     \n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii " # # \n"
    .ascii "  #  \0"

character_w:
    .ascii "     \n"
    .ascii "     \n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "# # #\n"
    .ascii "## ##\n"
    .ascii "#   #\0"

character_x:
    .ascii "     \n"
    .ascii "     \n"
    .ascii "## ##\n"
    .ascii "  #  \n"
    .ascii "  #  \n"
    .ascii "  #  \n"
    .ascii "## ##\0"

character_y:
    .ascii "     \n"
    .ascii "     \n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii "#   #\n"
    .ascii " ####\n"
    .ascii "    #\n"
    .ascii " ### \0"

character_z:
    .ascii "     \n"
    .ascii "     \n"
    .ascii "#####\n"
    .ascii "   # \n"
    .ascii "  #  \n"
    .ascii " #   \n"
    .ascii "#####\0"

character_open_curly_braces:
    .ascii "  ###  \n" 
    .ascii " #     \n" 
    .ascii " #     \n" 
    .ascii "##     \n"    
    .ascii " #     \n"    
    .ascii " #     \n"    
    .ascii "  ###  \0"    

character_bar:
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii "       \n"
    .ascii "   #   \n"
    .ascii "   #   \n"
    .ascii "   #   \0"

character_close_curly_braces:
    .ascii "  ###  \n"
    .ascii "     # \n"
    .ascii "     # \n"
    .ascii "     ##\n"
    .ascii "     # \n"
    .ascii "     # \n"
    .ascii "  ###  \0"

character_approximate:
    .ascii " ##    \n"
    .ascii "#  #  #\n"
    .ascii "    ## \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \n"
    .ascii "       \0"

character_block:
    .ascii "#######\n"
    .ascii "#######\n"
    .ascii "#######\n"
    .ascii "#######\n"
    .ascii "#######\n"
    .ascii "#######\n"
    .ascii "#######\0"
