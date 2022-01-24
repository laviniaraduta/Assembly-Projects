
section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	enter 	0, 0
	; calle saved registers
	push ebx
	push edi

	mov edi, [ebp + 8]		; edi = the address of the final string

	mov eax, dword 0 
	CPUID

	; now combine the result
	mov dword[edi], ebx		; ebx contains the first 4 characters 
	mov dword[edi + 4], edx ; edx contains the next 4 characters
	mov dword[edi + 8], ecx	; ecx contains the last 4 characters
	mov byte[edi + 12], 0x0	; the string terminator
	
	; restore registers
	pop edi
	pop ebx
	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise
features:
	enter 	0, 0
	; calle saved registers
	push ebx
	push edi

	mov eax, dword 1
	CPUID
	
	; the info is in ecx
	; every byte from ecx represents a feature
vmx_feature:
	mov eax, dword 1		; mask will be 1 << 5
	mov edi, [ebp + 8]
	shl eax, 5 				; vmx = the 5th bit
	and eax, ecx			; to see if the byte is set ecx & mask
	shr eax, 5				; eax will be 0 or 1
	mov dword[edi], eax

	mov eax, dword 1		; maks will be 1 << 30
	mov edi, [ebp + 12]
	shl eax, 30 			; rdrand = the 30th bit
	and eax, ecx
	shr eax, 30
	mov dword[edi], eax

	mov eax, dword 1
	mov edi, [ebp + 16]
	shl eax, 28 			; avx = the 28th bit
	and eax, ecx
	shr eax, 28
	mov dword[edi], eax

	; restore registers
	pop edi
	pop ebx
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0
	; calle saved registers
	push ebx
	push edi
	push esi

	mov eax, 80000006h
	CPUID

	; the first byte (from LSB) contains the line size
	xor edx, edx
	mov dl, cl
	mov ebx, dword[ebp + 12]
	mov dword[ebx], edx 
	
	; restore registers
	pop esi
	pop edi
	pop ebx
	leave
	ret
