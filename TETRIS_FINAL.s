; set inputs.
_set macro pointer, row, column, value
    pusha
    ; push arguments, call set
    mov	ax, column		; ax<-column
    push ax
    mov	ax, row		; ax<-row
    push ax
    mov	bp, pointer		; bp<-pointer
    push bp
    mov	ax, value		; ax<-value
    push ax
    call	set
    popa
endm

; get inputs.
_get macro pointer, row, column
    pusha
    ; push arguments, call get
    mov	ax, column		; ax<-column
    push ax
    mov	ax, row		; ax<-row
    push ax
    mov	bp, pointer		; bp<-pointer
    push bp
    call	get
    popa
endm

; rotate inputs.
_rotate macro row1, col1, mode
    pusha
    ; push arguments, call rotate
    mov	ax, row1	; ax<-row1
    mov	bx, col1	; bx<-col1
    push ax
    push bx
    push mode
    call	rotate
    pop dx
    mov	row1, dx		; row1<-dx
    pop dx
    mov	col1, dx		; col1<-dx
    popa
endm

; mov inputs.
_mov macro mem_d, mem_s
    ; preserve registers
    push ax
    ; push arguments, call mov
    mov	ax, mem_s		; ax<-mem_s
    mov	mem_d, ax		; mem_d<-ax
    ; load registers
    pop ax
endm

; shape inputs.
_shape macro type, pointer, row, column
    pusha
    ; push arguments, call set
    mov	ax, column		; ax<-column
    push ax
    mov	ax, row		; ax<-row
    push ax
    mov	bp, pointer		; bp<-pointer
    push bp
    mov	ax, type		; ax<-type
    push ax
    call	shape
    popa
endm

; transition inputs.
_transition macro mode, direction
    pusha
    ; push arguments, call transition
    mov	ax, direction		; ax<-direction
    push ax
    mov	ax, mode		; ax<-mode
    push ax
    call	transition
    popa
endm

; sort inputs.
_sort macro in1, in2
    ; preserve registers
    push ax
    push bx
    ; push arguments, call set
    mov	ax, in1		; ax<-in1
    push ax
    mov	ax, in2		; ax<-in2
    push ax
    call	sort
    pop ax
    pop bx
    mov	maxout, ax		; maxout<-ax
    mov	minout, bx		; minout<-bx
    ; load registers
    pop bx
    pop ax
endm

; touch inputs.
_touch macro pointer, row, col
    pusha
    ; push arguments, call touch
    mov	ax, col		; bx<-col
    push col
    mov	ax, row		; ax<-row
    push ax
    mov	bp, pointer		; bp<-pointer
    push bp
    call	touch
    popa
endm

; add inputs.
_add macro des, in1, in2
    push ax

    mov	ax, in1		; ax<-in1
    add	ax, in2		; ax<-ax+in2
    mov	des, ax		; des<-ax
    
    pop bx
endm

; shadow inputs.
_shadow macro
    call	shadow
endm

; maxIfZero inputs.
_maxIfZero macro input
    _mov	input1, input		; input1<-input
    call	maxIfZero
    _mov	input, input1		; input<-input1
endm

; drawpixel inputs.
_drawpixel macro row, column, color
    pusha
    ; push arguments
    mov	d_row, row		    ; d_row<-row
    mov	d_col, column		; d_col<-column
    mov	value, color		; value<-color
    mov	dx, d_row		    ; dx<-d_row
    mov	cx, d_col		    ; cx<-d_col
    mov	al, value		    ;
    mov ah, 0ch
    int 10h
    popa
endm

; setGraphicMode inputs.
_setGraphicMode macro 
    push ax
    mov	al, 13h		; al<-13h
    mov	ah, 0		; ah<-0
    int 10h
    pop ax
endm

; draw inputs.
_draw macro pointer, row, column 
    pusha
    mov	ax, column		; ax<-column
    push ax
    mov	ax, row		; ax<-row
    push ax
    mov	bp, pointer		; bp<-pointer
    push bp
    call	draw
    popa
endm

; drawRegion inputs.
_drawRegion macro pointer, start_row, start_col, end_row, end_col
    pusha
    mov	bp, pointer		; bp<-pointer
    push bp
    mov	ax, start_row		; ax<-start_row
    push ax
    mov	ax, start_col		; ax<-start_col
    push ax
    mov	ax, end_row		; ax<-end_row
    push ax
    mov	ax, end_col		; ax<-end_col
    push ax
    call	drawRegion
    popa
endm

; drop inputs.
_drop macro 
    _get offset[screen] r_1 c_1
    _set offset[screen] r_1 c_1 0
    _set offset[screen] r_2 c_2 0
    _set offset[screen] r_3 c_3 0
    _set offset[screen] r_c c_c 0
    _set offset[screen] r_s1 c_s1 output2
    _set offset[screen] r_s2 c_s2 output2
    _set offset[screen] r_s3 c_s3 output2
    _set offset[screen] r_sc c_sc output2
    _mov r_1 r_s1
    _mov c_1 c_s1
    _mov r_2 r_s2
    _mov c_2 c_s2
    _mov r_3 r_s3
    _mov c_3 c_s3
    _mov r_c r_sc
    _mov c_c c_sc
endm

; generate inputs.
_generate macro 
    pusha
    call	generate
    popa
endm

; random inputs.
_random macro ceil
    pusha
    mov ah, 0    ; interrupts to get system time        
    int 1ah      ; CX:DX now hold number of clock ticks since midnight      
    mov  ax, dx
    xor  dx, dx
    mov  cx, ceil    
    div  cx       ; here dx contains the remainder of the division - from 0 to 9
    mov	random, dl		; random<-dl
    popa
