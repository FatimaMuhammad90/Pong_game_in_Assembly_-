
INCLUDE Irvine32.inc

SCREEN_WIDTH = 80
SCREEN_HEIGHT = 25
PADDLE_HEIGHT = 4
LEFT_PADDLE_X = 5
RIGHT_PADDLE_X = 74
BALL_START_X = 40
BALL_START_Y = 12
GAME_SPEED = 120      
WIN_SCORE = 5

.data
    leftPaddleY BYTE 10
    rightPaddleY BYTE 10
    oldLeftY BYTE 10     
    oldRightY BYTE 10    
    ballX  BYTE BALL_START_X
    ballY  BYTE BALL_START_Y
    ballDirX SBYTE ?
    ballDirY SBYTE ?
    leftScore BYTE 0
    rightScore BYTE 0
    scoreMsg BYTE "SCORE", 0
    winnerMsg BYTE " WINS!", 0
    playAgainMsg BYTE "Play again? (y/n): ", 0

.code


main PROC
    call Randomize
    call InitializeGame
    
game_loop:
    call ProcessInput
    call ErasePaddle     
    call EraseBall
    call UpdateBall
    call CheckCollisions
    call DrawPaddle       
    call DrawBall
    call DrawScores
   
    mov al, leftPaddleY
    mov oldLeftY, al
    mov al, rightPaddleY
    mov oldRightY, al
    
    mov al, leftScore
    cmp al, WIN_SCORE
    jge game_over
    mov al, rightScore
    cmp al, WIN_SCORE
    jge game_over
    
    mov eax, GAME_SPEED
    call Delay
    jmp game_loop
    
game_over:
    call ShowWinner
    call WaitForKey
    call Clrscr
    
    mov dl, 30
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET playAgainMsg
    call WriteString
    call ReadChar
    cmp al, 'y'
    je restart_game
    cmp al, 'Y'
    je restart_game
    jmp exit_game
    
restart_game:
    call InitializeGame
    jmp game_loop
    
exit_game:
    call Clrscr
    exit
main ENDP


InitializeGame PROC
    call Clrscr
    mov leftPaddleY, 10
    mov rightPaddleY, 10
    mov oldLeftY, 10
    mov oldRightY, 10
    mov ballX, BALL_START_X
    mov ballY, BALL_START_Y
    
    mov eax, 2
    call RandomRange
    cmp eax, 0
    je set_left
    mov ballDirX, 1
    jmp set_y_dir
set_left:
    mov ballDirX, -1
    
set_y_dir:
    mov eax, 2
    call RandomRange
    cmp eax, 0
    je set_up
    mov ballDirY, 1
    jmp done_init
set_up:
    mov ballDirY, -1
    
done_init:
    mov leftScore, 0
    mov rightScore, 0
    call DrawBoundaries
    ret
InitializeGame ENDP


WaitForKey PROC
    call ReadChar
    ret
WaitForKey ENDP


ProcessInput PROC
    pushad
    
    call ReadKey
    jz no_key
   
    cmp al, 'w'
    je left_up
    cmp al, 's'
    je left_down
  
    
    cmp ah, 48h
    je right_up
    cmp ah, 50h
    je right_down
    
    jmp no_key
    
left_up:
    cmp leftPaddleY, 1
    jle no_key
    dec leftPaddleY
    jmp no_key
    
left_down:
    mov al, leftPaddleY
    add al, PADDLE_HEIGHT
    cmp al, SCREEN_HEIGHT - 2
    jge no_key
    inc leftPaddleY
    jmp no_key
    
right_up:
    cmp rightPaddleY, 1
    jle no_key
    dec rightPaddleY
    jmp no_key
    
right_down:
    mov al, rightPaddleY
    add al, PADDLE_HEIGHT
    cmp al, SCREEN_HEIGHT - 2
    jge no_key
    inc rightPaddleY
    
no_key:
    popad
    ret
ProcessInput ENDP

DrawPaddle PROC
    pushad
   
    mov dl, LEFT_PADDLE_X
    mov dh, leftPaddleY
    mov ecx, PADDLE_HEIGHT
draw_left:
    call Gotoxy
    mov al, '|'
    call WriteChar
    inc dh
    loop draw_left

    mov dl, RIGHT_PADDLE_X
    mov dh, rightPaddleY
    mov ecx, PADDLE_HEIGHT
draw_right:
    call Gotoxy
    mov al, '|'
    call WriteChar
    inc dh
    loop draw_right
    
    popad
    ret
DrawPaddle ENDP


ErasePaddle PROC
    pushad
    
    mov dl, LEFT_PADDLE_X
    mov dh, oldLeftY
    mov ecx, PADDLE_HEIGHT
erase_left:
    call Gotoxy
    mov al, ' '
    call WriteChar
    inc dh
    loop erase_left
    
    mov dl, RIGHT_PADDLE_X
    mov dh, oldRightY
    mov ecx, PADDLE_HEIGHT
