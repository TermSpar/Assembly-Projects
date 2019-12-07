; The Fibonacci Sequence by Ben Bollinger

include Irvine32.inc

.data

num1 DWORD 1
num2 DWORD 1

.code
main PROC
    
	; print first two nums:
	mov eax,0
	mov eax,num1
	call WriteInt
	call Crlf
	mov eax,num2
	call WriteInt
	call Crlf

	; print the next 20:
	mov ecx,20
	L1:
		; add num1 and num2:
		mov eax,num1
		add eax,num2
		call WriteInt
		call Crlf

		; set num1 to the value of num2:
		mov edx,num2
		mov num1,edx

		; set num2 to the previous (num1+num2):
		mov num2,eax
	loop L1

    exit
main ENDP

END main
