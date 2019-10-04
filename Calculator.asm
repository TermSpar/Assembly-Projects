INCLUDE Irvine32.inc

.data

str1 BYTE "Enter an integer: ",0
str2 BYTE "Enter an operator: ",0

PLUS = '+'
MINUS = '-'
MULT = '*'
DIVIDE = '/'

operator BYTE ?
num1 DWORD ?
num2 DWORD ?

row  BYTE ?
col  BYTE ?

.code
main PROC
	; get numbers:
	call InputInt
	mov num1,eax
	mov ebx,num1 ; put num1 in ebx

	add row,2

	call InputInt
	mov num2,eax

	add row,2

	; get the operator:
	call InputOperator
	mov operator,al

	add row,2

	; if +
	checkPlus:
		cmp operator,PLUS
		jne checkMinus

		add ebx,num2
		mov eax,ebx
		call WriteInt

	; if -
	checkMinus:
		cmp operator,MINUS
		jne checkMult

		sub ebx,num2
		mov eax,ebx
		call WriteInt

	; if *
	checkMult:
		cmp operator,MULT
		jne checkDiv

		mov edx,0 ; clear dividend
		mov eax,num1 ; first num
		mov ecx,num2 ; second num
		mul ecx ; multiply

		call WriteInt ; result already written to eax

	; if /
	checkDiv:
		cmp operator,DIVIDE

		mov edx,0 ; clear dividend
		mov eax,num1 ; dividend
		mov ecx,num2 ; divisor
		div ecx ; divide

		call WriteInt ; result already written to eax

		jne quit

	quit:
	exit
main ENDP

; input an integer
InputInt PROC
	call Locate
	mov  edx,OFFSET str1
	call WriteString
	call ReadInt
	ret
InputInt ENDP

; input an operator
InputOperator PROC
	call Locate
	mov  edx,OFFSET str2
	call WriteString
	call ReadChar
	ret
InputOperator ENDP

; locate the cursor
Locate PROC
	mov  dh,row
	mov  dl,col
	call Gotoxy
	ret
Locate ENDP

END main