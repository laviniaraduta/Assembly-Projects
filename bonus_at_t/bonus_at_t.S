#include "positions.h"
.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v3)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the values provided in positions.S, as described
 * in the task
 */

add_vect:
	pushl 	%ebp
	movl	%esp, %ebp
	/* callee saved registers */
	push 	%ebx
	push 	%edi
	push 	%esi

	movl 	8(%ebp), %ebx		/* v1 at ebp + 8 */
	movl 	12(%ebp), %edx		/* v2 at ebp + 12 */
	movl 	16(%ebp), %ecx		/* n at ebp + 16 */
	movl 	20(%ebp), %edi		/* v3 at ebp + 20 */

	xor 	%eax, %eax			/* index to go through arrays */

/* calculate the sum in esi */
while:								
	movl	(%ebx, %eax, 4), %esi	/* every element is at ebx + 4 * eax (ints) */
	add		(%edx, %eax, 4), %esi
    movl	%esi, (%edi, %eax, 4)
	inc		%eax
  	cmp 	%ecx, %eax
 	jl		while

sub_first_value:
	/* calculate the scaled position in eax */
 	movl 	%ecx, %eax  
 	xor 	%ebx, %ebx
 	movl 	$FIRST_POSITION, %ebx
 	imul 	%ebx, %eax  			/* eax = n * FIRST_POS */
 	movl 	$10, %ebx
 	xor 	%edx, %edx				/* for division */
 	idiv 	%ebx  					/* eax = eax / 10 = (n * FIRST_POS) / 10 */
 	sub		$FIRST_VALUE, (%edi, %eax, 4)

sub_second_value:
	/* calculate the scaled position in eax */
 	movl 	%ecx, %eax  
 	xor 	%ebx, %ebx
 	movl 	$SECOND_POSITION, %ebx
 	imul 	%ebx, %eax  			/* eax = n * SECOND_POS */
 	movl 	$10, %ebx
 	xor 	%edx, %edx				/* for division */
 	idiv 	%ebx   					/* eax = eax / 10 = (n * SECOND_POS) / 10 */
 	sub		$SECOND_VALUE, (%edi, %eax, 4)

sub_third_value:
	/* calculate the scaled position */
 	movl 	%ecx, %eax  
 	xor 	%ebx, %ebx
 	movl 	$THIRD_POSITION, %ebx
 	imul 	%ebx, %eax  			/* eax = n * THIRD_POS */
 	movl 	$10, %ebx
 	xor 	%edx, %edx				/* for division */
 	idiv 	%ebx   					/* eax = eax / 10 = (n * THIRD_POS) / 10 */
 	sub		$THIRD_VALUE, (%edi, %eax, 4)

	/* restore registers */
	pop 	%esi
	pop 	%edi
	pop 	%ebx
	leave
	ret