endm

; inc inputs.
_inc macro var
    push ax
    mov	ax, var		; ax<-var
    inc ax
    mov	var, ax		; var<-ax
    pop ax
endm

; cmp inputs.
_cmp macro var1, var2
    push ax
    push bx
    mov	ax, var1		; ax<-var1
    mov	bx, var2		; bx<-var2
    cmp ax, bx
    pop bx
    pop ax
endm

; check inputs.
_check macro 
    call	check
endm

; updateMap inputs.
_updateMap macro base, height
    pusha
    mov	ax, base		; ax<-base
    push ax
    mov	ax, height		; ax<-height
    push ax
    call	updateMap
    popa
endm

; checkScreen inputs.
_checkScreen macro 
    pusha
    call	checkScreen
    popa
endm

; checkLine inputs.
_checkLine macro line
    pusha
    mov	ax, line		; ax<-line
    push ax
    call	checkLine
    popa
endm

; getLeftMost inputs.
_getLeftMost macro
    _sort c_1 c_2
    _sort c_3 minout
    _sort c_c minout
    _mov	leftmost, minout		; leftmost<-minout
endm

; getRightMost inputs.
_getRightMost macro
    _sort c_1 c_2
    _sort c_3 maxout
    _sort c_c maxout
    _mov	rightmost, maxout		; rightmost<-maxout
endm

; getUpMost inputs.
_getUpMost macro
    _sort r_1 r_2
    _sort r_3 minout
    _sort r_c minout
    _mov    upmost, minout		; upmost<-minout
endm

; getDownMost inputs.
_getDownMost macro
    _sort r_1 r_2
    _sort r_3 maxout
    _sort r_c maxout
    _mov	downmost, maxout		; downmost<-maxout
endm

; checkPointWithCol inputs.
_checkPointWithCol macro column, direction
    pusha

    mov	ax, column		; ax<-column
    push ax
    mov	ax, direction		; ax<-direction
    push ax
    call	checkPointWithCol

    popa
endm

; checkPointWithRow inputs.
_checkPointWithRow macro row, direction
    pusha

    mov	ax, row		; ax<-row
    push ax
    mov	ax, direction		; ax<-direction
    push ax
    call	checkPointWithRow

    popa
endm

; clearCurrentShape inputs.
_clearCurrentShape macro
    mov	d_ptr, offset[screen]		; d_ptr<-offset[screen]
    _set d_ptr r_1 c_1 0
    _set d_ptr r_2 c_2 0
    _set d_ptr r_3 c_3 0
    _set d_ptr r_c c_c 0
endm

; drawShadow inputs.
_drawShadow macro 
    pusha
    call	drawShadow
    popa
endm

; colorPicker inputs.
_colorPicker macro pointer, row, column
    pusha

    mov	ax, column		; ax<-column
    push ax
    mov	ax, row		; ax<-row
    push ax
    mov	ax, pointer		; ax<-pointer
    push ax
    call	colorPicker
    
    popa
endm

; printNumber inputs.
_printNumber macro
    pusha
    call	printNumber
    popa
endm

; sub inputs.
_sub macro des, in1, in2
    push ax
    push bx
    mov	ax, in1		; ax<-in1
    mov	bx, in2		; bx<-in2
    sub	ax, bx		; ax<-ax-bx
    mov	des, ax		; des<-ax
    pop bx
    pop ax
endm


.data 
    ; initiate a 20x10 matrix for screen
        screen db 200 dup(0)
        row db 20
        row2 dw 20
        col db 10
        col2 dw 10
        MAX dw 66
        score dw 0
        random db ?
        blockwidth dw 10
        blockheight dw 10
        RED dw  4
        GREEN dw 2
        YELLOW dw 14
        BLUE dw 1
        BLACK dw 0
        CYAN dw 3
        MAGENTA dw 5
        current_color dw ?
        shadow_color dw 8; dark-gray
        timer dw 0
        upperrange dw 0FFFFh
        tens dw 02710h,03e8h,064h,000Ah
        ten dw 0Ah
        result_print dw 0

    ; function input vars 
        s_ptr dw ? ; source pointer
        d_ptr dw ? ; destination pointer
        s_row dw ? ; source row
        s_col dw ? ; source column
        d_row dw ? ; destination row
        d_col dw ? ; destination column
        value dw ? ; int value to insert
        dir dw ? ; shape direction
        r_c dw ? ; shape center
        c_c dw ? ; shape center
        r_1 dw ? ; shape first point
        c_1 dw ? ; shape first point
        r_2 dw ? ; shape second point
        c_2 dw ? ; shape second point
        r_3 dw ? ; shape third point
        c_3 dw ? ; shape third point
        r_sc dw ? ; shape center
        c_sc dw ? ; shape center
        r_s1 dw ? ; shape first point
        c_s1 dw ? ; shape first point
        r_s2 dw ? ; shape second point
        c_s2 dw ? ; shape second point
        r_s3 dw ? ; shape third point
        c_s3 dw ? ; shape third point
    ; function ouput vars 
        output1 dw ?
        output2 db ?
        output3 db ?
        output4 dw ?
        output5 dw ?
        leftmost dw ?
        rightmost dw ?
        downmost dw ?
        upmost dw ?
        input1 dw ?
        maxout  dw ?
        minout  dw ?


.code 