erase_right:
    call Gotoxy
    mov al, ' '
    call WriteChar
    inc dh
    loop erase_right
    
    popad
    ret
ErasePaddle ENDP


DrawBall PROC
    pushad
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov al, 'O'
    call WriteChar
    popad
    ret
DrawBall ENDP


EraseBall PROC
    pushad
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov al, ' '
    call WriteChar
    popad
    ret
EraseBall ENDP

DrawBoundaries PROC
    pushad
    
    mov dl, 0
    mov dh, 0
    mov ecx, SCREEN_WIDTH


top_border:
    call Gotoxy
    mov al, 205
    call WriteChar
    inc dl
    loop top_border
    
    ; Bottom border
    mov dl, 0
    mov dh, SCREEN_HEIGHT - 1
    mov ecx, SCREEN_WIDTH
bottom_border:
    call Gotoxy
    mov al, 205
    call WriteChar
    inc dl
    loop bottom_border
    
 
    mov dl, 0
    mov dh, 0
    call Gotoxy
    mov al, 201
    call WriteChar
    
    mov dl, SCREEN_WIDTH - 1
    mov dh, 0
    call Gotoxy
    mov al, 187
    call WriteChar
    
    mov dl, 0
    mov dh, SCREEN_HEIGHT - 1
    call Gotoxy
    mov al, 200
    call WriteChar
    
    mov dl, SCREEN_WIDTH - 1
    mov dh, SCREEN_HEIGHT - 1
    call Gotoxy
    mov al, 188
    call WriteChar
    

    mov dl, SCREEN_WIDTH / 2
    mov dh, 1
    mov ecx, SCREEN_HEIGHT - 2
mid_line:
    call Gotoxy
    mov al, 186
    call WriteChar
    inc dh
    loop mid_line
    
    popad
    ret
DrawBoundaries ENDP


DrawScores PROC
    pushad
    
    mov dl, 34
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET scoreMsg
    call WriteString
    
    mov dl, 31
    mov dh, 0
    call Gotoxy
    mov al, leftScore
    add al, '0'
    call WriteChar
    
    mov dl, 41
    mov dh, 0
    call Gotoxy
    mov al, rightScore
    add al, '0'
    call WriteChar
    
    popad
    ret
DrawScores ENDP


UpdateBall PROC
    pushad
    mov al, ballDirX
    add ballX, al
    mov al, ballDirY
    add ballY, al
    popad
    ret
UpdateBall ENDP

; Colliions logic
CheckCollisions PROC
    pushad
   
    cmp ballY, 1
    jle bounce_vertical
    cmp ballY, SCREEN_HEIGHT - 2
    jge bounce_vertical
    jmp check_paddles
    
bounce_vertical:
    neg ballDirY
    jmp collision_done
    
check_paddles:
    mov al, ballX
    cmp al, LEFT_PADDLE_X + 1
    jne check_right_paddle
    
    mov al, ballY
    mov bl, leftPaddleY
    cmp al, bl
    jl check_right_paddle
    add bl, PADDLE_HEIGHT
    cmp al, bl
    jge check_right_paddle
    
    neg ballDirX
    jmp collision_done
    
check_right_paddle:
    mov al, ballX
    cmp al, RIGHT_PADDLE_X - 1
    jne check_miss
    
    mov al, ballY
    mov bl, rightPaddleY
    cmp al, bl
    jl check_miss
    add bl, PADDLE_HEIGHT
    cmp al, bl
    jge check_miss
    
    neg ballDirX
    jmp collision_done
    
check_miss:
    mov al, ballX
    cmp al, 2
    jl right_scores
    cmp al, SCREEN_WIDTH - 2
    jg left_scores
    jmp collision_done
    
right_scores:
    inc rightScore
    call ResetBall
    jmp collision_done
    
left_scores:
    inc leftScore
    call ResetBall
    
collision_done:
    popad
    ret
CheckCollisions ENDP


ResetBall PROC
    pushad
    
    mov ballX, BALL_START_X
    mov ballY, BALL_START_Y

    mov eax, 2
    call RandomRange
    cmp eax, 0
    je reset_left
    mov ballDirX, 1
    jmp reset_y
reset_left:
    mov ballDirX, -1
    
reset_y:
    mov eax, 2
    call RandomRange
    cmp eax, 0
    je reset_up
    mov ballDirY, 1
    jmp reset_done
reset_up:
    mov ballDirY, -1
    
reset_done:
    mov eax, 500
    call Delay
    
    popad
    ret
ResetBall ENDP


ShowWinner PROC
    pushad
    
    call Clrscr
    
    mov dl, 30
    mov dh, 10
    call Gotoxy
    
    mov al, leftScore
    cmp al, WIN_SCORE
    je left_wins
    
    mov al, '2'
    call WriteChar
    mov edx, OFFSET winnerMsg
    call WriteString
    jmp done
    
left_wins:
    mov al, '1'
    call WriteChar
    mov edx, OFFSET winnerMsg
    call WriteString
    
done:
    popad
    ret
ShowWinner ENDP

END main
