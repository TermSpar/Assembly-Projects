; by Ben Bollinger

INCLUDE Irvine32.inc

.data

strLine BYTE "-----------------------------------------------------------------------------------------------------------------------",0
strScore BYTE "Your score is: ",0

inputChar BYTE ?

xPos BYTE ?
yPos BYTE ?

score BYTE 0
xCoinPos BYTE ?
yCoinPos BYTE ?

isJumping BYTE 'F'

.code
main PROC

	; set init player position:
	mov xPos,20
	mov yPos,20

	; generate random coin:
	call CreateRandomCoin

	; start game loop:
	gameLoop:
		; draw coin:
		call DrawCoin

		; coin intersections:
		mov bl,xPos
		cmp bl,xCoinPos
		jne notColliding
		mov bl,yPos
		cmp bl,yCoinPos
		jne notColliding
		; if the player gets the coin:
		inc score
		call CreateRandomCoin
		notColliding:

		; keep text normal:
		mov eax,white  (black * 16)
		call SetTextColor

		; draw score at (0,0):
		mov  dl,0
		mov  dh,0
		call Gotoxy
		mov edx,0
		mov edx,OFFSET strScore
		call WriteString
		mov dl,16
		mov al,score
		add al,'0'
		call WriteChar

		; draw ground at (0,29):
		mov  dl,0
		mov  dh,29
		call Gotoxy
		mov edx,0
		mov edx,OFFSET strLine
		call WriteString

		; gravity logic
		gravity:
		; if yPos < 27:
		cmp yPos,27
		jg onGround
		; and is not jumping:
		cmp isJumping,'F'
		jne onGround
		; the fall:
		call RefreshPlayer
		inc yPos
		call DrawPlayer
		mov eax,70
		call Delay
		jmp gravity

		; else, continue:
		onGround:

		; get user input:
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

			; set isJumping to true and delay
			mov isJumping,'T'
			mov eax,250
			call Delay
			; reset input and repeat loop and set isJumping to false:
			mov isJumping,'F'
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

DrawCoin PROC
	push eax
	mov eax,yellow  (yellow * 16)
	call SetTextColor
	pop eax
	push edx
	mov dl,xCoinPos
	mov dh,yCoinPos
	call Gotoxy
	pop edx
	mov al,"X"
	call WriteChar
	ret
DrawCoin ENDP

CreateRandomCoin PROC
	push edx
	; generate random x position:
	mov eax,55
	call RandomRange
	mov xCoinPos,al
	; set y pos to 27:
	mov yCoinPos,27
	pop edx
	ret
CreateRandomCoin ENDP

END main