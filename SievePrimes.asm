; Chapter 7 Exercise 5: Prime Numbers

;Comment !
;Write a program that generates all prime numbers between 2 and 1000, 
;using the Sieve of Eratosthenes method. You can find many articles that 
;describe the method for finding primes in this manner on the Internet. 
;Display all the prime values.
;!

INCLUDE Irvine32.inc

PrintPrimes PROTO,
	count:DWORD			; number of values to display

FIRST_PRIME = 2
LAST_PRIME = 20		; try a larger array than 65,000

.data
commaStr BYTE ", ",0

.data?
sieve BYTE LAST_PRIME DUP(?)

.code
main PROC
	; initialize the array to zeros
	mov	ecx,LAST_PRIME		; set ecx to LAST_PRIME
	mov	edi,OFFSET sieve	; set edi to the first element in sieve array

	; sets direction flag to zero so edi and esi are incremented:
	mov	al,0			
	cld					
	rep	stosb				

	mov esi,FIRST_PRIME

	; loop through all primes from FIRST_PRIME to LAST_PRIME:
	.WHILE esi < LAST_PRIME
	; if the current iteration (esi) equals zero then it's a prime number (if marked then 1, if not then 0):
	  .IF sieve[esi*TYPE sieve] == 0	
	    call MarkMultiples
	  .ENDIF
	  inc esi							
	.ENDW

	INVOKE PrintPrimes, LAST_PRIME		

	exit
main ENDP

;--------------------------------------------------
MarkMultiples PROC
;
; Mark all multiples of the value passed in ESI.
; Notice we use ESI as the prime value, and
; take advantage of the "scaling" feature of indirect
; operands to locate the address of the indexed item:
; [esi*TYPE sieve]
;--------------------------------------------------

	; double the value of the current iteration and save the registers, determines first multiple:
	push eax
	push esi
	mov  eax,esi				
	add  esi,eax				

	; gets the multiples of the prime numbers and marks them as 1:
L1:	cmp	esi,LAST_PRIME			
	ja	L2					
	mov	sieve[esi*TYPE sieve],1	
	add	esi,eax
	jmp	L1				

	; exit the procedure and restore registers:
L2:	pop	esi
	pop	eax
	ret
MarkMultiples ENDP


;--------------------------------------------------
PrintPrimes PROC,
	count:DWORD	; number of values to display
;
; Display the list of prime numbers
;--------------------------------------------------
	mov	esi,1
	mov	eax,0
	mov	ecx,count ; value of last prime

	; putting the second element of sieve into al
L1:	mov al,sieve[esi*TYPE sieve]
	; if current iter has been marked as 0, the  it's prime:
	.IF al == 0
	; then write it to the screen:
	  mov  eax,esi
	  call WriteDec
	  mov  edx,OFFSET commaStr
	  call WriteString
	.ENDIF
	inc	esi
	; keep looping until LAST_PRIME:
	loop L1

	ret
PrintPrimes ENDP


END main
