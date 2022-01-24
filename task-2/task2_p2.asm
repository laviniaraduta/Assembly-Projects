section .data
	ebx_save: dd 0
section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	push ebx 				; callee duty
	
	push ebp
	push esp				
	pop ebp					; mov ebp, esp
	
	pop ecx
	pop dword[ebx_save]
	pop edx
	
	pop eax 				; mov eax, [epb + 8]
	pop ebx 				; mov ebx, [ebp + 12]

	; remake stack 
	push ebx				; str
	push eax				; len
	push edx				; return address
	push dword[ebx_save] 	; saved value of ebx
	push ecx				; old ebp
	

	xor ecx, ecx			; the index to go through str
	xor edx, edx			; where to pop the stack
	dec eax		
				
; for i = 0 : len - 1
for:
	cmp byte[ebx + ecx], '('
	je push_on_stack
	pop edx
	cmp dl, '('				
	jne false_result		; the stack is empty
	jmp increment

push_on_stack:				; can't put only one byte, then put 4
	push dword[ebx + ecx]	; the first byte is the current bracket

increment:
	inc ecx
	cmp ecx, eax
	jl for
	
true:
	push dword 1
	jmp exit

false:						; there are remaining '(' on stack
	pop edx					; have to pop them
	cmp ebp, esp			; until the stack is finaly empty
	jne false

false_result:
	push edx				; i poped smth i shouldn't have, i put it back
	push dword 0			; the return value of the function

exit:
	pop eax
	push ebp
	pop esp					; mov esp, ebp
	pop ebp					; ebp = old ebp
	pop ebx
	ret
