; by Ben Bollinger

INCLUDE Irvine32.inc

.data

row BYTE ?
col BYTE ?

rows = 30
cols = 30
numOfElements = (rows * cols)

coordList DWORD numOfElements DUP(0)
coordPos DWORD ?

.code
main PROC

	; loop x times
	mov ecx,7000

	call Randomize
	; draw x loop:
	L1:
		call RandomCoords

		; get coord position ((row-1) * cols) + col:
		dec row
		mov al,row
		push ecx
		mov ecx,cols
		mul ecx
		pop ecx
		add al,col

		; fix to a weird bug:
		cmp eax,numOfElements
		jae weirdBug

		; increment value at position:
		inc [coordList+eax]
		mov coordPos,eax
		mov eax,[coordList+eax]
		add al,'0'

		; if number > 9 then reset to 0:
		cmp al,'9'
		jl lessNine
		mov edx,coordPos
		mov [coordList+edx],0
		mov eax,[coordList+edx]
		add al,'0'

		; if number < 9, just draw it as is:
		lessNine:
		call DrawNum

		mov eax,1
		call Delay
	
	weirdBug:
	loop L1

	call ReadChar
	exit
main ENDP

; write the number:
DrawNum PROC
	call Locate
	push eax
	call ChooseColor
	pop eax
	call WriteChar
	ret
DrawNum ENDP

; position the cursor
Locate PROC
	mov  dh,row
	mov  dl,col
	call Gotoxy
	ret
Locate ENDP

RandomCoords PROC
	; generate random row position:
	mov eax,rows
	call RandomRange
	mov row,al

	; generate random col position:
	mov eax,cols
	call RandomRange
	mov col,al
RandomCoords ENDP

ChooseColor PROC
	; generate random forecolor:
	mov	eax,15
	call RandomRange	
	inc eax
	call SetTextColor
	ret
ChooseColor ENDP

END main