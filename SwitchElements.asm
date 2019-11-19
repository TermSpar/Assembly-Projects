; by Ben Bollinger

INCLUDE Irvine32.inc

.data

numList BYTE 1,2,3,4,5,6,7,8,9
ArraySize = ($ - numList)
sizeMinus DWORD ?

.code
main PROC
	; get size-1
	mov ecx,ArraySize
	dec ecx
	mov sizeMinus,ecx

	; set init index to 0:
	mov ecx,0
	L1:
		; check if end of loop:
		cmp ecx,sizeMinus
		je exitL1

		; get current iteration plus one in ebx:
		mov ebx,ecx
		inc ebx
		
		; make the switch:
		mov dl,[numList+ebx]
		mov dh,[numList+ecx]
		
		mov [numList+ebx],dh
		mov [numList+ecx],dl

		inc ecx
	jmp L1

	exitL1:

	; display new array:
	mov eax,0
	mov ecx,0
	L2:
		; check if end of loop:
		cmp ecx,ArraySize
		je quit

		; display current iteration:
		mov al,[numList+ecx]
		call WriteInt
		inc ecx
	jmp L2

	quit:
	exit
main ENDP
END main