NODE_SIZE EQU 8
INT_SIZE EQU 4

section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0
	push ebx  							; save ebx and edi because i will use them
	push edi
	mov ecx, [ebp + 8]  				; n
	mov eax, [ebp + 12] 				; stuct node *node -> it is an address

	mov edx, ecx

; find the nodes in reverse order (n, n-1 ...) and push each one on the stack
; at the end just pop them one by one and connect them
for1: 									; for i = n : 1
	mov ebx, 0
for2: 									; for j = 1 : n
	cmp dword[eax + ebx * NODE_SIZE], edx
	jne increase
	lea edi, [eax + ebx * NODE_SIZE]
	push edi							; push on stack the address of the node
increase:
	inc ebx
	cmp ebx, ecx						; check if the i < n
	jl for2

	dec edx								; end when the node with value = 1 is found
	cmp edx, 1
	jge for1

	mov eax, [esp]  					; save the first node in eax
	pop edx
	dec ecx

connect: 								; connect the nodes by modifying next
	pop ebx
	mov dword[edx + INT_SIZE], ebx		; the next field is at the addr node + sizeof(value)
	mov edx, ebx
	loop connect

	; restore registers
	pop edi
	pop ebx
	leave
	ret
