;Author: Daniel Schuster
;Prime number generator using the Sieve of Eratosthenes algorithm

extern printf			;C functions
extern scanf
extern malloc
extern free

global main				

section .bss			
	array: resd 1 		;this will act as a pointer to a dynamically allocated array
	bound: resd 1		;this will be the upper bound to find primes up to

section .data
	p: dd 2				;prime candidate, start at 2

section .rodata
	fmt_prompt:	db "Enter the upper bound of the prime numbers: ", 0
	fmt_input: db "%d", 0
	fmt_output: db 10, "%d", 0
	fmt_oob:	db 10, "Upper bound is out of bounds [10 - 2000000000]", 10, 0
	fmt_nl: db 10, 0

section .text

main:
	;set up stack frame
	push	ebp
	mov	ebp, esp

	;print input prompt
	push 	dword fmt_prompt 
	call 	printf
	add 	esp, 4

	;get input for upper bound
	push 	bound
	push	dword fmt_input
	call 	scanf
	add 	esp, 4

	;check bounds, print message and exit if >2billion or <10
	mov	ebx, [bound]
	mov	eax, 2000000000
	cmp	ebx, eax
	jg		.oob
	mov	eax, 10
	cmp	ebx, eax
	jl		.oob

	;allocate memory on heap for an array of <bound+1> bytes (ebx has upper bound)
	inc	ebx
	push	ebx
	call	malloc
	add	esp, 4
	mov	[array], eax ;save address of the array to memory
	dec	ebx

	;loop to initialize array to zeros (eax has array address, ebx has upper bound)
	mov	ecx, 0
.loop1:
	mov	[eax + ecx], byte 0
	inc	ecx
	cmp	ecx, ebx
	jle	.loop1

	;loop to mark multiples of current p value (eax has array address, ebx has upper bound)
.mark:
	mov 	ecx, [p] 
	mov	edx, ecx 
.loop2:
	add	edx, ecx
	cmp	edx, ebx  
	jg		.done2
	mov	[eax + edx], byte 1
	jmp	.loop2
.done2:

	;loop to find next p (eax has array address, ebx has upper bound, ecx has p)
.loop3:
	inc	ecx
	cmp	ecx, ebx
	jge	.done3
	cmp	[eax + ecx], byte 1
	je		.loop3 ;continue incrementing until unmarked value found
.done3:
	mov	[p], ecx
	imul	ecx, ecx
	cmp	ecx, ebx	
	jl		.mark ;continue marking multiples while p^2 < bound

	;loop to print all unmarked values, start at 2 (eax has array address, ebx has upper bound)
	mov 	ecx, 2
.loop4:
	push	ecx ;push values of ecx and eax to stack since printf affects them
	push	eax
	push	ecx ;now push the 2 arguments to printf
	push	dword fmt_output
	call	printf
	add	esp, 8
	pop	eax ;get back the initial ecx and eax values
	pop	ecx
.increment:
	cmp	ecx, ebx
	jge	.done4
	inc	ecx
	cmp	[eax + ecx], byte 0
	je		.loop4 ;unmarked, print the value
	jmp	.increment ;marked, don't print the value
.done4:
	
	;print a newline to match whitespace with expected output
	push	dword fmt_nl 
	call	printf
	add	esp, 4

	jmp	.exit

.oob:
	push	dword fmt_oob
	call	printf
	add 	esp, 4

.exit:
	;deallocate heap memory 
	push	dword [array]
	call	free
	add	esp, 4
	
	;takedown stack frame
	mov	esp, ebp
	pop	ebp

	;return 0 for normal program exit
	mov	eax, 0
	ret