main proc far

    mov ax, @data
    mov ds, ax   

    test_start:
        
        ;;;;;_set offset[screen] 2 6 1 ;test passed
        ;;;;;_get offset[screen] 2 5 ;test passed
        ;;;;;_transition 1 1 ;test passed
        ;;;;;_transition 1 2 ;test passed
        ;;;;;_transition 2 1 ;test passed	
        ;;;;;_sort ax bx ;test passed
        ;;;;;_touch offset[screen] r_3 c_3 ;test passed
        ;;;;;_shadow ;test passed ;test passed
        ;;;;;_shape case5 offset[screen] 5 5 ;test passed
        ;;;;;_drawRegion offset[screen] 1 1 20 10 ;test passed

        ;xor bx, bx      ; bx<-0
        ;mov	cx, 2		; cx<-1
        ;;;;;;fill line 3,4
        ;next_fill:
        ;mov	dx, 1		; dx<-1
        ;inc cx
        ;cmp cx, 4
        ;jg end_fill
        ;start_fill:
        ;_random 9
        ;inc random
        ;mov	bl, random		; bl<-random
        ;_set offset[screen] cx dx bx
        ;inc dx
        ;mov	bl, col		; bl<-col
        ;cmp dl, bl
        ;jg next_fill
        ;jmp start_fill
        ;end_fill:

        ;_set offset[screen] 1 5 3
        ;_set offset[screen] 1 9 5
        ;_set offset[screen] 1 1 9
        ;_set offset[screen] 2 1 7
        ;_set offset[screen] 2 5 6
        ;_set offset[screen] 2 9 4
        
        ;_get offset[screen] 7 5 ;passed!
        ;_get offset[screen] 5 5 ;passed!
        ;_get offset[screen] 8 2 ;passed!
        ;_get offset[screen] 3 5 ;passed!

        ;_checkLine 6 ;passed!
        ;_checkLine 5 ;passed!
        ;_checkLine 3 ;passed!
        ;_checkLine 7 ;passed!
        ;_checkLine 8 ;passed!
        ;_checkLine 20 ;passed!

        ;_checkScreen ;passed!!

        ;_updateMap output4 output5 ;passed!

        ;_get offset[screen] 3 5 ;3;passed!
        ;_get offset[screen] 1 5 ;0;passed!
        ;_get offset[screen] 2 1 ;0;passed!
        ;_get offset[screen] 3 9 ;5;passed!
        ;_get offset[screen] 3 1 ;9;passed!
        ;_get offset[screen] 4 1 ;7;passed!
        ;_get offset[screen] 4 5 ;6;passed!
        ;_get offset[screen] 4 9 ;4;passed!

        ;mov	c_1, 1		; c_1<-1
        ;mov	r_1, 1		; r_1<-1
        ;mov	c_2, 2		; c_2<-2
        ;mov	r_2, 1		; r_2<-1
        ;mov	c_3, 3		; c_3<-3
        ;mov	r_3, 1		; r_3<-1
        ;mov	c_c, 2		; c_c<-2
        ;mov	r_c, 2		; r_c<-2

        ;_getLeftMost
        ;_getDownMost
        ;_getRightMost

        ;check left :output1 -> 0
        ;_checkPointWithCol leftmost -1
        
        ;chekc right :output1 -> 1
        ;_checkPointWithCol rightmost 1

        ;mov	c_1, 10		; c_1<-10
        ;mov	r_1, 1		; r_1<-1
        ;mov	c_2, 9		; c_2<-9
        ;mov	r_2, 1		; r_2<-1
        ;mov	c_3, 8		; c_3<-8
        ;mov	r_3, 1		; r_3<-1
        ;mov	c_c, 9		; c_c<-9
        ;mov	r_c, 2		; r_c<-2
        ;_set offset[screen] 1 7 2

        ;_transition 2 3 :moveleft must fail : passed!
        ;_transition 2 1 :moveright must fail : passed!
        ;_transition 2 4 :movedown must pass : passed!
        

    test_end:

    _setGraphicMode
    _generate
    _shadow
    _drawRegion offset[screen] 1 1 20 10

    play_loop:

        _inc timer
        _check
        
        mov	ah, 1		; ah<-1
        int 16h
        
        
        cmp al, 'a'
        je move_left
        cmp al, 'd'
        je move_right
        cmp al, 's'
        je move_down
        cmp al, 'w'
        je rotate_clockwise
        cmp al, 'f'
        je place_shadow
        
        _cmp timer upperrange
        jne play_loop
        mov	timer, 0		; timer<-0 reset timer
        ; peice will go down automatically!
        _transition 2 4
        jmp update_screen
        
        jmp play_loop
        
        move_left:
        _transition 2 3
        _shadow
        jmp update_screen
        move_right:
        _transition 2 1
        _shadow
        jmp update_screen
        move_down:
        _transition 2 4
        jmp update_screen
        rotate_clockwise:
        _transition 1 1
        _shadow
        jmp update_screen
        place_shadow:
        _drop
        jmp update_screen
        
        
        update_screen:
        _check
        _checkScreen
        _updateMap output4 output5 
        skip9:
        
        _drawRegion offset[screen] 1 1 20 10
        _drawShadow
        _mov result_print score
        _printNumber
        
        ; flush keyboard buffer
        mov ah,0ch
        mov al,0
        int 21h
        
        jmp play_loop
    end_play_loop:


    mov ax, 4c00h
    int 21h 

