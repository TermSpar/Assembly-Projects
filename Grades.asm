include Irvine32.inc

.data
str1 BYTE ": The letter grade is ",0
grade BYTE ?

.code
main PROC
    call Randomize

    mov ecx,10 ; repeat loop 10 times
again:
    ; Save loop counter
	push ecx
	; Generate a random number between 50 and 100.
	; If you move 51 to eax before calling RandomRange,
	; you will generate a random number between 0 and 50.
	; Add 50 to eax to generate a number between 50 and 100.
	; Use WriteDec to output the random number that will be used to calculate a letter grade.
    ; INSERT CODE HERE-->
	mov eax,51
	call RandomRange
	add eax,50
	call WriteDec
	
    call CalcGrade          ; returns the grade in AL
	; Save the grade returned from CalcGrade as grade.
	; Use WriteString to display the value of str1.
	; You will need to move the OFFSET of str1 to edx before calling WriteString.
	; Return the grade back to the al register and display it by calling WriteChar.
	; Generate a carriage control line feed.
	; INSERT CODE HERE-->
    mov edx,OFFSET str1
	call WriteString
	call WriteChar
	call Crlf

    ; Restore the loop counter.
	pop ecx
	; INSERT CODE HERE-->
    loop again

	exit
main ENDP

CalcGrade PROC
; Calculates a letter grade
; Receives: EAX = numeric grade
; Returns:  AL = letter grade

Grade_A:
; The eax register contains the numeric grade.
; Add code to compare eax against 90 and jump to Grade_B if eax is less than 90.
; If eax is not less than 90, move an A to al and jump to finished.
; INSERT CODE HERE-->
cmp eax,90
jl Grade_B
mov al,'A'
jmp finished

Grade_B:
; INSERT CODE HERE to test for a B.
cmp eax,80
jl Grade_C
mov al,'B'
jmp finished
	
Grade_C:
; INSERT CODE HERE to test for a C.
cmp eax,70
jl Grade_D
mov al,'C'
jmp finished

Grade_D:
; INSERT CODE HERE to test for a D.
cmp eax,60
jl Grade_F
mov al,'D'
jmp finished

Grade_F:
; INSERT CODE HERE for a default grade of F.
mov al,'F'

finished:
    ret
CalcGrade ENDP

END main