ChooseColor PROC
	mov	eax, 11		; generate random (0-10)
	call RandomRange	; EAX = random value
	
L_Green:				; if N = 8-10, choose green
	cmp	eax,8
	jb	L_Cyan
	mov	eax,green
	jmp	L_Finished

L_Cyan:				    ; if N = 5-7, choose cyan
	cmp	eax,5
	jb	L_Magenta
	mov	eax,cyan
	jmp	L_Finished
	
L_Magenta:
	cmp eax,3
	jb L_White
	mov eax,lightMagenta
	jmp L_Finished

L_White:				; if N = 0-2, choose white
	mov	eax,white	

L_Finished:
	ret

ChooseColor ENDP