main endp






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about printNumber:
;input result_print 
;
    printNumber	PROC	NEAR
    pop si
    
    mov	dl, 20
    mov	dx, 12
    mov  ah, 2                
    mov  bh, 0                
    int  10h                  

    mov	bp, offset tens	    ; bx<-offset tens
    mov	cx, 04h		; cx<-04h

    begin:

    cmp cx, 0h
    je end2

    mov	ax, result_print		; ax<-result_print
    mov	bx, word ptr [bp]		; bx<-word ptr [bp]
    xor dx, dx
    div bx
    mov	bx, ten		; bx<-ten
    xor dx, dx
    div bx
    mov	ax, dx		; ax<-dx

    cmp ax, 0000h
    je not_zero
    add	ax, 30h		; ax<-ax+30h
    mov  bl, 0Ch  ;Color is red
    mov  bh, 0    ;Display page
    mov  ah, 0Eh  ;Teletype
    int  10h

    not_zero:
    add	bp, 02h		; bp<-bp+02h
    dec cx
    jmp begin


    end2:

    mov	ax, result_print		; ax<-result_print
    sub	bp, 02h		; bp<-bp-02h
    mov	bx, word ptr [bp]		; bx<-word ptr [bp]
    xor dx, dx
    div bx
    add	dx, 30h		; dx<-dx+30h
    mov	ax, dx		; ax<-dx
    mov  bl, 0Ch  ;Color is red
    mov  bh, 0    ;Display page
    mov  ah, 0Eh  ;Teletype
    int  10h

    push si
    RET
    printNumber	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about set:
; arg3[arg2, arg1] <- arg4
;
    set	PROC	NEAR

    pop dx
    pop cx
    pop bp
    pop ax
    dec ax
    mul col
    pop bx
    dec bx
    add	ax, bx		; ax<-ax+bx
    add	bp, ax		; bp<-bp+ax
    mov	[bp], cl		; [bp]<-cl

    push dx
    RET
    set	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about get:
; output1 <- arg3[arg2, arg1], lower part is lower index
;
    get	PROC	NEAR

    pop di
    pop bp
    pop ax
    dec ax
    mul col
    pop bx
    dec bx
    add	ax, bx		; ax<-ax+bx
    add	bp, ax		; bp<-bp+ax
    mov	ax, [bp]		; ax<-[bp]
    mov	output2, al		; output1<-al
    
    push di
    RET
    get	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about shape:
; shape (arg4) with direction(1) starts in pose arg3[arg2, arg1] just in array
;    (1)        (2)         (3)        (4)     (5) 
; ¦¦ ¦¦ ¦¦   ¦¦ ¦¦ ¦¦   ¦¦ ¦¦ ¦¦ ¦¦   ¦¦ ¦¦   ¦¦   
;    ¦¦            ¦¦                 ¦¦ ¦¦   ¦¦ ¦¦
;                                                ¦¦
;                 2
; directions   3<-+->1     value is current_color 
;                 4
;
    shape	PROC	NEAR

    pop di
    pop cx
    pop bp
    pop ax
    pop bx
    mov	d_ptr, bp		; d_ptr<-bp
    mov	d_row, ax		; d_row<-ax
    mov	d_col, bx		; d_col<-bx
    _mov	value, current_color		; value<-current_color
    mov	dir, 1		; dir<-1
    jmp cx
    case1:
        _mov	c_1 d_col		; c_1<-d_col
        _mov	r_1 d_row		; r_1<-d_row            
        _set d_ptr d_row d_col value

        inc d_col
        _mov	c_c d_col		; c_1<-d_col
        _mov	r_c d_row		; r_1<-d_row
        _set d_ptr d_row d_col value

        inc d_col
        _mov	c_2 d_col		; c_2<-d_col
        _mov	r_2 d_row		; r_2<-d_row
        _set d_ptr d_row d_col value

        dec d_col
        inc d_row
        _mov	c_3 d_col		; c_3<-d_col
        _mov	r_3 d_row		; r_3<-d_row
        _set d_ptr d_row d_col value
    jmp exit1
    case2:
        _mov	c_1 d_col		; c_1<-d_col
        _mov	r_1 d_row		; r_1<-d_row     
        _set d_ptr d_row d_col value

        inc d_col
        _mov	c_c d_col		; c_c<-d_col
        _mov	r_c d_row		; r_c<-d_row     
        _set d_ptr d_row d_col value

        inc d_col
        _mov	c_2 d_col		; c_2<-d_col
        _mov	r_2 d_row		; r_2<-d_row     
        _set d_ptr d_row d_col value

        inc d_row
        _mov	c_3 d_col		; c_3<-d_col
        _mov	r_3 d_row		; r_3<-d_row     
        _set d_ptr d_row d_col value
    jmp exit1
    case3:
        _mov	c_1 d_col		; c_1<-d_col
        _mov	r_1 d_row		; r_1<-d_row     
        _set d_ptr d_row d_col value

        inc d_col
        _mov	c_c d_col		; c_c<-d_col
        _mov	r_c d_row		; r_c<-d_row     
        _set d_ptr d_row d_col value

        inc d_col
        _mov	c_2 d_col		; c_2<-d_col
        _mov	r_2 d_row		; r_2<-d_row
        _set d_ptr d_row d_col value

        inc d_col
        _mov	c_3 d_col		; c_3<-d_col
        _mov	r_3 d_row		; r_3<-d_row
        _set d_ptr d_row d_col value
    jmp exit1
    case4:
        _mov	c_c d_col		; c_c<-d_col
        _mov	r_c d_row		; r_c<-d_row
        _set d_ptr d_row d_col value

        inc d_col
        _mov	c_1 d_col		; c_1<-d_col
        _mov	r_1 d_row		; r_1<-d_row
        _set d_ptr d_row d_col value

        inc d_row
        _mov	c_2 d_col		; c_2<-d_col
        _mov	r_2 d_row		; r_2<-d_row
        _set d_ptr d_row d_col value

        dec d_col
        _mov	c_3 d_col		; c_3<-d_col
        _mov	r_3 d_row		; r_3<-d_row
        _set d_ptr d_row d_col value
    jmp exit1
    case5:
        _mov	c_1 d_col		; c_1<-d_col
        _mov	r_1 d_row		; r_1<-d_row
        _set d_ptr d_row d_col value

        inc d_row
        _mov	c_c d_col		; c_c<-d_col
        _mov	r_c d_row		; r_c<-d_row
        _set d_ptr d_row d_col value

        inc d_col
        _mov	c_2 d_col		; c_2<-d_col
        _mov	r_2 d_row		; r_2<-d_row
        _set d_ptr d_row d_col value

        inc d_row
        _mov	c_3 d_col		; c_3<-d_col
        _mov	r_3 d_row		; r_3<-d_row
        _set d_ptr d_row d_col value
    exit1:

    push di
    RET
    shape	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about checkPointWithCol:
