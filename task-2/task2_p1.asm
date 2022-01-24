section .data
	ebx_save: dd 0
section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple for 2 numbers, a and b
cmmmc:
	push ebx 				; callee duty
	
	; create the frame of the function
	push ebp
	push esp				
	pop ebp					; mov ebp, esp
	
	pop ecx
	pop dword[ebx_save]
	pop edx
	
	pop eax 				; mov eax, [epb + 8]
	pop ebx 				; mov ebx, [ebp + 12]

	; remake stack 
	push ebx				; b
	push eax				; a
	push edx				; return address
	push dword[ebx_save] 	; saved value of ebx
	push ecx				; old ebp

; save the product a * b on stack
multiply_a_and_b:
	push eax				
	pop ecx
	imul ecx, ebx			; ecx = a * b
	push ecx				

	; will use the formula: a * b = gdc(a, b) * lcm(a, b)
gcd:
	cmp eax, ebx			; subtract the smaller number from the other
	je lcm					; until they are equal
	jl ebx_greater
	sub eax, ebx
	jmp gcd

ebx_greater:
	sub ebx, eax
	jmp gcd

lcm:						; lcm = (a * b) / gcd
	pop eax					; eax = gcd
	push dword 0			; for working division
	pop edx					; ebx = a * b
	idiv ebx				; ebx / eax then store the result in eax

	push ebp
	pop esp					; mov esp, ebp
	pop ebp					; ebp = old ebp
	pop ebx
	ret
