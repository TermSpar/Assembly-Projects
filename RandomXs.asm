; by Ben Bollinger

INCLUDE Irvine32.inc

.data

str1 BYTE "X",0

yPos BYTE ?
xPos BYTE ?

coordListX BYTE 50 DUP(?)
coordListY BYTE 50 DUP(?)

.code
main PROC

	; loop 50 times
	mov ecx,50

	call Randomize
	; draw x loop:
	L1:
		; generate random row position:
		mov eax,10
		call RandomRange
		mov yPos,al

		; log yPos:
		mov [coordListX+ecx],al

		; clear eax:
		mov eax,0

		; generate random col position:
		mov eax,100
		call RandomRange
		mov xPos,al

		; log xPos:
		mov [coordListY+ecx],al

		; draw the X:
		call DrawX
		
		loop L1
	exit
main ENDP

; input an integer
DrawX PROC
	call Locate
	mov  edx,OFFSET str1
	call WriteString
	ret
DrawX ENDP

; locate the cursor
Locate PROC
	mov  dh,yPos
	mov  dl,xPos
	call Gotoxy
	ret
Locate ENDP

END main