; check piece points with col(arg1) in direction(arg2)
; store result in output1, 0:legal, 1:illegal
;
    checkPointWithCol	PROC	NEAR
    pop bp

    pop bx ;direction
    pop ax ;column

    ; new column in output1
    add	bx, ax		; bx<-bx+ax
    mov	output1, bx		; output1<-bx

    ; check conditions
    _cmp bx col2
    jg fail
    _cmp bx 1
    jl fail

    
    cmp ax, c_1
    jne skip4
    _get offset[screen] r_1 output1
    cmp output2, 0
    jne fail
    skip4:
    cmp ax, c_2
    jne skip5
    _get offset[screen] r_2 output1
    cmp output2, 0
    jne fail
    skip5:
    cmp ax, c_3
    jne skip6
    _get offset[screen] r_3 output1
    cmp output2, 0
    jne fail
    skip6:
    cmp ax, c_c
    jne skip7
    _get offset[screen] r_c output1
    cmp output2, 0
    jne fail
    skip7:
    success:
    mov	output1, 1		; output1<-1
    jmp exit7
    fail:
    mov	output1, 0		; output1<-0
    exit7:

    push bp
    RET
    checkPointWithCol	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about checkPointWithRow:
; check piece points with row(arg1) in direction(arg2)
; store result in output1, 0:legal, 1:illegal
;
    checkPointWithRow	PROC	NEAR
    pop bp

    pop bx ;direction
    pop ax ;row

    ; new row in output1
    add	bx, ax		; bx<-bx+ax
    mov	output1, bx		; output1<-bx

    ; check conditions
    _cmp bx row2
    jg fail1
    _cmp bx 1
    jl fail1


    cmp ax, r_1
    jne skip8
    _get offset[screen] output1 c_1
    cmp output2, 0
    jne fail1
    skip8:
    cmp ax, r_2
    jne skip10
    _get offset[screen] output1 c_2
    cmp output2, 0
    jne fail1
    skip10:
    cmp ax, r_3
    jne skip11
    _get offset[screen] output1 c_3
    cmp output2, 0
    jne fail1
    skip11:
    cmp ax, r_c
    jne skip12
    _get offset[screen] output1 c_c
    cmp output2, 0
    jne fail1
    skip12:
    success1:
    mov	output1, 1		; output1<-1
    jmp exit8
    fail1:
    mov	output1, 0		; output1<-0
    exit8:

    push bp
    RET
    checkPointWithRow	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about transition:
