section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 0, 0
	; callee saved regs
	push rbx
	push r14
	; args parsed by regs in x64
	; rdi = v1
	; rsi = n1
	; rdx = v2
	; rcx = n2
	; r8 = v
	
	xor rbx, rbx 		; rbx = temporary store values
	xor r9, r9 			; r9 = index for v1
	xor r11, r11 		; r11 = index for  v2
	xor r14, r14 		; r14 = index for v

while:
	mov ebx, dword[rdi + 4 * r9] 	; get the element from v1
	mov dword[r8 + 4 * r14], ebx	; put it in v
	inc r14

	mov ebx, dword[rdx + 4 * r11] 	; get the element from v2
	mov dword[r8 + 4 * r14], ebx	; put it in v
	inc r14

	inc r9
	inc r11
	cmp r9, rsi         			; has v1 ended? (did r9 become n1?)
	jge v1_ended
	cmp r11, rcx					; has v2 ended? (did r11 decome n2?)
	jge v2_ended
	jmp while

; I want to use the same code (the v1_ended loop) for copying the rest of
; elements from both arrays i just modify the parameters that differ.
v2_ended:							
	mov rdx, rdi					; rdx contains the array that is not finished  
	mov r11, r9						; r11 contains the index for the array that is not finished
	mov rcx, rsi					; rcx contains the length of the array that is not finished

v1_ended:							; just copy the rest of elements
	mov ebx, dword[rdx + 4 * r11]
	mov dword[r8 + 4 * r14], ebx
	inc r14
	inc r11
	cmp r11, rcx
	jge exit
	jmp v1_ended

exit:
	; restore regs
	pop r14
	pop rbx
	leave
	ret
