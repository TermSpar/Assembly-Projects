; by Ben Bollinger

INCLUDE Irvine32.inc

.data

strWelcome BYTE "Welcome to an x86 Assembly Game by Ben Bollinger (WASD to move, x to exit)",0
strLine BYTE "--------------------------------------------------------------------------",0

inputChar BYTE ?

xPos BYTE ?
yPos BYTE ?

xApplePos BYTE ?
yApplePos BYTE ?

isColliding BYTE 'F'
right BYTE 'F'
left BYTE 'F'
up BYTE 'F'
down BYTE 'F'

applesEaten DWORD 0
adder DWORD 2

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

	call DrawRandomApple

	; set init player position:
	mov xPos,10
	mov yPos,10

	call ReadChar
	mov inputChar,al

	; start game loop:
	gameLoop:
		call DrawAppleCont
		; delay for 80ms
		mov eax,40
		call Delay

		; read keybuffer into al:
		call ReadKey

		;------------------------------------------------------------------------------
		; make sure keybuffer only goes to inputChar if it's one of the specified keys:
		cmp al,"w"
		jne checkS
		mov inputChar,al

		checkS:
		cmp al,"s"
		jne checkA
		mov inputChar,al

		checkA:
		cmp al,"a"
		jne checkD
		mov inputChar,al

		checkD:
		cmp al,"d"
		jne skip
		mov inputChar,al

		skip:
		;------------------------------------------------------------------------------

		; check for game exit:
		cmp inputChar,"x"
		je exitGame

		; check for 'w' (up):
		cmp inputChar,"w"
		je moveUp
		
		; check for 's' (down):
		cmp inputChar,"s"
		je moveDown

		; check for 'd' (right):
		cmp inputChar,"d"
		je moveRight

		; check for 'a' (left):
		cmp inputChar,"a"
		je moveLeft
		jmp gameLoop

		; move the player up:
		moveUp:
			; clear current player location:
			call RefreshPlayer

			; decrement yPos (move up) and draw Player:
			dec yPos
			call DrawPlayer
			
			; check apple collisions:
			call CheckAppleCollision
			cmp isColliding,'T'
			jne noCollide1
			; if collision happened:
			inc applesEaten
			call DrawRandomApple
			noCollide1:

			mov right,'F'
			mov left,'F'
			mov down,'F'
			mov up,'T'

			; reset input and repeat loop:
			jmp gameLoop

		; move the player down:
		moveDown:
			; clear current player location:
			call RefreshPlayer

			; increment yPos (move down) and draw Player:
			inc yPos
			call DrawPlayer

			; check apple collisions:
			call CheckAppleCollision
			cmp isColliding,'T'
			jne noCollide2
			; if collision happened:
			inc applesEaten
			call DrawRandomApple
			noCollide2:

			mov right,'F'
			mov left,'F'
			mov down,'T'
			mov up,'F'

			; reset input and repeat loop:
			jmp gameLoop

		; move the player right:
		moveRight:
			; clear current player location:
			call RefreshPlayer

			; increment yPos (move down) and draw Player:
			inc xPos
			call DrawPlayer

			; check apple collisions:
			call CheckAppleCollision
			cmp isColliding,'T'
			jne noCollide3
			; if collision happened:
			inc applesEaten
			call DrawRandomApple
			noCollide3:

			mov right,'T'
			mov left,'F'
			mov down,'F'
			mov up,'F'

			; reset input and repeat loop:
			jmp gameLoop

		; move the player left:
		moveLeft:
			; clear current player location:
			call RefreshPlayer

			; increment yPos (move down) and draw Player:
			dec xPos
			call DrawPlayer

			; check apple collisions:
			call CheckAppleCollision
			cmp isColliding,'T'
			jne noCollide4
			; if collision happened:
			inc applesEaten
			call DrawRandomApple
			noCollide4:

			mov right,'F'
			mov left,'T'
			mov down,'F'
			mov up,'F'

			; reset input and repeat loop:
			jmp gameLoop

		jmp gameLoop

	exitGame:
	exit
main ENDP