; moves current shape with (r_c,c_c,dir) with mode(arg2) in direction(arg1)
; mode1 : rotation 1:clock-wise 2:counter-clock-wise
; mode2 : translation 1:right 3:left 4:down
;
    transition	PROC	NEAR

    pop di

    pop cx
    cmp cx, 1
    je rotation
    jmp translation


    rotation:
        _clearCurrentShape
        ; store shape info for reset if not_ suitable for rotation
            _mov	r_s1  r_1		; r_s1<-r_1
            _mov	c_s1  c_1		; c_s1<-c_1
            _mov	r_s2  r_2		; r_s2<-r_2
            _mov	c_s2  c_2		; c_s2<-c_2
            _mov	r_s3  r_3		; r_s3<-r_3
            _mov	c_s3  c_3		; c_s3<-c_3
            _mov	r_sc  r_c		; r_sc<-r_c
            _mov	c_sc  c_c		; c_sc<-c_c
        ; end of store
        
        pop cx
        cmp cx, 1
        je clockwise
        jmp counterclockwise
        clockwise:
        mov	cx, 1		; cx<-1     
        jmp continue1
        counterclockwise:
        mov	cx, 2		; cx<-2
        continue1:
            _rotate r_1 c_1 cx 
            _rotate r_2 c_2 cx 
            _rotate r_3 c_3 cx

            ; check condition
            _getRightMost
            ; check boundary condition
            _cmp rightmost col2
            je do_not_change_pose
            ; check rightmost pose
            _checkPointWithCol rightmost 1
            cmp output1, 0
            je do_not_change_pose
            _getLeftMost
            ; check boundary condition
            cmp leftmost, 1
            je do_not_change_pose
            ; check leftmost pose
            _checkPointWithCol leftmost -1
            cmp output1, 0
            je do_not_change_pose
            jmp change_pose_skip

            do_not_change_pose:
            _mov	r_1  r_s1		; r_1<-r_s1
            _mov	c_1  c_s1		; c_1<-c_s1
            _mov	r_2  r_s2		; r_2<-r_s2
            _mov	c_2  c_s2		; c_2<-c_s2
            _mov	r_3  r_s3		; r_3<-r_s3
            _mov	c_3  c_s3		; c_3<-c_s3
            _mov	r_c  r_sc		; r_c<-r_sc
            _mov	c_c  c_sc		; c_c<-c_sc

            change_pose_skip:
            _set d_ptr r_1 c_1 current_color         
            _set d_ptr r_2 c_2 current_color         
            _set d_ptr r_3 c_3 current_color         
            _set d_ptr r_c c_c current_color
    jmp exit

    translation:
        pop cx

        check_condirion:
        cmp cx, 1
        je righ_condition
        cmp cx, 3
        je left_condition
        cmp cx, 4
        je down_condition
        
        righ_condition:

            _getRightMost
            ; check boundary condition
            _cmp rightmost col2
            je exit
            ; check rightmost pose
            _checkPointWithCol rightmost 1
            cmp output1, 0
            je exit

        jmp end_check_condirion
        left_condition:

            _getLeftMost
            ; check boundary condition
            cmp leftmost, 1
            je exit
            ; check leftmost pose
            _checkPointWithCol leftmost -1
            cmp output1, 0
            je exit
            
        jmp end_check_condirion
        down_condition:


        jmp end_check_condirion
        end_check_condirion:

            check_looser:  
                _getDownMost
                cmp downmost, 2
                jg skip_looser
                _sub output1 r_s1 r_1
                cmp output1, 1
                jg end_looser
                _sub output1 r_s2 r_2
                cmp output1, 1
                jg end_looser
                _sub output1 r_s3 r_3
                cmp output1, 1
                jg end_looser
                _sub output1 r_sc r_c
                cmp output1, 1
                jg end_looser
                
                mov	cx, 1		; cx<-1
                mov	dx, 1		; dx<-1
                lose_screen:
                    _set offset[screen] dx cx GREEN
                    inc cx
                    _cmp cx col2
                    jle lose_screen
                    mov	cx, 1		; cx<-1
                    inc dx
                    _cmp dx row2
                    jle lose_screen
                    _drawRegion offset[screen] 1 1 row2 col2

                xor ax, ax
                mov     cx, 0fh
                mov     dx, 4240h
                mov     ah, 86h
                int     15h
                
                mov ah, 4ch
                int 21h 
            end_looser:

        skip_looser:

        
        _clearCurrentShape

        cmp cx, 1
        je right
        cmp cx, 3
        je left
        jmp down
        right:
            mov	ax, 1		; ax<-1
            xor bx, bx      ; bx<-0
        jmp continue2
        left:
            mov	ax, -1		; ax<-(-1)
            xor bx, bx      ; bx<-0
        jmp continue2
        down:
            xor ax, ax      ; ax<-0
            mov	bx, 1		; bx<-1
        continue2:
            add	r_1, bx		; r_1<-r_1+bx
            add	c_1, ax		; c_1<-c_1+ax
            _set d_ptr r_1 c_1 current_color

            add	r_2, bx		; r_1<-r_2+bx
            add	c_2, ax		; c_1<-c_2+ax
            _set d_ptr r_2 c_2 current_color

            add	r_3, bx		; r_1<-r_3+bx
            add	c_3, ax		; c_1<-c_3+ax
            _set d_ptr r_3 c_3 current_color

            add	r_c, bx		; r_c<-r_c+bx
            add	c_c, ax		; c_c<-c_c+ax
            _set d_ptr r_c c_c current_color
    jmp exit

    exit:
    push di
    RET
    transition	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about rotate:
; set(r_c,c_c) as center of rotation,rotate(arg1, arg2)
; rotation mode set with (arg3)
; mode1 90, mode2 -90
;
    rotate	PROC	NEAR

    pop si
    pop cx
    
    ; initiate
    pop ax ;col
    pop bx ;row
    mov	dx, c_c		; dx<-c_c
    sub	ax, dx		; ax<-ax-dx
    mov	dx, r_c		; dx<-r_c
    sub	bx, dx		; bx<-bx-dx
    xchg ax, bx

    cmp cx, 1
    je cwr
    jmp ccwr

    cwr:
        xor cx,cx
        sub	cx, ax		; cx<-cx-ax
        mov	ax, cx		; ax<-cx
        mov	dx, dir		; dx<-dir
        dec dx
        cmp dx, 0
        jne skip1
        add	dx, 4		; dx<-dx+4
        skip1:
        mov	dir, dx		; dir<-dx
    jmp rexit
    ccwr:
        xor cx,cx
        sub	cx, bx		; cx<-cx-bx
        mov	bx, cx		; bx<-cx
        mov	dx, dir		; dx<-dir
        inc dx
        cmp dx, 4
        jne skip2
        sub	dx, 4		; dx<-dx-4
        skip2:
        mov	dir, dx		; dir<-dx
    jmp rexit
    rexit:

    ;finalize
    mov	dx, c_c		; dx<-c_c
    add	ax, dx		; ax<-ax+dx
    mov	dx, r_c		; dx<-r_c
    add	bx, dx		; bx<-bx+dx
    push ax
    push bx

    push si
    RET
    rotate	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about shadow:
