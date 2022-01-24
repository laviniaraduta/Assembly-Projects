section .text
	global vectorial_ops

;; void vectorial_ops(int *s, int A[], int B[], int C[], int n, int D[])
;  
;  Compute the result of s * A + B .* C, and store it in D. n is the size of
;  A, B, C and D. n is a multiple of 16. The result of any multiplication will
;  fit in 32 bits. Use MMX, SSE or AVX instructions for this task.

vectorial_ops:
	push		rbp
	mov		rbp, rsp

	; rdi = s
	; rsi = &A
	; rdx = &B
	; rcx = &C
	; r8 = n
	; r9 = &D
	movdqa xmm0, [rsi]
	movdqa xmm1, [rdx]
	;movaps xmm2, [rdi]
	mulss xmm0, xmm1
	addps xmm0, xmm1
	movups [r9], xmm0

	leave
	ret
