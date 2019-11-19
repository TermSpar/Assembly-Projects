; by Ben Bollinger

include Irvine32.inc

.data
rows = 10
cols = 10

.code
main PROC
    
	mov ecx,rows
	outterLoop:
		mov al,'*'
		call WriteChar

		mov edx,ecx
		push ecx
		mov ecx,cols
		innerLoop:
			cmp edx,cols
			je drawFirst
			jne checkSecond

			drawFirst:
			mov al,'*'
			call WriteChar
			jmp continueLoop

			checkSecond:
			cmp edx,1
			je drawSecond
			jne drawSide

			drawSecond:
			mov al,'*'
			call WriteChar
			jmp continueLoop

			drawSide:
			cmp ecx,1
			je drawEnd
			jne drawSpace

			drawEnd:
			mov al,'*'
			call WriteChar
			jmp continueLoop

			drawSpace:
			mov al,' '
			call WriteChar

			continueLoop:
		loop innerLoop
		pop ecx

		call Crlf
	loop outterLoop

	exit
main ENDP
END main