; find shadow for current point by finding y_boundary, delta_y for current piece
;
    shadow	PROC	NEAR
    push di

    ; find min y for y_boundary, it will locate in minout
    _touch offset[screen] r_1 c_1
    mov	bx, output1		; bx<-output1
    _maxIfZero bx
    _touch offset[screen] r_2 c_2
    mov	cx, output1		; cx<-output1
    _maxIfZero cx
    _sort bx cx
    mov	bx, minout		; bx<-minout
    _touch offset[screen] r_3 c_3
    mov	cx, output1		; cx<-output1
    _maxIfZero cx
    _sort bx cx
    mov	bx, minout		; bx<-minout
    _touch offset[screen] r_c c_c
    mov	cx, output1		; cx<-output1
    _maxIfZero cx
    _sort bx cx

    ; calculate shadow points
    _add r_s1 r_1 minout
    _add r_s2 r_2 minout
    _add r_s3 r_3 minout
    _add r_sc r_c minout
    _mov	c_s1, c_1		; c_s1<-c_1
    _mov	c_s2, c_2		; c_s1<-c_2
    _mov	c_s3, c_3		; c_s1<-c_3
    _mov	c_sc, c_c		; c_s1<-c_c


    pop di
    RET
    shadow	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about sort:
; sorts its inputs(arg1, arg2), max on top
;
    sort	PROC	NEAR
    pop si

    pop ax
    pop bx
    cmp ax, bx
    jge no_exchange
    xchg ax, bx
    no_exchange:
    push bx
    push ax

    push si
    RET
    sort	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about touch:
; find delta_y between this point y arg3(arg2, arg1), nearest floor point
; 
    touch	PROC	NEAR
    pop si

    xor ax, ax
    pop dx
    pop cx
    pop bx
    
    loop1:
    inc cx
    _get dx cx bx
    cmp output2, 0
    jne end1
    inc ax
    mov	ah, row		; ah<-row
    cmp cl, ah
    je end1
    xor ah, ah
    jmp loop1
    end1:

    xor ah, ah
    mov	output1, ax		; output1<-ax

    push si
    RET
    touch	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about maxIfZero:
;
    maxIfZero	PROC	NEAR
    push ax

    mov	ax, input1		; ax<-input1
    cmp input1, 0
    jne skip3
    _mov	input1, MAX		; input1<-MAX
    skip3:

    pop ax
    RET
    maxIfZero	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about colorPicker:
; returns the color of the arg3[arg2, arg1] and_ save into value variable
;
    colorPicker	PROC	NEAR
    pop si

    pop bp
    pop bx
    pop cx

    ; check if point is shadow
    _cmp bx r_s1
    jne not_point1
    _cmp cx c_s1
    je shadow_point
    not_point1:
    _cmp bx r_s2
    jne not_point2
    _cmp cx c_s2
    je shadow_point
    not_point2:
    _cmp bx r_s3
    jne not_point3
    _cmp cx c_s3
    je shadow_point
    not_point3:
    _cmp bx r_sc
    jne not_pointc
    _cmp cx c_sc
    je shadow_point
    not_pointc:
    jmp exit_check
    shadow_point:
    _mov value shadow_color
    jmp end_color_pick
    exit_check:

    _get offset[screen] bx cx
    mov	dx, output2		; dx<-output2  
    xor dh, dh
    mov	value, dx		; value<-dx

    end_color_pick:
    push si
    RET
    colorPicker	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about draw:
; will draw the block in arg3[arg2, arg1] with color of value
;
    draw	PROC	NEAR
    pop si

    pop bp ;pointer
    pop bx ;row in bl
    pop cx ;col in bh
    _colorPicker bp bx cx
    mov	dx, value		; dx<-value

    mov	bh, cl		; bh<-cl

    dec bh
    mov	al, blockwidth		; al<-blockwidth
    mul bh
    mov	cx, ax		; cx<-ax start col screen
    
    dec bl
    mov	al, blockheight		; al<-blockheight
    mul bl
    mov	bx, ax		; bx<-ax start row screen
    
    xor ax, ax
    
    startrow:
    _drawpixel bx cx dx
    inc al
    inc bx
    push dx
    mov	dx, blockwidth		; dx<-blockwidth
    cmp al, dl
    je nextcol
    pop dx
    jmp startrow
    nextcol:
    inc ah
    inc cx
    mov	dx, blockheight		; dx<-blockheight
    cmp ah, dl
    je exit4
    pop dx
    sub	bl, al		; bl<-bl-al
    xor al, al

    jmp startrow
    
    exit4:
    pop dx
    exit2:
    
    push si
    RET
    draw	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about drawShadow:
;
    drawShadow	PROC	NEAR
    pop bp

    _mov value shadow_color
    _draw offset[screen] r_s1 c_s1
    _draw offset[screen] r_s2 c_s2
    _draw offset[screen] r_s3 c_s3
    _draw offset[screen] r_sc c_sc

    push bp
    RET
    drawShadow	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about drawRegion:
; draw region of (arg1) array with start [arg2,arg3], end [arg4,arg5]
; use value of the array to choose the color
;
    drawRegion	PROC	NEAR
    pop si

    pop ax ; al for end_col
    pop bx ; ah for end_row
    mov	ah, bl		; ah<-bl
    
    pop bx ; bl for start_col
    pop cx ; bh for start_row
    mov	bh, cl		; bh<-cl

    xor cx, cx
    mov	cl, bl		; cl<-bl cx for current_col
    xor dx, dx
    mov	dl, bh		; dl<-bh dx for current_row    

    next_col:
    _draw offset[screen] dx cx
    inc cx
    cmp cl, al
    jg next_row
    jmp next_col
    next_row:
    inc dx
    cmp dl, ah
    jg exit3
    mov	cl, bl		; cl<-bl
    jmp next_col
    
    exit3:
    push si
    RET
    drawRegion	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about generate:
; generate a random shape with random color
;
    generate	PROC	NEAR
    _random 6
    mov	al, random		; al<-random
    cmp al, 0
    je redc
    cmp al, 1
    je greenc
    cmp al, 2
    je yellowc
    cmp al, 3
    je bluec
    cmp al, 4
    je cyanc
    cmp al, 5
    je magentac

    redc:
    _mov	current_color, RED
    jmp shape_choice
    greenc:
    _mov	current_color, GREEN
    jmp shape_choice
    yellowc:
    _mov	current_color, YELLOW
    jmp shape_choice
    bluec:
    _mov	current_color, BLUE
    jmp shape_choice
    cyanc:
    _mov	current_color, CYAN
    jmp shape_choice
    magentac:
    _mov	current_color, MAGENTA

    shape_choice:

    _random 5
    mov	al, random		; al<-random
    cmp al, 0
    je shape1
    cmp al, 1
    je shape2
    cmp al, 2
    je shape3
    cmp al, 3
    je shape4
    cmp al, 4
    je shape5

    shape1:
    _shape case1 offset[screen] 1 5
    jmp exit5
    shape2:
    _shape case2 offset[screen] 1 5
    jmp exit5
    shape3:
    _shape case3 offset[screen] 1 5
    jmp exit5
    shape4:
    _shape case4 offset[screen] 1 5
    jmp exit5
    shape5:
    _shape case5 offset[screen] 1 5
    jmp exit5
    exit5:
    RET
    generate	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about check:
;
;
    check	PROC	NEAR
    pop bp

    ; check for piece placement
    _cmp r_1 r_s1
    jl not_located
    _cmp r_2 r_s2
    jl not_located
    _cmp r_3 r_s3
    jl not_located
    _cmp r_c r_sc
    jl not_located
    _drop
    _generate
    _shadow


    not_located:
    push bp
    RET
    check	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about checkLine:
; check the (arg1)th line
; if output2 is not_ zero then line is full
;
    checkLine	PROC	NEAR
    pop bp

    pop dx
    xor cx, cx
    xor bx, bx
    scan1:
    inc cx
    mov	bl, col		; bx<-col
    cmp cx, bx
    jg exit6
    _get offset[screen] dx cx
    cmp output2, 0
    jne scan1
    mov	output2, 0		; output2<-0
    exit6:

    push bp
    RET
    checkLine	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about checkScreen:
;
;
    checkScreen	PROC	NEAR
    pop bp

    xor bx, bx
    xor al, al      ; number of first row, al for y
    xor cx, cx      ; counter for lines ; ch for delta_y
    mov	cl, row		; cl<-row
    scan:
    cmp cl, 0
    je scan_end
    mov	bl, cl		; bl<-cl
    _checkLine bx
    cmp ch, 0
    jne last_chance
    search:
    cmp output2, 0
    jne change_phase
    jmp continue3
    last_chance:
    cmp output2, 0
    je scan_end
    change_phase:
    inc ch
    set_first:
    cmp al, 0
    jne continue3
    mov	al, cl		; al<-cl
    continue3:
    dec cl
    jmp scan
    scan_end:

    
    xor ah, ah
    mov	cl, ch		; cl<-ch
    xor ch, ch
    mov	output4, ax		; output4<-y1
    mov	output5, cx		; output5<-delta_y

    ; update player score
    cmp cx, 0
    je no_gain
    add	score, 10		; score<-score+10
    dec cx
    mov	ax, cx		; ax<-cx
    mov	dx, 20		; dx<-20
    mul dx
    mov	dx, ax		; dx<-ax
    _add score score dx
    _sub upperrange upperrange score
    no_gain:

    push bp
    RET
    checkScreen	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description about updateMap:
; starts from line(arg1) then collapse(arg2) above lines
;
    updateMap	PROC	NEAR
    pop bp

    pop cx ; cl for delta_y
    pop dx ; ch for y1

    cmp cx, 0
    je shift_exit
    cmp dx, 0
    je shift_exit


    mov	ch, dl		; ch<-dl
    xor bx, bx
    mov	al, cl		; al copy of delta_y
    mov	ah, ch		; ah copy of y1
    
    
    ; remove lines passed!
    inc ch
    start_remove:
    mov	dl, col		; dl<-col
    dec ch
    remove_line:
    mov	bx, ch		; bx<-ch
    _set offset[screen] bx dx 0
    dec dl
    cmp dl, 0
    je remove_next_line
    jmp remove_line
    remove_next_line:
    dec al
    cmp al, 0
    jne start_remove
    end_remove:


    ;shift upper part down
    mov	bx, 0		; bx<-0 ,use bx for col
    start_shift:
    ;cl value is delta_y
    inc bx
    xor dx, dx
    mov	dl, col		; dl<-col
    cmp bx, dx
    jg shift_end
    mov	ch, ah		; ch<-ah ,ch value is y1
    mov	al, ch		; ch is lower part
    sub	al, cl		; al is upper part
    
    ;check [bx, al] element, if not_ zero swap, else go to next column
    xor dx, dx
    mov	dl, al		; dl<-al

    shift_rows:
    cmp dx, 0
    je start_shift
    _get offset[screen] dx bx
    _set offset[screen] dx bx 0
    add	dl, cl		; dl<-dl+cl
    _set offset[screen] dx bx output2
    sub	dl, cl		; dl<-dl-cl
    dec dl
    cmp dl, 0
    je start_shift
    jmp shift_rows
    shift_end:
    inc r_1
    _set offset[screen] r_1 c_1 0
    ;dec r_1
    inc r_2
    _set offset[screen] r_2 c_2 0
    ;dec r_2
    inc r_3
    _set offset[screen] r_3 c_3 0
    ;dec r_3
    inc r_c
    _set offset[screen] r_c c_c 0
    ;dec r_c
    shift_exit:


    push bp
    RET
    updateMap	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




end main