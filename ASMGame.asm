; by Ben Bollinger

INCLUDE Irvine32.inc

.data

strWelcome BYTE "Welcome to an x86 Assembly Game by Ben Bollinger (WASD to move, x to exit)",0
strLine BYTE "--------------------------------------------------------------------------",0

inputChar BYTE ?

xPos BYTE ?
yPos BYTE ?

.code
main PROC
	; display welcome message:
	mov  dl,1
	mov  dh,0
	call Gotoxy
	mov edx,OFFSET strWelcome
	call WriteString
	mov  dl,1
	mov  dh,1
	call Gotoxy
	mov edx,0
	mov edx,OFFSET strLine
	call WriteString

	; set init player position:
	mov xPos,10
	mov yPos,10

	; start game loop:
	gameLoop:
		call ReadChar
		mov inputChar,al

		; check for game exit:
		cmp inputChar,"x"
		je exitGame

		; check for 'w' (up):
		cmp inputChar,119
		je moveUp
		
		; check for 's' (down):
		cmp inputChar,115
		je moveDown

		; check for 'd' (right):
		cmp inputChar,100
		je moveRight

		; check for 'a' (left):
		cmp inputChar,97
		je moveLeft

		; move the player up:
		moveUp:
			; clear current player location:
			call RefreshPlayer

			; decrement yPos (move up) and draw Player:
			dec yPos
			call DrawPlayer
			
			; reset input and repeat loop:
			mov inputChar,0
			jmp gameLoop

		; move the player down:
		moveDown:
			; clear current player location:
			call RefreshPlayer

			; increment yPos (move down) and draw Player:
			inc yPos
			call DrawPlayer

			; reset input and repeat loop:
			mov inputChar,0
			jmp gameLoop

		; move the player right:
		moveRight:
			; clear current player location:
			call RefreshPlayer

			; increment yPos (move down) and draw Player:
			inc xPos
			call DrawPlayer

			; reset input and repeat loop:
			mov inputChar,0
			jmp gameLoop

		; move the player left:
		moveLeft:
			; clear current player location:
			call RefreshPlayer

			; increment yPos (move down) and draw Player:
			dec xPos
			call DrawPlayer

			; reset input and repeat loop:
			mov inputChar,0
			jmp gameLoop

		jmp gameLoop

	exitGame:
	exit
main ENDP

; clear current player so to draw at new location:
RefreshPlayer PROC
	mov  dl,xPos
	mov  dh,yPos
	call Gotoxy
	mov al," "
	call WriteChar
	ret
RefreshPlayer ENDP

; draw player to current location:
DrawPlayer PROC
	mov  dl,xPos
	mov  dh,yPos
	call Gotoxy
	mov al,"X"
	call WriteChar
	ret
DrawPlayer ENDP

HideCursor PROC
	mov  dl,40
	mov  dh,40
	call Gotoxy
	ret
HideCursor ENDP

END main