; clear current player so to draw at new location:
RefreshPlayer PROC
	; get the previous location of the player:
	mov  dl,xPos
	mov  dh,yPos

	; as the player eats more apples, cover up less spots behind him:
	cmp applesEaten,0
	je noApples
	mov ecx,applesEaten
	playerLoop:
		cmp right,'T'
		jne goingLeft
		dec dl

		goingLeft:
		cmp left,'T'
		jne goingUp
		inc dl
		
		goingUp:
		cmp up,'T'
		jne goingDown
		inc dh

		goingDown:
		cmp down,'T'
		jne finishLoop
		dec dh

		finishLoop:
	loop playerLoop

	call DeletePlayerPixels

	cmp up,'T'
		jne checkDown
		call GetAdder
		; as the body expands, the area of deletion expands proportionally:
		push ecx
		add esi,edi
		mov ecx,esi
		upLoop1:
		dec dl
		call DeletePlayerPixels
		loop upLoop1
		pop ecx

		push ecx
		inc edi
		add esi,edi
		mov ecx,esi
		upLoop2:
		inc dl
		call DeletePlayerPixels
		loop upLoop2
		pop ecx
	checkDown:
	cmp down,'T'
	jne checkRight
		push ecx
		add applesEaten,2
		mov ecx,applesEaten
		downLoop1:
		inc dl
		call DeletePlayerPixels
		loop downLoop1
		pop ecx

		push ecx
		add applesEaten,3
		mov ecx,applesEaten
		downLoop2:
		dec dl
		call DeletePlayerPixels
		loop downLoop2
		pop ecx
		sub applesEaten,5
	checkRight:
	cmp right,'T'
		jne checkLeft
		push ecx
		add applesEaten,2
		mov ecx,applesEaten
		rightLoop1:
		dec dh
		call DeletePlayerPixels
		loop rightLoop1
		pop ecx

		push ecx
		add applesEaten,3
		mov ecx,applesEaten
		rightLoop2:
		inc dh
		call DeletePlayerPixels
		loop rightLoop2
		pop ecx
		sub applesEaten,5
	checkLeft:
	cmp left,'T'
		jne noApples
		push ecx
		add applesEaten,2
		mov ecx,applesEaten
		leftLoop1:
		inc dh
		call DeletePlayerPixels
		loop leftLoop1
		pop ecx

		push ecx
		add applesEaten,3
		mov ecx,applesEaten
		leftLoop2:
		dec dh
		call DeletePlayerPixels
		loop leftLoop2
		pop ecx
		sub applesEaten,5
	noApples:
RefreshPlayer ENDP

GetAdder PROC
	mov esi,applesEaten
	add esi,adder
	mov edi,esi
	mov esi,applesEaten
GetAdder ENDP

DeletePlayerPixels PROC
	call Gotoxy
	push eax
	; draw a blank space:
	mov eax,gray (gray * 16)
	call SetTextColor
	pop eax
	mov al," "
	call WriteChar
	ret
DeletePlayerPixels ENDP

; draw player to current location:
DrawPlayer PROC
	push eax
	mov eax,white  (white * 16)
	call SetTextColor
	pop eax

	mov  dl,xPos
	mov  dh,yPos
	call Gotoxy
	mov al,"X"
	call WriteChar
	ret
DrawPlayer ENDP

DrawAppleCont PROC
	; draw a red apple:
	push eax
	mov eax,red  (red * 16)
	call SetTextColor
	pop eax
	push edx
	mov dl,xApplePos
	mov dh,yApplePos
	call Gotoxy
	pop edx
	mov al,"X"
	call WriteChar
	ret
DrawAppleCont ENDP

DrawRandomApple PROC
	push edx
	; generate random x position:
	mov eax,30
	call RandomRange
	mov dl,al
	; generate random y position:
	mov eax,30
	call RandomRange
	mov dh,al
	call Gotoxy

	; log the apple's position:
	mov xApplePos,dl
	mov yApplePos,dh
	pop edx
	ret
DrawRandomApple ENDP

CheckAppleCollision PROC
	; if apple and player positions are equal, set isColliding to 'T'
	mov bl,xPos
	cmp xApplePos,bl
	jne notColliding

	mov bl,yPos
	cmp yApplePos,bl
	jne notColliding
	mov isColliding,'T'
	jmp exitCheck

	; otherwise set it to 'F'
	notColliding:
	mov isColliding,'F'

	exitCheck:
	ret
CheckAppleCollision ENDP

END main