; by Ben Bollinger

INCLUDE Irvine32.inc

.data

str1 BYTE "Enter an integer: "
row  BYTE ?
col  BYTE ?

myArray DWORD 4 DUP(?)
ArraySize = ($-myArray) ; get size of array

.code
main PROC
	mov ecx,0 ; reset ecx

	; get array values loop:
	L1:
		; loop the size of the array:
		cmp ecx,ArraySize
		jge END1

		; input values:
		call Input
		add [myArray+ecx],eax
		add row,1

		add ecx,4
		jmp L1
	END1:

	mov ebx,0 ; set ebx to 0
	mov ecx,0 ; set ecx to 0

	L2:
		cmp ecx,ArraySize ; check if counter is greater than size of array
		jge END2 ; if it's greater, then end the loop

		add ebx,[myArray+ecx] ; add current array index to eax
		mov eax,ebx ; move new value to display register
		call WriteInt ; display current value

		add ecx,4 ; increment counter by 4 (bytes)
		jmp L2 ; restart loop
	END2:

	exit
main ENDP

; input an integer
Input PROC
	call Locate
	mov  edx,OFFSET str1
	call WriteString
	mov edx,0
	call ReadInt
	ret
Input ENDP

; locate the cursor
Locate PROC
	mov  dh,row
	mov  dl,col
	call Gotoxy
	ret
Locate ENDP

END main