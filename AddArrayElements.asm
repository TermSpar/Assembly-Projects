INCLUDE Irvine32.inc

.data

myArray DWORD 10,20,30,40
ArraySize = ($-myArray)

.code
main PROC
	
	mov ebx,0
	mov ecx,0

	L1:
		cmp ecx,ArraySize ; check if counter is greater than size of array
		jge END1 ; if it's greater, then end the loop

		add ebx,[myArray+ecx] ; add current array index to eax
		mov eax,ebx
		call WriteInt ; display current value

		add ecx,4 ; increment counter by 4 (bytes)
		jmp L1 ; restart loop
	END1:

	exit
main ENDP
END main