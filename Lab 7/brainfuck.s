.bss
VARIABLES: .skip 4069 # reserving space for BF numbers
LOOPRETURNS: .skip 1024 # reserving space for loop return adresses

.global brainfuck

.text

# brainfuck functions
BFincrement:
   incq VARIABLES(%rbx)
   jmp beginloop

BFdecrement:
   decq VARIABLES(%rbx)
   jmp beginloop

BFincPointer:
   addq $8, %rbx
   jmp beginloop

BFdecPointer:
   subq $8, %rbx
   jmp beginloop

BFprint:
	pushq %rdi
	movq VARIABLES(%rbx), %rdi
	pushq %rbx
	pushq %r10
	pushq %rbp
	movq %rsp, %rbp
	call putchar
	movq %rbp, %rsp
	popq %rbp
	popq %r10
	popq %rbx
	popq %rdi
	jmp beginloop

BFscan:
   pushq %rdi
   pushq %rbx
   pushq %r10
   pushq %rbp
   movq %rsp, %rbp
   call getchar
   movq %rbp, %rsp
   popq %rbp
   popq %r10
   popq %rbx
   popq %rdi
   movq %rax, VARIABLES(%rbx)
   jmp beginloop

BFstartloop:
	movq $1, %r9
   cmpq $0, VARIABLES(%rbx)
   je BFskiploop
   movq %rdi, LOOPRETURNS(%r10)
   addq $8, %r10
   jmp beginloop
BFskiploop:          # skipping loop if value is already zero
   incq %rdi

	movb (%rdi), %r15b
   cmpb $91, (%rdi)
   je BFinloop

   cmpb $93, (%rdi)
   je BFoutloop

   jmp BFskiploop

BFskipcheck:
   cmpq $0, %r9
   je beginloop
   jmp BFskiploop

BFinloop:
   incq %r9
   jmp BFskipcheck

BFoutloop:
   decq %r9
   jmp BFskipcheck


BFendloop:
   movq VARIABLES(%rbx), %r15
   cmpq $0, VARIABLES(%rbx)
   je BFexitloop
   movq LOOPRETURNS-8(%r10), %rdi
   jmp beginloop
BFexitloop:
   subq $8, %r10
   jmp beginloop

brainfuck:
	pushq %rbp
	movq %rsp, %rbp

	# initializing pointers
   movq $0, %r10
   movq $0, %rbx
	decq %rdi

	beginloop:
		incq %rdi
      break:
      cmpb $43, (%rdi)
      je BFincrement
      notbroken:
      cmpb $45, (%rdi)
      je BFdecrement

      cmpb $62, (%rdi)
      je BFincPointer

      cmpb $60, (%rdi)
      je BFdecPointer

		cmpb $0, (%rdi)
		je end

      cmpb $46, (%rdi)
      je BFprint

      cmpb $44, (%rdi)
      je BFscan

      cmpb $91, (%rdi)
      je BFstartloop

      cmpb $93, (%rdi)
      je BFendloop

		jmp beginloop

	end:
	movq %rbp, %rsp
	popq %rbp
	ret
